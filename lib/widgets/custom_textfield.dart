import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.fieldName,
    required this.controller,
    this.labelText = '',
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.obscureText,
    this.onTogglePassword,
  }) : super(key: key);

  final String fieldName;
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  final bool? obscureText; // comes from controller
  final VoidCallback? onTogglePassword; // toggle logic

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldName, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          obscureText: obscureText ?? false,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (obscureText ?? true)
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
