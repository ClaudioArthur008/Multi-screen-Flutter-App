import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_theme.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  const CustomSearchBar({
    super.key,
    this.onChanged,
    this.onFilterTap,
    this.hintText = 'Essayez un quartier...',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final secondaryTextColor = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;
    final borderColor = isDark ? Colors.white12 : Colors.black12;
    final iconColor = isDark ? AppColors.darkText : AppColors.primaryDark;

    return Row(
      children: [
        // Champ de saisie texte
        Expanded(
          child: TextField(
            onChanged: onChanged,
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: secondaryTextColor),
              filled: true,
              fillColor: surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: isDark
                    ? BorderSide(color: borderColor, width: 0.5)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),

              prefixIcon: Icon(Icons.search, color: secondaryTextColor),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),

        // Bouton de filtres
        if (onFilterTap != null) ...[
          const SizedBox(width: 12),
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: borderColor, width: 0.5),
            ),
            child: IconButton(
              icon: Icon(Icons.tune_rounded, color: iconColor),
              onPressed: onFilterTap,
            ),
          ),
        ],
      ],
    );
  }
}
