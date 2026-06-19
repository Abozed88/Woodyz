import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:woodyz/features/home/artHome.dart';
import 'dart:convert' as convert;
import 'dart:io';

import '../home/custHome.dart';

class User {
  int id;
  String name;
  String email;
  String password;
  String link;
  String type;
  String location;

  set setId(int id) => this.id = id;

  User({
    this.id = 0,
    required this.name,
    required this.email,
    required this.password,
    required this.link,
    required this.type,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'link': link,
      'type': type,
      'location': location,
    };
  }
}

class Customer extends User {
  String? phone;
  String? address;
  String? image;

  Customer({
      this.phone, this.address, this.image,
      required super.name, required super.email, required super.password,
      required super.link, required super.type, required super.location, required super.id
  });

  Customer.fromUser(User user,) : super(id: user.id, name: user.name, email: user.email, password: user.password, link: user.link, type: user.type, location: user.location);

  @override
  set setId(int id) => this.id = id;

  set setphone(String phone) => this.phone = phone;
  set setaddress(String address) => this.address = address;
  set setimage(String image) => this.image = image;

  @override
  String toString() {
    return 'Customer(phone: $phone, address: $address, image: $image, name: $name, email: $email, password: $password, link: $link, type: $type, location: $location)';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'link': link,
      'type': type,
      'location': location,
      'phone' : phone,
      'address' : address,
    };
  }
}

class Artisan extends User {
  String? shop;
  List<String>? skills;
  String? image;
  double? rating;

  Artisan({
    this.shop, this.skills = const [], this.image, this.rating,
    required super.name, required super.email, required super.password,
    required super.link, required super.type, required super.location, required super.id
  });

  Artisan.fromUser(User user,) : super(id: user.id, name: user.name, email: user.email, password: user.password, link: user.link, type: user.type, location: user.location);

  @override
  set setId(int id) => this.id = id;
  set setshop(String shop) => this.shop = shop;
  set setskills(List<String> skills) => this.skills = skills;
  set setrating(double rating) => this.rating = rating;
  set setimage(String image) => this.image = image;

  @override
  String toString() {
    return 'Customer(shop: $shop skills: $skills, rating: $rating, image: $image, name: $name, email: $email, password: $password, link: $link, type: $type, location: $location)';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'link': link,
      'type': type,
      'location': location,
      'shop' : shop,
      'skills' : skills,
      'rating' : rating,
    };
  }
}

const String baseUrl = "http://localhost/woodyz";
const storage = FlutterSecureStorage();

void navigateBasedOnRole(Map<String, dynamic> data, BuildContext context) {
  if (data['role'] == 'cust') {
    Customer c = Customer(
        id: int.parse(data['user_id'].toString()),
        name: data['name'],
        email: data['email'],
        password: data['password'],
        link: data['face_link'],
        type: data['role'],
        location: data['location'],
        image: data['cust_image'],
        phone: data['phone'],
        address: data['address']);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(customer: c)));
  } else if (data['role'] == 'art') {
    Artisan a = Artisan(
      id: int.parse(data['user_id'].toString()),
      name: data['name'],
      email: data['email'],
      password: data['password'],
      link: data['face_link'],
      type: data['role'],
      location: data['location'],
      image: data['art_image'],
      shop: data['shop'],
      skills: List<String>.from(data['skills'].toString().split(',')),
      rating: double.parse(data['rating'].toString()),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Arthome(artisan: a)));
  }
}

