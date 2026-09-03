import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:woodyz/features/auth/presentation/widgets/upload_widgets.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';

class Upload extends StatefulWidget {
  final Artisan artisan;
  const Upload({super.key, required this.artisan});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _desccontroller = TextEditingController();

  File? _image;
  final List<File> _additionalImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickAdditionalImages() async {
    if (_additionalImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can add up to 5 additional images")),
      );
      return;
    }

    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    
    if (pickedFiles.isNotEmpty) {
      setState(() {
        int spaceLeft = 5 - _additionalImages.length;
        _additionalImages.addAll(
          pickedFiles.take(spaceLeft).map((file) => File(file.path))
        );
      });
    }
  }

  void reset(){
    setState(() {
      _namecontroller.clear();
      _desccontroller.clear();
      _image = null;
      _additionalImages.clear();
    });
  }

  Product p = Product.init();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add your creation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  fontFamily: "Saira",
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your product, your spotlight",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14, 
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontFamily: "Saira",
                ),
              ),
              const SizedBox(height: 40),

              // Image Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: theme.colorScheme.surface,
                      border: Border.all(
                        color: _image != null ? primaryColor : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, color: primaryColor, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                "Add Product Image",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  fontSize: 12,
                                  fontFamily: "Saira",
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Additional Images Section
              const Text(
                "Additional Images (Max 5)",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Saira",
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _additionalImages.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    if (index == _additionalImages.length) {
                      if (_additionalImages.length >= 5) return const SizedBox.shrink();
                      return GestureDetector(
                        onTap: _pickAdditionalImages,
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: theme.colorScheme.surface,
                            border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1), width: 1.5),
                          ),
                          child: Icon(Icons.add_a_photo_outlined, color: primaryColor, size: 28),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _additionalImages[index],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => setState(() => _additionalImages.removeAt(index)),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),

              CustomTextField(
                label: "Product Name",
                hint: "What are you crafting?",
                controller: _namecontroller,
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: "Description",
                hint: "describe your masterpiece...",
                controller: _desccontroller,
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              ChooseCategory(p: p),
              const SizedBox(height: 24),

              ChooseStatus(p: p),
              const SizedBox(height: 24),

              const Text(
                "Stock Quantity",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Saira",
                ),
              ),
              const SizedBox(height: 8),
              Center(child: StockIndicator(p: p)),
              const SizedBox(height: 24),

              AvailabilityToggle(p: p),
              const SizedBox(height: 24),

              const Text(
                "Set Price",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Saira",
                ),
              ),
              const SizedBox(height: 8),
              Center(child: NumberIndicator(p: p)),
              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: _isUploading ? null : _handleUpload,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: _isUploading
                    ? Lottie.asset('assets/animations/progressloading.json', height: 40)
                    : const Text(
                        "UPLOAD PRODUCT",
                        style: TextStyle(letterSpacing: 1.5),
                      ),
              ),
              const SizedBox(height: 40), 
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleUpload() async {
    if (_key.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a product image")),
        );
        return;
      }

      setState(() => _isUploading = true);
      try {
        p.title = _namecontroller.text.trim();
        p.description = _desccontroller.text.trim();
        p.artisanId = widget.artisan.id;
        
        final newProduct = await ProductsProvider().addProduct(p, _image, _additionalImages);
        if(newProduct != null && mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Row(
              children: [
                Text("Product uploaded successfully!"),
                Lottie.asset('assets/animations/Check Mark - Success.json')
              ],
            )),
          );
          reset();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload failed: $e")),
          );
        }
      } finally {
        if (mounted) setState(() => _isUploading = false);
      }
    }
  }
}
