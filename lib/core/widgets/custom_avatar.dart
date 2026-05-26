import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool isOnline;
  final bool isTrainer;

  const CustomAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 24,
    this.isOnline = true,
    this.isTrainer = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.surfaceDark
        : AppColors.lightGrey;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isTrainer ? AppColors.primaryBlue : Colors.transparent,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            child: ClipOval(
              child: Image.network(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person_outline, 
                  color: AppColors.textSecondaryLight, 
                  size: radius,
                ),
              ),
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: radius * 0.45,
              height: radius * 0.45,
              decoration: BoxDecoration(
                color: AppColors.accentGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
        if (isTrainer)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                color: AppColors.white,
                size: 10,
              ),
            ),
          ),
      ],
    );
  }
}