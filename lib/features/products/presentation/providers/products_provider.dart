import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/products/domain/entities/product_entity.dart';
import 'package:woodyz/features/products/domain/entities/review_entity.dart';

export 'package:woodyz/features/products/domain/entities/product_entity.dart';
export 'package:woodyz/features/products/domain/entities/review_entity.dart';

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

  Future<Product?> fetchProductById(int productId) async {
    try {
      final response = await supabase
          .from('products')
          .select('*, product_images(*)')
          .eq('id', productId)
          .single();
      return Product.fromJson(response);
    } catch (e) {
      debugPrint("Error in fetchProductById: $e");
      return null;
    }
  }

  Future<List<Review>> fetchReviews(int productId) async {
    try {
      final response = await supabase
          .from('product_reviews')
          .select('*, profiles(*)')
          .eq('product_id', productId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Review.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error in fetchReviews: $e");
      return [];
    }
  }

  Future<bool> addReview(int productId, String userId, double rating, String review) async {
    try {
      await supabase.from('product_reviews').insert({
        'product_id': productId,
        'user_id': userId,
        'rating': rating,
        'review': review,
      });
      return true;
    } catch (e) {
      debugPrint("Error in addReview: $e");
      return false;
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

  Future<Product?> addProduct(Product p, File? primaryImage, [List<File>? additionalImages]) async {
    try {
      final productData = await supabase
          .from('products')
          .insert(p.toJson())
          .select()
          .single();

      final newProduct = Product.fromJson(productData);

      // 1. Handle Primary Image
      if (primaryImage != null) {
        final String publicUrl = await _uploadImage(newProduct.artisanId, primaryImage);

        await supabase.from('product_images').insert({
          'product_id': newProduct.id,
          'image_url': publicUrl,
          'is_primary': true,
        });

        newProduct.imageUrl = publicUrl;
      }

      // 2. Handle Additional Images
      if (additionalImages != null && additionalImages.isNotEmpty) {
        List<String> uploadedUrls = [];
        for (var file in additionalImages) {
          final String publicUrl = await _uploadImage(newProduct.artisanId, file);
          
          await supabase.from('product_images').insert({
            'product_id': newProduct.id,
            'image_url': publicUrl,
            'is_primary': false,
          });
          uploadedUrls.add(publicUrl);
        }
        newProduct.additionalImages = uploadedUrls;
      }

      return newProduct;
    } catch (e) {
      debugPrint("Error in addProduct: $e");
      rethrow;
    }
  }

  Future<String> _uploadImage(String artisanId, File image) async {
    final fileExt = image.path.split('.').last.toLowerCase();
    final fileName = '${DateTime.now().microsecondsSinceEpoch}.${fileExt}';
    final filePath = '$artisanId/$fileName';

    final bytes = await image.readAsBytes();

    await supabase.storage.from('product-images').uploadBinary(
          filePath,
          bytes,
          fileOptions: sb.FileOptions(
            cacheControl: '3600',
            upsert: false,
            contentType: _getContentType(fileExt),
          ),
        );

    return supabase.storage.from('product-images').getPublicUrl(filePath);
  }

  String _getContentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
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
