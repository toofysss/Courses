import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycourse/Page/Archive/archive.dart';
import '../../UI/bgdesign.dart';
import '../../UI/buttondesign.dart';
import '../../UI/customtextfield.dart';

class ArchiveHeaderOperationController extends GetxController {
  ArchiveController controller = Get.put(ArchiveController());
  get data => controller.data;

  TextEditingController yearcontroller = TextEditingController();
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
      data.doc(id).update({"year": yearcontroller.text, "Dscrp": []});
    } else {
      data.add({"year": yearcontroller.text, "Dscrp": []});
    }
    Get.back();
  }
}

class ArchiveHeaderOperation extends StatelessWidget {
  final bool edit;
  final String? id;
  final String year;

  const ArchiveHeaderOperation(
      {this.id, this.edit = false, this.year = '', super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArchiveHeaderOperationController>(
        init: ArchiveHeaderOperationController(),
        builder: (controller) {
          controller.yearcontroller.text = year;
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
                        hint: "14".tr,
                        textEditingController: controller.yearcontroller),
                  ],
                ),
              ),
            ))),
          );
        });
  }
}
