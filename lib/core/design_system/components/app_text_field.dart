import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Premium Text Field - Inspired by Slice/HDFC Bank
/// Features: Subtle shadows, clean borders, smooth animations
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final String? label;
  final bool obscureText;
  final TextInputType keyboardType;
  final Iterable<String>? autofillHints;
  final Widget? suffix;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final Color? focusColor;

  const AppTextField({
    super.key,
    this.controller,
    required this.hint,
    this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.suffix,
    this.onSubmitted,
    this.validator,
    this.focusColor,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.focusColor ?? Theme.of(context).colorScheme.primary;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          autofillHints: widget.autofillHints,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.authInputText,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.authPlaceholder,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: widget.suffix != null
                ? Padding(padding: const EdgeInsets.only(right: 16), child: widget.suffix)
                : null,
            suffixIconConstraints: const BoxConstraints(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.authInputBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.authInputBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.danger, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.danger, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
