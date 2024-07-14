import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycourse/UI/bgdesign.dart';
import 'package:mycourse/UI/buttondesign.dart';
import 'package:mycourse/UI/customtextfield.dart';
import 'package:mycourse/UI/design.dart';
import 'package:mycourse/UI/loadingdesign.dart';
import 'package:mycourse/constant/root.dart';

class PriceController extends GetxController {
  final data = FirebaseFirestore.instance.collection("price");

  bool animation = false;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animation = true;
      update();
    });
    super.onInit();
  }

  delete(String id) {
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
                      data.doc(id).delete();
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
}

class PriceOperationController extends GetxController {
  PriceController controller = Get.put(PriceController());
  get data => controller.data;

  TextEditingController titleAcontroller = TextEditingController();
  TextEditingController titleEcontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController featurecontroller = TextEditingController();
  List feature = [];
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
        "titleE": titleEcontroller.text,
        "titleA": titleAcontroller.text,
        "Price": pricecontroller.text,
        "Dscrp": feature,
      });
    } else {
      data.add({
        "titleE": titleEcontroller.text,
        "titleA": titleAcontroller.text,
        "Price": pricecontroller.text,
        "Dscrp": feature,
      });
    }
    Get.back();
  }

  features(String dataedit, int index) {
    featurecontroller.text = dataedit;
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
              title: CustomtextField(
                  hint: "13".tr, textEditingController: featurecontroller),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                GestureDetector(
                    onTap: () {
                      if (dataedit.isNotEmpty) {
                        feature[index] = featurecontroller.text;
                        Get.back();
                        featurecontroller.clear();
                        update();
                      } else {
                        feature.add(featurecontroller.text);
                        featurecontroller.clear();
                        update();
                      }
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

  deletefeautre(int index) {
    feature.removeAt(index);
    update();
  }
}

class Price extends StatelessWidget {
  const Price({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PriceController>(
        init: PriceController(),
        builder: (controller) {
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
                          "0".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: Get.width / 18),
                        ),
                        ButtonDesign(
                          onTap: () => Get.to(() => const PriceOperation(),
                              transition: Transition.zoom),
                          iconData: Icons.add,
                        ),
                      ],
                    ),
                    StreamBuilder(
                        stream: controller.data.snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                          if (snap.hasData) {
                            return ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snap.data!.docs.length,
                                itemBuilder: (_, index) {
                                  var data = snap.data!.docs[index];

                                  return Design(
                                      onDelete: () =>
                                          controller.delete(data.id),
                                      onUpdate: () => Get.to(
                                          () => PriceOperation(
                                              title: data['titleE'],
                                              titleA: data['titleA'],
                                              feature: data['Dscrp'],
                                              price: data['Price'],
                                              edit: true,
                                              id: data.id),
                                          transition: Transition.fadeIn),
                                      title: data[Root.lang == "en"
                                          ? 'titleE'
                                          : 'titleA']);
                                });
                          }
                          return const LoadingDesign();
                        })
                  ],
                ),
              ),
            ))),
          );
        });
  }
}

class PriceOperation extends StatelessWidget {
  final bool edit;
  final String? id;
  final String titleA;
  final String title;
  final String price;
  final List feature;
  const PriceOperation({
    this.id,
    this.edit = false,
    super.key,
    this.titleA = '',
    this.title = '',
    this.price = '',
    this.feature = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PriceOperationController>(
        init: PriceOperationController(),
        builder: (controller) {
          controller.titleEcontroller.text = title;
          controller.titleAcontroller.text = titleA;
          controller.pricecontroller.text = price;
          if (feature.isNotEmpty) {
            controller.feature = feature;
            controller.update();
          }
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
                        hint: "${"7".tr} ${"Ar".tr}",
                        textEditingController: controller.titleAcontroller),
                    CustomtextField(
                        hint: "${"7".tr} ${"En".tr}",
                        textEditingController: controller.titleEcontroller),
                    CustomtextField(
                        hint: "12".tr,
                        textEditingController: controller.pricecontroller),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "13".tr,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: Get.width / 18),
                          ),
                          ButtonDesign(
                              onTap: () => controller.features("", 0),
                              iconData: Icons.add)
                        ],
                      ),
                    ),
                    Divider(
                      indent: 50,
                      endIndent: 50,
                      color: Theme.of(context).colorScheme.secondary,
                      thickness: 2.5,
                    ),
                    SingleChildScrollView(
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
                                    "${controller.feature[index]}",
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
                                            controller.feature[index], index),
                                        iconData: Icons.edit),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    ButtonDesign(
                                        onTap: () =>
                                            controller.deletefeautre(index),
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
