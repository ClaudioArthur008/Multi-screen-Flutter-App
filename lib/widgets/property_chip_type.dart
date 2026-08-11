import 'package:flutter/material.dart';
import 'package:flutter_app/models/property/property_model.dart';
import 'package:flutter_app/theme/app_theme.dart';

class PropertyTypeChip extends StatelessWidget {
  final PropertyType value;
  final bool selected;
  final ValueChanged<PropertyType>? onSelected;

  const PropertyTypeChip({
    super.key,
    required this.value,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.primaryDark;

    return ChoiceChip(
      avatar: Icon(
        value.icon,
        size: 16,
        color: selected ? Colors.white : unselectedText.withValues(alpha: .7),
      ),
      label: Text(value.label),
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: selected ? Colors.white : unselectedText,
      ),
      selected: selected,
      onSelected: onSelected == null ? null : (_) => onSelected!(value),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? Colors.white10 : AppColors.lightSurface,
      shape: const StadiumBorder(),
      side: BorderSide(color: Colors.transparent, width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
      elevation: 0,
      pressElevation: 0,
    );
  }
}
