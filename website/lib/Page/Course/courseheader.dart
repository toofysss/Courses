import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycourse/Page/Course/course.dart';
import 'package:mycourse/UI/bgdesign.dart';
import 'package:mycourse/UI/buttondesign.dart';
import 'package:mycourse/UI/customtextfield.dart';

class CourseHeaderOperationController extends GetxController {
  CourseController controller = Get.put(CourseController());
  get data => controller.data;

  TextEditingController categorycontroller = TextEditingController();
  bool animation = false;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animation = true;
      update();
    });
    super.onInit();
  }

  operation(bool edit, String id) {
    if (edit) {
      data.doc(id).update({
        "category": categorycontroller.text,
      });
    } else {
      data.add({
        "category": categorycontroller.text,
      });
    }
    Get.back();
  }
}

class CourseHeaderOperation extends StatelessWidget {
  final bool edit;
  final String? id;
  final String category;
  const CourseHeaderOperation(
      {this.id, this.edit = false, this.category = '', super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseHeaderOperationController>(
        init: CourseHeaderOperationController(),
        builder: (controller) {
          controller.categorycontroller.text = category;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: BgDesgin(
                page: SafeArea(
                    child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 400),
                transform: Matrix4.translationValues(
                    0, controller.animation ? 0 : Get.width, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonDesign(
                            onTap: () => Get.back(),
                            iconData: Icons.arrow_back_ios_new_rounded,
                          ),
                          ButtonDesign(
                            onTap: () => controller.operation(edit, "$id"),
                            iconData: Icons.save_rounded,
                          ),
                        ],
                      ),
                    ),
                    CustomtextField(
                        hint: "7".tr,
                        textEditingController: controller.categorycontroller),
                  ],
                ),
              ),
            ))),
          );
        });
  }
}
