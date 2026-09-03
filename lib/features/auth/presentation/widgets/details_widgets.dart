import 'package:flutter/material.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/artisan_view.dart';

class Widget1 extends StatelessWidget {
  final Product p;
  const Widget1({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoBox(
              context,
              label: "Stock Quantity",
              value: p.stock.toString(),
              icon: Icons.inventory_2_outlined,
            ),
            _buildInfoBox(
              context,
              label: "Material",
              value: p.material ?? "Wood",
              icon: Icons.category_outlined,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoBox(
              context,
              label: "Availability",
              value: p.status.displayName,
              icon: _getStatusIcon(p.status),
              valueColor: _getStatusColor(p.status),
            ),
            _buildInfoBox(
              context,
              label: "Listed On",
              value: p.createdAt?.substring(0, 10) ?? "N/A",
              icon: Icons.calendar_today_outlined,
            ),
          ],
        ),
      ],
    );
  }

  IconData _getStatusIcon(ProductStatus status) {
    switch (status) {
      case ProductStatus.inStock: return Icons.check_circle_outline;
      case ProductStatus.onDemand: return Icons.access_time_outlined;
      case ProductStatus.inProduction: return Icons.build_outlined;
      case ProductStatus.unavailable: return Icons.highlight_off_outlined;
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

  Widget _buildInfoBox(BuildContext context, {
    required String label, 
    required String value, 
    required IconData icon,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 11,
              fontFamily: "Saira",
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "Saira",
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class Widget2 extends StatelessWidget {
  final Artisan artisan;

  const Widget2({super.key, required this.artisan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: 0,
      color: theme.brightness == Brightness.dark 
          ? const Color(0xFF2C2C2B) 
          : const Color(0xFFFBFBFB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: () async {
          List<Product> newItems = await ProductsProvider().fetchData(0, 100, "all", null, artisan.id);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtisanView(artisan: artisan, items: newItems,),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 2),
                ),
                padding: const EdgeInsets.all(3),
                child: ClipOval(
                  child: artisan.avatarUrl != null && artisan.avatarUrl!.isNotEmpty
                      ? Image.network(artisan.avatarUrl!, fit: BoxFit.cover)
                      : Image.asset("assets/images/profile.webp", fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "@${artisan.username}",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Saira",
                      ),
                    ),
                    Text(
                      artisan.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Saira",
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Text(
                          artisan.location,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 13,
                            fontFamily: "Saira",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}

class BouncingIconButton extends StatefulWidget {
  final IconData icon;
  final Color? color;
  final double size;
  final VoidCallback onPressed;

  const BouncingIconButton({
    super.key,
    required this.icon,
    this.color,
    this.size = 24.0,
    required this.onPressed,
  });

  @override
  State<BouncingIconButton> createState() => _BouncingIconButtonState();
}

class _BouncingIconButtonState extends State<BouncingIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0.0);
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          widget.icon,
          color: widget.color,
          size: widget.size,
        ),
      ),
    );
  }
}
