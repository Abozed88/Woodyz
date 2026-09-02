import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final String? label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboardType;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.hint,
    this.label,
    required this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
              fontFamily: "Saira",
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontFamily: "Saira",
          ),
          cursorColor: theme.colorScheme.primary,
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hint,
            prefixIcon: _getPrefixIcon(context),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: theme.colorScheme.primary.withOpacity(0.7),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "This field is required";
            }

            if (widget.hint == "password") {
              if (value.length < 6) return "Password too short (min 6)";
              if (value.length > 32) return "Password too long (max 32)";
            }

            if (widget.hint == "you@gmail.com") {
              final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return "Enter a valid email address";
              }
            }

            if (widget.hint == "phone") {
              if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(value.trim())) {
                return "Enter a valid phone number";
              }
            }

            if (widget.label == "Instagram Username") {
              if(value.length > 30 || value.contains('!') || value.contains('@') || value.contains('#') || value.contains('&')){
                return "Enter a valid Instagram username";
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget? _getPrefixIcon(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.primary;
    const iconSize = 20.0;

    if (widget.hint == "name") return Icon(Icons.person_outline, color: iconColor, size: iconSize);
    if (widget.hint == "you@gmail.com") return Icon(Icons.email_outlined, color: iconColor, size: iconSize);
    if (widget.hint == "password") return Icon(Icons.lock_outline, color: iconColor, size: iconSize);
    if (widget.hint == "phone") return Icon(Icons.phone_android_outlined, color: iconColor, size: iconSize);
    if (widget.hint == "address") return Icon(Icons.location_on_outlined, color: iconColor, size: iconSize);
    if (widget.hint == "shop") return Icon(Icons.store_outlined, color: iconColor, size: iconSize);
    if (widget.label == "Instagram Username") return Icon(Icons.link_outlined, color: iconColor, size: iconSize);
    if (widget.hint.contains("describe")) return Icon(Icons.description_outlined, color: iconColor, size: iconSize);
    
    return null;
  }
}
