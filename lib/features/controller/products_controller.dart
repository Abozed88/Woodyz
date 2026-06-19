import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'auth_controller.dart';
import 'dart:convert';

class Product {
  int? pid;
  int? artid;
  String? name;
  String? description;
  double? price;
  int? stock;
  String? category;
  String? img;
  String? date;
  String? link;

  Product.init();
  Product (this.pid, this.artid, this.name, this.description, this.price, this.stock, this.category, this.img,this.date, this.link);
}


List<Product> products = [];

class Products_controller {
  static const String _baseUrl = "http://localhost/woodyz";

  Future<List<Product>> fetchData(int page, int limit, String category, String? query, int? artid) async {
    try {
      query == null ? query = "" : query = query;
      artid == null ? artid = 0 : artid = artid;
      final response = await http.get(
        Uri.parse("$_baseUrl/getProducts.php?page=$page&limit=$limit&category=$category&query=$query&artid=$artid"),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        List<Product> loadedProducts = [];

        for (var item in jsonData) {
          Product p = Product(
            int.parse(item['product_id'].toString()),
            int.parse(item['artisian_id'].toString()),
            item['name'].toString(),
            item['description'].toString(),
            double.parse(item['price'].toString()),
            int.parse(item['stock_q'] ?? item['stock'].toString()), // Check key name
            item['category'].toString(),
            item['image_url'].toString(),
            item['created_at'].toString(),
            item['face_link'].toString(),
          );
          loadedProducts.add(p);
        }
        return loadedProducts;
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchData: $e");
      rethrow;
    }
  }

  Future<Artisan> fetchArtisanData(int artisanId) async {
    final url = Uri.parse("$_baseUrl/getArtisanById.php");
    try {
      final response = await http.post(
        url,
        body: {
          "artisan_id": artisanId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if(result['status'] == 'success') {
          final Map<String, dynamic> data = result["data"];
          final Artisan artisan = Artisan(
          id: int.parse(data['art_id'].toString()),
          name: data['name'].toString(),
          email: data['email'].toString(),
          password: data['password'].toString(),
          type: data['role'].toString(),
          shop: data['shop_name'].toString(),
          location: data['location'].toString(),
          link: data['face_link'].toString(),
          skills: List<String>.from(data['skills'].toString().split(',')),
          image: data['art_image'] == null ? "" : "$_baseUrl/images/${data['art_image'].toString()}",
          rating: double.parse(data['rating'].toString()),
          );
          return artisan;
        }
        print(response.body);
        throw Exception("Failed to load artisan data. Status: ${result['message']}");
      } else {
        throw Exception("Failed to load artisan data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching artisan data: $e");
    }
  }

  Future<Product> addProduct(Product p, File? image) async {
    final url = Uri.parse("$_baseUrl/addProduct.php");
    try {
      final response = await http.post(
        url,
        body: {
          "artisan_id": p.artid.toString(),
          "name": p.name,
          "description": p.description,
          "price": p.price.toString(),
          // "stock": p.stock.toString(),
          "category": p.category,
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result is Map && result.containsKey('success')) {
          print("Adding product successful: ${result['success']} / ${p.toString()}");
          p.pid = result['product_id'];
          if (image != null){
            String status = await upload(p, image);
            if (status == 'success') {
              print("uploading image success!");
              p.pid = result['product_id'];
            }
            if(status == 'failure'){
              print("uploading image failed! ${result['error']}");
              p.pid = null;
            }
          }
        } else {
          print("PHP returned success 200 but unexpected JSON format: $result");
        }
      } else {
        print("Adding product failed with status: ${response.statusCode}");
      }
      return p;
    } catch (e) {
      print("Error in addProduct: $e");
      return p;
    }
  }

  Future<bool> saveProduct (Product p, User u) async{
    final url = Uri.parse("$_baseUrl/addSaved.php");
    try {
      final response = await http.post(
        url,
        body: {
          "customer_id": u.id.toString(),
          "product_id" : p.pid.toString()
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result is Map && result.containsKey('success')) {
          print("Saving product successful: ${result['success']}");
          return true;
        } else {
          print("PHP returned success 200 but unexpected JSON format: $result");
        }
      } else {
        print("Saving product failed with status: ${response.statusCode}");
      }
    }catch(e){
      print("Error in saveProduct: $e");
      return false;
    }
    return false;
  }

  Future<bool> unsaveProduct (Product p, User u) async{
    final url = Uri.parse("$_baseUrl/deleteSaved.php");
    try {
      final response = await http.post(
        url,
        body: {
          "customer_id": u.id.toString(),
          "product_id" : p.pid.toString()
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result is Map && result.containsKey('success')) {
          print("Unsaving product successful: ${result['success']}");
          return true;
        } else {
          print("PHP returned success 200 but unexpected JSON format: $result");
        }
      } else {
        print("Unsaving product failed with status: ${response.statusCode}");
      }
    }catch(e){
      print("Error in unsaveProduct: $e");
      return false;
    }
    return false;
  }

  Future<List<Product>> fetchSaved(int page, int limit, int id) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/getSaved.php?page=$page&limit=$limit&customer_id=$id"),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        List<Product> loadedProducts = [];

        for (var item in jsonData) {
          Product p = Product(
            int.parse(item['product_id'].toString()),
            int.parse(item['artisian_id'].toString()),
            item['name'].toString(),
            item['description'].toString(),
            double.parse(item['price'].toString()),
            int.parse(item['stock_q'] ?? item['stock'].toString()), // Check key name
            item['category'].toString(),
            item['image_url'].toString(),
            item['created_at'].toString(),
            item['face_link'].toString(),
          );
          loadedProducts.add(p);
        }
        return loadedProducts;
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchData: $e");
      rethrow;
    }
  }

  Future<String> upload(Product p, File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost/woodyz/uploadProductImage.php'),
    );

    request.fields['product_id'] = p.pid.toString();
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(resBody);
      p.img = data['image_link'];
      return data['status']; // "success" or error
    } else {
      return 'failure: ${response.statusCode}';
    }
  }
}