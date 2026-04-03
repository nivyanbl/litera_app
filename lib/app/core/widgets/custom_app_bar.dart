import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeftIcon;
  final bool showRightIcon;
  final IconData leftIcon;
  final IconData rightIcon;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onRightIconPressed;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showLeftIcon = true,
    this.showRightIcon = true,
    this.leftIcon = Icons.arrow_back,
    this.rightIcon = Icons.favorite_border,
    this.onLeftIconPressed,
    this.onRightIconPressed,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      shadowColor: Colors.black26,
      leading: showLeftIcon
          ? IconButton(
              icon: Icon(leftIcon, color: Colors.black),
              onPressed: onLeftIconPressed ?? onBackPressed ?? Get.back,
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.grayDarker,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: showRightIcon
          ? [
              IconButton(
                icon: Icon(rightIcon, color: Colors.black),
                onPressed: onRightIconPressed ?? () {},
              ),
            ]
          : null,
    );
  }
}
