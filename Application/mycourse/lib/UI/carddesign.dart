import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycourse/Page/Archive/archive.dart';
import 'package:mycourse/Page/Course/course.dart';
import 'package:mycourse/Page/Gallery/gallery.dart';
import 'package:mycourse/Page/News/news.dart';
import 'package:mycourse/Page/Price/price.dart';
import 'package:mycourse/Page/Service/service.dart';

class CardDesign extends StatelessWidget {
  final int index;
  const CardDesign({required this.index, super.key});

  Widget page(int page) {
    switch (page) {
      case 0:
        return const Price();
      case 1:
        return const Service();
      case 2:
        return const Course();
      case 3:
        return const GalleryPage();
      case 4:
        return const News();
      case 5:
        return const Archive();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => page(index), transition: Transition.zoom),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Text(
          "$index".tr,
          style: TextStyle(
              fontSize: Get.width / 22,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
