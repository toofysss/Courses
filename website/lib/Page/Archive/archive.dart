import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycourse/Page/Archive/archiveheader.dart';
import 'package:mycourse/UI/buttondesign.dart';
import 'package:mycourse/UI/design.dart';
import 'package:mycourse/UI/loadingdesign.dart';

import '../../UI/bgdesign.dart';
import 'archivedata.dart';

class ArchiveController extends GetxController {
  final data = FirebaseFirestore.instance.collection("archive");

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

class Archive extends StatelessWidget {
  const Archive({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArchiveController>(
        init: ArchiveController(),
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
                          "5".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: Get.width / 18),
                        ),
                        ButtonDesign(
                          onTap: () => Get.to(
                              () => const ArchiveHeaderOperation(),
                              transition: Transition.zoom),
                          iconData: Icons.add,
                        ),
                      ],
                    ),
                    StreamBuilder(
                        stream: controller.data
                            .orderBy('year', descending: true)
                            .snapshots(),
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

                                  return GestureDetector(
                                    onTap: () => Get.to(
                                        () => ArchiveData(
                                              id: data.id,
                                              feature: data['Dscrp'],
                                              title: data['year'],
                                            ),
                                        transition: Transition.fadeIn),
                                    child: Design(
                                        onDelete: () =>
                                            controller.delete(data.id),
                                        onUpdate: () => Get.to(
                                            () => ArchiveHeaderOperation(
                                                year: data['year'],
                                                edit: true,
                                                id: data.id),
                                            transition: Transition.fadeIn),
                                        title: data['year']),
                                  );
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
