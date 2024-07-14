import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycourse/UI/bgdesign.dart';
import 'package:mycourse/UI/buttondesign.dart';
import 'package:mycourse/UI/customtextfield.dart';
import 'package:mycourse/constant/root.dart';
import '../../UI/design.dart';
import '../../UI/loadingdesign.dart';

class ServiceController extends GetxController {
  final data = FirebaseFirestore.instance.collection("service");
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
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 14),
                              blurRadius: 28,
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.22),
                              offset: Offset(0, 10),
                              blurRadius: 10,
                            ),
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

class ServiceOperationController extends GetxController {
  ServiceController homeController = Get.put(ServiceController());
  get homedata => homeController.data;
  TextEditingController titleAController = TextEditingController();
  TextEditingController titleEController = TextEditingController();
  TextEditingController subtitleEController = TextEditingController();
  TextEditingController subtitleAController = TextEditingController();
  TextEditingController iconController = TextEditingController();
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
      homedata.doc(id).update({
        "titleA": titleAController.text,
        "titleE": titleEController.text,
        "subtitleA": subtitleAController.text,
        "subtitleE": subtitleEController.text,
        "icon": iconController.text,
      });
    } else {
      homedata.add({
        "titleA": titleAController.text,
        "titleE": titleEController.text,
        "subtitleA": subtitleAController.text,
        "subtitleE": subtitleEController.text,
        "icon": iconController.text,
      });
    }
    Get.back();
  }
}

class Service extends StatelessWidget {
  const Service({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
        init: ServiceController(),
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
                          "1".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: Get.width / 18),
                        ),
                        ButtonDesign(
                          onTap: () => Get.to(() => const ServiceOperation(),
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
                                      onUpdate: () {
                                        Get.to(
                                            () => ServiceOperation(
                                                titleA: data['titleA'],
                                                titleE: data['titleE'],
                                                subtitleA: data['subtitleA'],
                                                subtitleE: data['subtitleE'],
                                                icon: data['icon'],
                                                edit: true,
                                                id: data.id),
                                            transition: Transition.fadeIn);
                                      },
                                      title: Root.lang == "en"
                                          ? data['titleE']
                                          : data['titleA']);
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

class ServiceOperation extends StatelessWidget {
  final bool edit;
  final String? id;
  final String titleA;
  final String titleE;
  final String subtitleE;
  final String subtitleA;
  final String icon;
  const ServiceOperation(
      {this.id,
      this.edit = false,
      this.titleA = '',
      super.key,
      this.titleE = '',
      this.subtitleE = '',
      this.subtitleA = '',
      this.icon = ''});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceOperationController>(
        init: ServiceOperationController(),
        builder: (controller) {
          controller.titleAController.text = titleA;
          controller.titleEController.text = titleE;
          controller.subtitleAController.text = subtitleA;
          controller.subtitleEController.text = subtitleE;
          controller.iconController.text = icon;
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
                        hint: "${"7".tr} ${"Ar".tr} ",
                        textEditingController: controller.titleAController),
                    CustomtextField(
                        hint: "${"7".tr} ${"En".tr} ",
                        textEditingController: controller.titleEController),
                    CustomtextField(
                        hint: "${"8".tr} ${"Ar".tr} ",
                        textEditingController: controller.subtitleAController),
                    CustomtextField(
                        hint: "${"8".tr} ${"En".tr} ",
                        textEditingController: controller.subtitleEController),
                    CustomtextField(
                        hint: "11".tr,
                        textEditingController: controller.iconController),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: Get.mediaQuery.viewInsets.bottom))
                  ],
                ),
              ),
            ))),
          );
        });
  }
}
