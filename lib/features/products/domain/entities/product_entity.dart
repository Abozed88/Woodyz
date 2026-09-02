enum ProductStatus {
  unavailable,
  inStock,
  onDemand,
  inProduction;

  String toDbString() {
    switch (this) {
      case ProductStatus.unavailable: return 'Unavailable';
      case ProductStatus.inStock: return 'In Stock';
      case ProductStatus.onDemand: return 'On Demand';
      case ProductStatus.inProduction: return 'In Production';
    }
  }

  static ProductStatus fromDbString(String status) {
    switch (status) {
      case 'Unavailable': return ProductStatus.unavailable;
      case 'In Stock': return ProductStatus.inStock;
      case 'On Demand': return ProductStatus.onDemand;
      case 'In Production': return ProductStatus.inProduction;
      default: return ProductStatus.inStock;
    }
  }

  String get displayName {
    switch (this) {
      case ProductStatus.unavailable: return 'Unavailable';
      case ProductStatus.inStock: return 'In Stock';
      case ProductStatus.onDemand: return 'On Demand';
      case ProductStatus.inProduction: return 'In Production';
    }
  }
}

class Product {
  int? id;
  String artisanId;
  String title;
  String description;
  double price;
  int stock;
  String category;
  String? material;
  bool isAvailable;
  ProductStatus status;
  String? imageUrl; // Primary image URL
  List<String> additionalImages;
  double averageRating;
  int ratingCount;
  String? createdAt;
  String? updatedAt;

  Product({
    this.id,
    required this.artisanId,
    required this.title,
    required this.description,
    required this.price,
    this.stock = 1,
    required this.category,
    this.material,
    this.isAvailable = true,
    this.status = ProductStatus.inStock,
    this.imageUrl,
    this.additionalImages = const [],
    this.averageRating = 0.0,
    this.ratingCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  Product.init()
      : artisanId = '',
        title = '',
        description = '',
        price = 0.0,
        stock = 1,
        category = '',
        isAvailable = true,
        status = ProductStatus.inStock,
        averageRating = 0.0,
        ratingCount = 0,
        additionalImages = [];

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handling joins from product_images if available
    String? primaryImg;
    List<String> others = [];
    
    if (json['product_images'] != null && (json['product_images'] as List).isNotEmpty) {
      final List images = json['product_images'] as List;
      
      // Look for primary image
      final primaryItem = images.firstWhere(
        (img) => img['is_primary'] == true,
        orElse: () => images[0],
      );
      primaryImg = primaryItem['image_url'];
      
      // Collect additional images
      others = images
          .where((img) => img['image_url'] != primaryImg)
          .map((img) => img['image_url'] as String)
          .toList();
    }

    return Product(
      id: json['id'],
      artisanId: json['artisan_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 1,
      category: json['category'] ?? '',
      material: json['material'],
      isAvailable: json['is_available'] ?? true,
      status: ProductStatus.fromDbString(json['availability'] ?? 'In Stock'),
      imageUrl: json['image_url'] ?? primaryImg,
      additionalImages: others,
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'artisan_id': artisanId,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'material': material,
      'is_available': isAvailable,
      'availability': status.toDbString(),
    };
  }
}
