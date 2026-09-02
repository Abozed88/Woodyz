import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/widgets/details_widgets.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/artisan/edit_product.dart';

class Details extends StatefulWidget {
  final Product p;
  final Artisan a;
  final Customer? u;
  final bool asArtisan;
  final bool already_saved;

  const Details({super.key, required this.p, required this.a,required this.u, required this.already_saved, this.asArtisan = false});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late bool _saved;
  String? _displayImageUrl;
  
  List<Review> _reviews = [];
  bool _isLoadingReviews = true;
  double _userRating = 5.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _saved = widget.already_saved;
    _displayImageUrl = widget.p.imageUrl;
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final reviews = await ProductsProvider().fetchReviews(widget.p.id!);
    if (mounted) {
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    }
  }

  Future<void> _submitReview() async {
    if (widget.u == null) return;
    
    final success = await ProductsProvider().addReview(
      widget.p.id!,
      widget.u!.id,
      _userRating,
      _reviewController.text.trim(),
    );

    if (success && mounted) {
      _reviewController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted! Thank you.")),
      );
      _loadReviews();
      // Optionally refresh product to get new average rating
      final updatedProduct = await ProductsProvider().fetchProductById(widget.p.id!);
      if (updatedProduct != null && mounted) {
        setState(() {
          widget.p.averageRating = updatedProduct.averageRating;
          widget.p.ratingCount = updatedProduct.ratingCount;
        });
      }
    }
  }

  Future<void> _deleteProduct() async {
    final success = await ProductsProvider().deleteProduct(widget.p.id!);
    if (success && mounted) {
      Navigator.pop(context, true); // Return true to indicate deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product deleted successfully")),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete product")),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this creation? This action cannot be undone.", style: TextStyle(fontFamily: "Saira")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.grey, fontFamily: "Saira")),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct();
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red, fontFamily: "Saira", fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String username) async {
    final Uri url = Uri.parse("https://instagram.com/$username");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $url";
    }
  }

  Color _getStatusColor(ProductStatus status) {
    switch (status) {
      case ProductStatus.inStock: return Colors.green;
      case ProductStatus.onDemand: return Colors.blue;
      case ProductStatus.inProduction: return Colors.orange;
      case ProductStatus.unavailable: return Colors.red;
    }
  }

  Widget _buildReviewItem(BuildContext context, Review review) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: review.user?.avatarUrl != null && review.user!.avatarUrl!.isNotEmpty
              ? NetworkImage(review.user!.avatarUrl!)
              : const AssetImage("assets/images/profile.webp") as ImageProvider,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    review.user?.fullName ?? "User",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Saira",
                    ),
                  ),
                  Text(
                    review.createdAt?.substring(0, 10) ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: primaryColor,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                review.review,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontFamily: "Saira",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        actions: [
          if (widget.asArtisan) ...[
            IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProduct(p: widget.p)),
                );
                if (result == true) {
                  setState(() {}); // Refresh UI
                }
              },
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () => _showDeleteConfirmation(context),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ]
          else if (widget.u != null)
            IconButton(
              onPressed: () async {
                ProductsProvider productControl = ProductsProvider();

                if (!_saved) {
                  bool success = await productControl.saveProduct(widget.p.id!, widget.u!.id);

                  if (!mounted) return;
                  if (success) {
                    setState(() {
                      _saved = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite, color: primaryColor),
                            const SizedBox(width: 8),
                            Text("Added to favorites!", style: TextStyle(color: primaryColor)),
                          ],
                        ),
                        backgroundColor: theme.colorScheme.surface,
                        showCloseIcon: true,
                        closeIconColor: primaryColor,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                } else {
                  bool success = await productControl.unsaveProduct(widget.p.id!, widget.u!.id);

                  if (!mounted) return;

                  if (success) {
                    setState(() {
                      _saved = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border_outlined, color: primaryColor),
                            const SizedBox(width: 8),
                            Text("Removed from favorites!", style: TextStyle(color: primaryColor)),
                          ],
                        ),
                        backgroundColor: theme.colorScheme.surface,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                }
              },
              icon: !_saved
                  ? const Icon(Icons.favorite_border_outlined)
                  : const Icon(Icons.favorite, color: Colors.red),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image with AspectRatio to prevent deformity
                      GestureDetector(
                        onTap: () {
                          if (_displayImageUrl != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImage(imageUrl: _displayImageUrl!),
                              ),
                            );
                          }
                        },
                        child: Hero(
                          tag: _displayImageUrl ?? 'product_image',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              color: theme.colorScheme.surface,
                              child: AspectRatio(
                                aspectRatio: 4 / 3, // Natural landscape ratio for products
                                child: _displayImageUrl != null
                                  ? Image.network(
                                      _displayImageUrl!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                : null,
                                            color: primaryColor,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: theme.colorScheme.surface,
                                        child: Icon(Icons.broken_image_outlined, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                                      ),
                                    )
                                  : Container(
                                      color: theme.colorScheme.surface,
                                      child: Icon(Icons.image_outlined, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Additional Images Row
                      if (widget.p.additionalImages.isNotEmpty)
                        SizedBox(
                          height: 70,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.p.additionalImages.length + 1,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final String imgUrl = index == 0 
                                  ? (widget.p.imageUrl ?? '') 
                                  : widget.p.additionalImages[index - 1];
                              
                              if (imgUrl.isEmpty) return const SizedBox.shrink();

                              final bool isSelected = _displayImageUrl == imgUrl;

                              return GestureDetector(
                                onTap: () => setState(() => _displayImageUrl = imgUrl),
                                child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? primaryColor : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: theme.colorScheme.surface,
                                        child: const Icon(Icons.broken_image, size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Category & Availability Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              widget.p.category.toUpperCase(),
                              style: TextStyle(
                                color: primaryColor,
                                fontFamily: "Saira",
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: (widget.p.isAvailable && widget.p.stock > 0) 
                                  ? Colors.green.withValues(alpha: 0.1) 
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: (widget.p.isAvailable && widget.p.stock > 0) 
                                    ? Colors.green.withValues(alpha: 0.3) 
                                    : Colors.red.withValues(alpha: 0.3)
                              ),
                            ),
                            child: Text(
                              (widget.p.isAvailable && widget.p.stock > 0) ? "AVAILABLE" : "SOLD OUT",
                              style: TextStyle(
                                color: (widget.p.isAvailable && widget.p.stock > 0) ? Colors.green : Colors.red,
                                fontFamily: "Saira",
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title and Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.p.title,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Saira",
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star_rounded, color: primaryColor, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  widget.p.averageRating.toStringAsFixed(1), 
                                  style: const TextStyle(fontWeight: FontWeight.bold)
                                ),
                                if (widget.p.ratingCount > 0) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    "(${widget.p.ratingCount})",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Price
                      Text(
                        "\$${widget.p.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Divider(thickness: 1),
                      const SizedBox(height: 24),

                      // Specifications Grid
                      const Text(
                        "Specifications",
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 16),
                      Widget1(p: widget.p),
                      const SizedBox(height: 32),

                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.p.description,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 16,
                          height: 1.5,
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Artisan Card
                      const Text(
                        "About the Artisan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 16),
                      Widget2(artisan: widget.a),
                      const SizedBox(height: 40),

                      // Reviews Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Reviews",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Saira",
                            ),
                          ),
                          if (widget.p.ratingCount > 0)
                            Text(
                              "${widget.p.ratingCount} comments",
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                fontSize: 14,
                                fontFamily: "Saira",
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      if (_isLoadingReviews)
                        const Center(child: CircularProgressIndicator())
                      else if (_reviews.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              widget.asArtisan? "No reviews yet!":
                              "No reviews yet. Be the first to rate!",
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                fontFamily: "Saira",
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _reviews.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final review = _reviews[index];
                            return _buildReviewItem(context, review);
                          },
                        ),
                      
                      const SizedBox(height: 32),

                      // Add Review Form (only for customers)
                      if (widget.u != null && !widget.asArtisan) ...[
                        const Text(
                          "Write a Review",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Saira",
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    onPressed: () => setState(() => _userRating = index + 1.0),
                                    icon: Icon(
                                      index < _userRating ? Icons.star_rounded : Icons.star_outline_rounded,
                                      color: primaryColor,
                                      size: 32,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  );
                                }),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _reviewController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: "Share your thoughts about this product...",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                  ),
                                  filled: true,
                                  fillColor: theme.scaffoldBackgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              widget.asArtisan? SizedBox(height: 20,) :
                              ElevatedButton(
                                onPressed: _submitReview,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text("SUBMIT REVIEW"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],

                      // Timestamps
                      if (widget.p.updatedAt != null) ...[
                        Center(
                          child: Text(
                            "Last updated: ${widget.p.updatedAt!.substring(0, 10)}",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                              fontSize: 12,
                              fontFamily: "Saira",
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Order Button
                      if (!widget.asArtisan) ...[
                        ElevatedButton(
                          onPressed: () => _launchURL(widget.a.instagram!),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 60),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const ImageIcon(
                                AssetImage('assets/icons/icons8-instagram-50.png'),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "REQUEST TO ORDER",
                                style: TextStyle(letterSpacing: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ]
                )
            ),
          ],
        ),
      )
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Hero(
                tag: imageUrl,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  },
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
