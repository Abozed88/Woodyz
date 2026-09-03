import 'package:flutter/material.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';
import 'package:woodyz/features/auth/presentation/widgets/upload_widgets.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:lottie/lottie.dart';

class EditProduct extends StatefulWidget {
  final Product p;
  const EditProduct({super.key, required this.p});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _key = GlobalKey();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.p.title);
    _descController = TextEditingController(text: widget.p.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_key.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        widget.p.title = _nameController.text.trim();
        widget.p.description = _descController.text.trim();

        final success = await ProductsProvider().updateProduct(widget.p);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product updated successfully!")),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Update failed: $e")),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Creation", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: "Product Name",
                controller: _nameController, hint: '',
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "Description",
                controller: _descController,
                maxLines: 4, hint: '',
              ),
              const SizedBox(height: 24),
              ChooseCategory(p: widget.p),
              const SizedBox(height: 24),
              ChooseStatus(p: widget.p),
              const SizedBox(height: 24),
              const Text(
                "Stock Quantity",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: "Saira"),
              ),
              const SizedBox(height: 8),
              Center(child: StockIndicator(p: widget.p)),
              const SizedBox(height: 24),
              AvailabilityToggle(p: widget.p),
              const SizedBox(height: 24),
              const Text(
                "Price (\$)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: "Saira"),
              ),
              const SizedBox(height: 8),
              Center(child: NumberIndicator(p: widget.p)),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: _isSaving
                    ? Lottie.asset('assets/animations/progressloading.json', height: 40)
                    : const Text("SAVE CHANGES", style: TextStyle(letterSpacing: 1.5)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
