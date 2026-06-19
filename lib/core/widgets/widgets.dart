import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  bool obscure;
  CustomTextField({super.key, required this.hint, required this.controller, this.obscure=false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: TextStyle(
          color: Colors.white,
          fontSize: 16
      ),
      obscureText: widget.obscure,
      cursorColor: Color.fromRGBO(252, 184, 25, 1),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.fromRGBO(252, 184, 25, 1),
                width: 1.4,
              )
          ),
          prefixIcon: widget.hint == "name" ? Icon(Icons.person, color: Color.fromRGBO(252, 184, 25, 1),)
          : widget.hint == "you@gmail.com" ? Icon(Icons.email, color: Color.fromRGBO(252, 184, 25, 1),)
          : widget.hint=="password" ? Icon(Icons.lock, color: Color.fromRGBO(252, 184, 25, 1),)
          : widget.hint=="phone" ? Icon(Icons.phone_android, color: Color.fromRGBO(252, 184, 25, 1),)
          : widget.hint=="address" ? Icon(Icons.location_on, color: Color.fromRGBO(252, 184, 25, 1),)
          : widget.hint=="shop" ? Icon(Icons.store, color: Color.fromRGBO(252, 184, 25, 1),)
          : widget.hint=="link" ?Icon(Icons.link, color: Color.fromRGBO(252, 184, 25, 1),): null,

          suffixIcon: widget.hint != "password" ? null : IconButton(
            icon: Icon(
              widget.obscure ? Icons.visibility_off : Icons
                  .visibility,
              color: Color.fromRGBO(252, 184, 25, 1),
            ),
            onPressed: () {
              setState(() {
                widget.obscure = !widget.obscure; // toggle state
              });
            },
          ),
          filled: true,
          fillColor: Color.fromRGBO(33, 33, 32, 1),
          hintText: widget.hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.fromRGBO(56, 56, 52, 1),
                width: 1.4,
              )
          )
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }

        // Password length check
        if (widget.hint == "password") {
          if (value.length < 6) return "Password too short (min 6)";
          if (value.length > 32) return "Password too long (max 32)";
        }

        // Email format check (Logic fixed: added '!')
        if (widget.hint == "you@gmail.com") {
          if (!value.contains("@") || !value.contains(".")) {
            return "Enter a valid email (name@domain.com)";
          }
        }

        if(widget.hint == "phone"){
          for (int i = 0; i < value.length; i++) {
            String ch = value[i];
            if (RegExp(r'\d').hasMatch(ch)) {
              return null;
            } else {
              return "Enter a valid phone number";
            }
          }
        }
        return null;
      },
    );
  }
}
