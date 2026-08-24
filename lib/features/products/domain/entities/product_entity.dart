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
  String? imageUrl; // Primary image URL
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
    this.imageUrl,
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
        isAvailable = true;

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handling joins from product_images if available
    String? primaryImg;
    if (json['product_images'] != null && (json['product_images'] as List).isNotEmpty) {
      primaryImg = json['product_images'][0]['image_url'];
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
      imageUrl: json['image_url'] ?? primaryImg,
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
    };
  }
}
