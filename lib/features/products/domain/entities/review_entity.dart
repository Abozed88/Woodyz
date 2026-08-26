import 'package:woodyz/features/auth/domain/entities/auth_entities.dart';

class Review {
  final int? id;
  final int productId;
  final String userId;
  final double rating;
  final String review;
  final String? createdAt;
  final String? updatedAt;
  final User? user; // Join with profiles

  Review({
    this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    required this.review,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      review: json['review'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['profiles'] != null ? User.fromJson(json['profiles']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'product_id': productId,
      'user_id': userId,
      'rating': rating,
      'review': review,
    };
  }
}
