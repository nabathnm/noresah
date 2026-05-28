import 'package:flutter/material.dart';
import 'package:noresah/core/utils/constant/app_colors.dart';


  class QuickActionChip extends StatelessWidget {
    final String label;
    final IconData icon;
    final VoidCallback? onTap;
    final bool isEmergency;

    const QuickActionChip({
      super.key,
      required this.label,
      required this.icon,
      this.onTap,
      this.isEmergency = false,
    });

    @override
    Widget build(BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(right: 10),
        child: ActionChip(
          backgroundColor: isEmergency
              ? AppColors.redLight
              : AppColors.primaryLight,
          side: BorderSide(
            color: isEmergency
                ? AppColors.redNormal
                : AppColors.primaryLightHover,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          avatar: Icon(
            icon,
            size: 16,
            color: isEmergency
                ? AppColors.redNormal
                : AppColors.primary,
          ),
          label: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isEmergency
                  ? AppColors.redNormal
                  : AppColors.primary,
            ),
          ),
          onPressed: onTap ?? () {},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }
