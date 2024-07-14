import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonDesign extends StatelessWidget {
  final IconData iconData;
  final Function()? onTap;
  const ButtonDesign({required this.onTap, required this.iconData, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Icon(
          iconData,
          size: Get.width / 18,
        ),
      ),
    );
  }
}
