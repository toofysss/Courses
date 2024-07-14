import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycourse/UI/bgdesign.dart';
import 'package:mycourse/UI/buttondesign.dart';
import 'package:mycourse/UI/loadingdesign.dart';
import 'package:path/path.dart';

class GalleryController extends GetxController {
  final data = FirebaseFirestore.instance.collection("gallery");

  String id = "", imgpath = "";
  File? imgLogo;

  bool animation = false;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animation = true;
      update();
    });
    super.onInit();
  }

  void setinglogo() async {
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    imgLogo = File(img.path);
    String randomNumber = Random().nextInt(100).toString();
    imgpath = '$randomNumber${basename(img.path)}';
    update();
  }

  void operation(String id) async {
        showGeneralDialog(
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
                  child: CircularProgressIndicator(
                color: Theme.of(context).shadowColor,
              )),
              actionsAlignment: MainAxisAlignment.center,
            ),
          ),
        );
      },
    );

    var firebasestorage = FirebaseStorage.instance.ref("gallery/$imgpath");
    await firebasestorage.putFile(imgLogo!);
    var imglink = await firebasestorage.getDownloadURL();
    if (id.isNotEmpty) {
      data.doc(id).update({"img": imglink});
    } else {
      data.add({"img": imglink});
    }
    Get.back();
    Get.back();
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

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryController>(
        init: GalleryController(),
        builder: (controller) {
          return Scaffold(
              body: BgDesgin(
            page: SafeArea(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 55),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonDesign(
                          onTap: () => Get.back(),
                          iconData: Icons.arrow_back_ios_new_rounded,
                        ),
                        Text(
                          "3".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: Get.width / 18),
                        ),
                        ButtonDesign(
                          onTap: () => Get.to(() => const Galleryoperation(),
                              transition: Transition.zoom),
                          iconData: Icons.add,
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: controller.data.snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                        if (snap.hasData) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snap.data!.docs.length,
                            itemBuilder: (_, index) {
                              var data = snap.data!.docs[index];
                              return GestureDetector(
                                onTap: () => Get.to(
                                    () => Galleryoperation(
                                          img: data['img'],
                                          id: data.id,
                                        ),
                                    transition: Transition.zoom),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(data['img']),
                                            fit: BoxFit.fill),
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
                                    ])),
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 250,
                                    crossAxisSpacing: 10),
                          );
                        }
                        return const LoadingDesign();
                      })
                ],
              ),
            )),
          ));
        });
  }
}

class Galleryoperation extends StatelessWidget {
  final String img;
  final String id;
  const Galleryoperation({this.img = '', this.id = '', super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryController>(
        init: GalleryController(),
        builder: (controller) {
          return Scaffold(
              body: BgDesgin(
            page: SafeArea(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 55),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonDesign(
                          onTap: () => Get.back(),
                          iconData: Icons.arrow_back_ios_new_rounded,
                        ),
                        Row(
                          children: [
                            ButtonDesign(
                              onTap: () => controller.operation(id),
                              iconData: Icons.save,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: id.isNotEmpty,
                              child: ButtonDesign(
                                onTap: () => controller.delete(id),
                                iconData: CupertinoIcons.trash_fill,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  img.isNotEmpty && controller.imgLogo == null
                      ? GestureDetector(
                          onTap: () => controller.setinglogo(),
                          child: Container(
                            width: 300,
                            height: 300,
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(img),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      : controller.imgLogo != null
                          ? GestureDetector(
                              onTap: () => controller.setinglogo(),
                              child: Container(
                                width: 300,
                                height: 300,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: FileImage(controller.imgLogo!),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => controller.setinglogo(),
                              child: Container(
                                width: 300,
                                height: 300,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 0),
                                          color: Theme.of(context).shadowColor)
                                    ]),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Icon(
                                  Icons.image,
                                  size: Get.width / 7,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            )
                ],
              ),
            )),
          ));
        });
  }
}
