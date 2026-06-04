import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final IconData prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return DropdownButtonFormField<T>(
      initialValue: value,
      dropdownColor: theme.colorScheme.surface,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? theme.colorScheme.surface : const Color(0xFFF1F5F9),
        hintText: hintText,
        hintStyle: TextStyle(color: iconColor),
        prefixIcon: Icon(prefixIcon, color: iconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
      ),
      iconEnabledColor: iconColor,
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