Future<void> login({
  required User u,
  required BuildContext context,
}) async {
  String url = "$baseUrl/login.php";
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        "email": u.email,
        "password": u.password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = convert.jsonDecode(response.body);

      if (data['status'] == 'success') {
        await storage.write(key: "user_session", value: convert.jsonEncode(data));
        print("Login successful: ${response.body}");
        navigateBasedOnRole(data, context);
      } else {
        print("Login failure: ${data['message']}");
        ScaffoldFeatureController<SnackBar, SnackBarClosedReason> error =
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error in login"),
            backgroundColor: Colors.black54,
            showCloseIcon: true,
            closeIconColor: Color.fromRGBO(252, 184, 25, 1),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } else {
      print("Server error: ${response.statusCode}");
      ScaffoldFeatureController<SnackBar, SnackBarClosedReason> error =
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error in login"),
          backgroundColor: Colors.black54,
          showCloseIcon: true,
          closeIconColor: Color.fromRGBO(252, 184, 25, 1),
          duration: Duration(seconds: 4),
        ),
      );
    }
  } catch (e) {
    print("Error connecting to the server: $e");
    ScaffoldFeatureController<SnackBar, SnackBarClosedReason> error =
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error in login"),
        backgroundColor: Colors.black54,
        showCloseIcon: true,
        closeIconColor: Color.fromRGBO(252, 184, 25, 1),
        duration: Duration(seconds: 4),
      ),
    );
  }
}

class AuthController {
  static const String _baseUrl = "http://localhost/woodyz";
  final BuildContext context;

  AuthController({required this.context});

  Future<void> _persistSessionAndNavigate(Map<String, dynamic> sessionData) async {
    await storage.write(key: "user_session", value: convert.jsonEncode(sessionData));
    navigateBasedOnRole(sessionData, context);
  }

  Future<String> upload(User u, File image, String uid, String role) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/uploadProfile.php'),
    );

    request.fields['user_id'] = uid;
    request.fields['role'] = role;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(resBody);
      return data['image_link'] ?? "";
    } else {
      return "";
    }
  }

  Future<Artisan?> signupArt({required Artisan a, required File? image}) async {
    String url = "$_baseUrl/addUser.php";

    try {
      Map<String, String> requestBody = {
        'name': a.name,
        'email': a.email,
        'password': a.password,
        'type': a.type,
        'location': a.location,
        'link': a.link,
        'shop': a.shop ?? "",
        'skills': a.skills?.join(',') ?? "",
      };

      final response = await http.post(Uri.parse(url), body: requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        if (data["user_id"] == null) return null;

        String userId = data["user_id"].toString();
        a.id = int.parse(userId);
        String uploadedImageUrl = "";

        if (image != null) {
          uploadedImageUrl = await upload(a, image, userId, a.type);
        }

        Map<String, dynamic> sessionData = {
          'status': 'success',
          'role': 'art',
          'user_id': userId,
          'name': a.name,
          'email': a.email,
          'password': a.password,
          'face_link': a.link,
          'location': a.location,
          'art_image': uploadedImageUrl,
          'shop': a.shop,
          'skills': a.skills?.join(','),
          'rating': a.rating ?? 0.0,
        };

        await _persistSessionAndNavigate(sessionData);
        return a;
      }
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<User?> signupCust({required Customer c, required File? image}) async {
    String url = "$_baseUrl/addUser.php";

    try {
      Map<String, String> requestBody = {
        'name': c.name,
        'email': c.email,
        'password': c.password,
        'type': c.type,
        'location': c.location,
        'link': c.link,
        'phone': c.phone ?? "",
        'address': c.address ?? "",
      };

      final response = await http.post(Uri.parse(url), body: requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        if (data["user_id"] == null) return null;

        String userId = data["user_id"].toString();
        c.id = int.parse(userId);
        String uploadedImageUrl = "";

        if (image != null) {
          uploadedImageUrl = await upload(c, image, userId, c.type);
        }

        Map<String, dynamic> sessionData = {
          'status': 'success',
          'role': 'cust',
          'user_id': userId,
          'name': c.name,
          'email': c.email,
          'password': c.password,
          'face_link': c.link,
          'location': c.location,
          'cust_image': uploadedImageUrl,
          'phone': c.phone,
          'address': c.address,
        };

        await _persistSessionAndNavigate(sessionData);
        return c;
      }
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
