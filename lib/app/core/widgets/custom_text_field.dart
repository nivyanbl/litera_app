import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure, 
      keyboardType: widget.keyboardType,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.grayDarker,
      ),
      cursorColor: AppColors.primaryNormal,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(widget.icon),

        errorText: widget.errorText,
        
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                icon: Icon(
                  _isObscure 
                      ? Icons.visibility_off_outlined       
                      : Icons.visibility_outlined,  
                  color: AppColors.grayNormal,
                ),
              )
            : null, 
      ),
    );
  }
}