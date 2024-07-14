import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycourse/Page/Archive/archive.dart';
import 'package:mycourse/constant/root.dart';
import '../../UI/bgdesign.dart';
import '../../UI/buttondesign.dart';
import '../../UI/customtextfield.dart';

class ArchiveDataController extends GetxController {
  ArchiveController controller = Get.put(ArchiveController());
  get data => controller.data;
  bool animation = false;
  TextEditingController featurecontroller = TextEditingController();
  TextEditingController featureEcontroller = TextEditingController();
  List feature = [];
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animation = true;
      update();
    });
    super.onInit();
  }

  delete(int index) {
    return showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: .5, end: 1).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: .5, end: 1).animate(a1),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Center(
                child: Text(
                  "Warning".tr,
                  style: TextStyle(
                      fontSize: Get.width / 22,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                GestureDetector(
                    onTap: () {
                      feature.removeAt(index);
                      update();
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: const Offset(0, 0),
                                color: Theme.of(context).shadowColor)
                          ]),
                      child: Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        size: Get.width / 16,
                        color: Theme.of(context).shadowColor,
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  features(String featureA, String featureE, int index) {
    featurecontroller.text = featureA;
    featureEcontroller.text = featureE;
    return showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: .5, end: 1).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: .5, end: 1).animate(a1),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomtextField(
                      hint: "${"5".tr} ${"Ar".tr}",
                      textEditingController: featurecontroller),
                  CustomtextField(
                      hint: "${"5".tr} ${"En".tr}",
                      textEditingController: featureEcontroller)
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                GestureDetector(
                    onTap: () {
                      if (featureE.isNotEmpty) {
                        feature[index]['subtitleA'] = featurecontroller.text;
                        feature[index]['subtitleE'] = featureEcontroller.text;
                        Get.back();
                        update();
                      } else {
                        feature.add({
                          'subtitleA': featurecontroller.text,
                          'subtitleE': featureEcontroller.text
                        });
                        update();
                      }
                      featurecontroller.clear();
                      featureEcontroller.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: const Offset(0, 0),
                                color: Theme.of(context).shadowColor)
                          ]),
                      child: Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        size: Get.width / 16,
                        color: Theme.of(context).shadowColor,
                      ),
                    )),
                GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: const Offset(0, 0),
                                color: Theme.of(context).shadowColor)
                          ]),
                      child: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: Get.width / 16,
                        color: Theme.of(context).shadowColor,
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  operation(bool edit, String id) {
    data.doc(id).update({
      "Dscrp": feature,
    });

    Get.back();
  }
}

class ArchiveData extends StatelessWidget {
  final String title;
  final String id;
  final List feature;
  const ArchiveData(
      {required this.title,
      this.feature = const [],
      required this.id,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArchiveDataController>(
        init: ArchiveDataController(),
        builder: (controller) {
          if (feature.isNotEmpty) {
            controller.feature = feature;
            controller.update();
          }
          return Scaffold(
            body: BgDesgin(
                page: SafeArea(
                    child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 400),
                transform: Matrix4.translationValues(
                    0, controller.animation ? 0 : Get.width, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonDesign(
                          onTap: () => Get.back(),
                          iconData: Icons.arrow_back_ios_new_rounded,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: Get.width / 18),
                        ),
                        Row(
                          children: [
                            ButtonDesign(
                              onTap: () => controller.features("", "", 0),
                              iconData: Icons.add,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            ButtonDesign(
                                onTap: () => controller.operation(true, id),
                                iconData: Icons.save)
                          ],
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Column(
                        children: List.generate(
                          controller.feature.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${Root.lang == "en" ? controller.feature[index]['subtitleE'] : controller.feature[index]['subtitleA']}",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width / 18),
                                  ),
                                ),
                                Row(
                                  children: [
                                    ButtonDesign(
                                        onTap: () => controller.features(
                                            controller.feature[index]
                                                ['subtitleA'],
                                            controller.feature[index]
                                                ['subtitleE'],
                                            index),
                                        iconData: Icons.edit),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    ButtonDesign(
                                        onTap: () => controller.delete(index),
                                        iconData: CupertinoIcons.trash_fill)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))),
          );
        });
  }
}
