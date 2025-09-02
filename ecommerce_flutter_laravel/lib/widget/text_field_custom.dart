import 'package:flutter/material.dart';

/// Widget custom untuk TextFormField dengan fitur:
/// - Floating label
/// - HintText (contoh penulisan)
/// - Password visibility toggle
/// - Validasi (wajib diisi / custom)
Widget textFieldCustom(
  String label,
  TextEditingController controller, {
  String? hintText,
  bool isPassword = false,
  bool obscureText = false,
  VoidCallback? toggleVisibility,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText, // contoh penulisan
        labelStyle: const TextStyle(color: Colors.deepOrange),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepOrange),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.deepOrange,
                  ),
                  onPressed: toggleVisibility,
                )
                : null,
      ),
    ),
  );
}
