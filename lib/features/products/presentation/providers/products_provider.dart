import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/products/domain/entities/product_entity.dart';

export 'package:woodyz/features/products/domain/entities/product_entity.dart';

final supabase = sb.Supabase.instance.client;

class ProductsProvider {
  Future<List<Product>> fetchData(int page, int limit, String category,
      String? query, String? artisanId) async {
    try {
      var request = supabase
          .from('products')
          .select('*, product_images(*)')
          .eq('is_available', true);

      if (category != "all") {
        request = request.eq('category', category);
      }

      if (query != null && query.isNotEmpty) {
        request = request.ilike('title', '%$query%');
      }

      if (artisanId != null && artisanId.isNotEmpty) {
        request = request.eq('artisan_id', artisanId);
      }

      final response = await request
          .order('created_at', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error in fetchData: $e");
      rethrow;
    }
  }

  Future<Artisan> fetchArtisanData(String artisanId) async {
    try {
      final profileData = await supabase
          .from('profiles')
          .select('*, artisans(*)')
          .eq('id', artisanId)
          .single();

      return Artisan.fromJson(profileData);
    } catch (e) {
      throw Exception("Error fetching artisan data: $e");
    }
  }

  Future<Product?> addProduct(Product p, File? image) async {
    try {
      final productData = await supabase
          .from('products')
          .insert(p.toJson())
          .select()
          .single();

      final newProduct = Product.fromJson(productData);

      if (image != null) {
        final fileExt = image.path.split('.').last;
        final fileName = '${newProduct.id}-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
        final filePath = fileName;

        await supabase.storage.from('product-images').upload(
              filePath,
              image,
              fileOptions: const sb.FileOptions(cacheControl: '3600', upsert: false),
            );

        final String publicUrl =
            supabase.storage.from('product-images').getPublicUrl(filePath);

        await supabase.from('product_images').insert({
          'product_id': newProduct.id,
          'image_url': publicUrl,
          'storage_path': filePath,
          'is_primary': true,
        });
        
        newProduct.imageUrl = publicUrl;
      }
      return newProduct;
    } catch (e) {
      debugPrint("Error in addProduct: $e");
      return null;
    }
  }

  Future<bool> saveProduct(int productId, String userId) async {
    try {
      await supabase.from('favorites').insert({
        'user_id': userId,
        'product_id': productId,
      });
      return true;
    } catch (e) {
      debugPrint("Error in saveProduct: $e");
      return false;
    }
  }

  Future<bool> unsaveProduct(int productId, String userId) async {
    try {
      await supabase
          .from('favorites')
          .delete()
          .match({'user_id': userId, 'product_id': productId});
      return true;
    } catch (e) {
      debugPrint("Error in unsaveProduct: $e");
      return false;
    }
  }

  Future<List<Product>> fetchSaved(int page, int limit, String userId) async {
    try {
      final response = await supabase
          .from('favorites')
          .select('product_id, products(*, product_images(*))')
          .eq('user_id', userId)
          .range(page * limit, (page + 1) * limit - 1);

      return (response as List)
          .map((json) => Product.fromJson(json['products']))
          .toList();
    } catch (e) {
      debugPrint("Error in fetchSaved: $e");
      rethrow;
    }
  }
}
