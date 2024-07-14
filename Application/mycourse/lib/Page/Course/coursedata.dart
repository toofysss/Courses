import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycourse/Page/Course/course.dart';
import 'package:mycourse/UI/bgdesign.dart';
import 'package:mycourse/UI/buttondesign.dart';
import 'package:mycourse/UI/customtextfield.dart';
import 'package:mycourse/UI/design.dart';
import 'package:mycourse/UI/loadingdesign.dart';
import 'package:path/path.dart';

class CourseDataController extends GetxController {
  CourseController controller = Get.put(CourseController());
  get data => controller.data;
  bool animation = false;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animation = true;
      update();
    });
    super.onInit();
  }

  delete(String id, String doc) {
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
                      data.doc(doc).collection('Project').doc(id).delete();
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

class CourseDataOperationController extends GetxController {
  CourseController controller = Get.put(CourseController());
  get data => controller.data;
  File? imgprofile;

  String imgprofilePath = '';
  TextEditingController title = TextEditingController();

  bool animation = false;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animation = true;
      update();
    });
    super.onInit();
  }

  setimgprofile() async {
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    imgprofile = File(img.path);
    String randomNumber = Random().nextInt(100).toString();
    imgprofilePath = '$randomNumber${basename(img.path)}';
    update();
  }

  operation(bool edit, String id, var data) async {
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

    if (edit) {
      data.doc(id).update({
        "Title": title.text,
      });
    } else {
      var firebasestorage =
          FirebaseStorage.instance.ref("Project/$imgprofilePath");
      await firebasestorage.putFile(imgprofile!);
      var imglink = await firebasestorage.getDownloadURL();

      data.add({
        "Title": title.text,
        "img": imglink,
      });
    }
    Get.back();
    Get.back();
  }
}

class CourseData extends StatelessWidget {
  final String id;
  final String title;
  const CourseData({required this.id, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseDataController>(
        init: CourseDataController(),
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
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: Get.width / 18),
                        ),
                        ButtonDesign(
                          onTap: () => Get.to(
                              () => CourseDataOperation(
                                    data: controller.data
                                        .doc(id)
                                        .collection('Project'),
                                  ),
                              transition: Transition.zoom),
                          iconData: Icons.add,
                        ),
                      ],
                    ),
                    StreamBuilder(
                        stream: controller.data
                            .doc(id)
                            .collection('Project')
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
                                  QueryDocumentSnapshot<Object?> data =
                                      snap.data!.docs[index];
                                  return GestureDetector(
                                    child: Design(
                                        img: data['img'],
                                        onDelete: () =>
                                            controller.delete(data.id, id),
                                        onUpdate: () => Get.to(
                                            () => CourseDataOperation(
                                                  edit: true,
                                                  id: data.id,
                                                  img: data['img'],
                                                  title: data['Title'],
                                                  data: controller.data
                                                      .doc(id)
                                                      .collection('Project'),
                                                ),
                                            transition: Transition.fadeIn),
                                        title: data['Title']),
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

class CourseDataOperation extends StatelessWidget {
  final bool edit;
  final String? id;
  final CollectionReference<Map<String, dynamic>> data;
  final String img;
  final String title;

  const CourseDataOperation(
      {this.id,
      required this.data,
      this.edit = false,
      this.img = '',
      this.title = '',
      super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseDataOperationController>(
        init: CourseDataOperationController(),
        builder: (controller) {
          controller.title.text = title;
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                            onTap: () =>
                                controller.operation(edit, "$id", data),
                            iconData: Icons.save_rounded,
                          ),
                        ],
                      ),
                    ),
                    img.isNotEmpty && controller.imgprofile == null
                        ? GestureDetector(
                            onTap: () => controller.setimgprofile(),
                            child: Container(
                              width: 200,
                              height: 200,
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
                        : controller.imgprofile != null
                            ? GestureDetector(
                                onTap: () => controller.setimgprofile(),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: FileImage(controller.imgprofile!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () => controller.setimgprofile(),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 1,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 0),
                                            color:
                                                Theme.of(context).shadowColor)
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
                              ),
                    CustomtextField(
                        hint: "7".tr, textEditingController: controller.title),
                  ],
                ),
              ),
            ))),
          );
        });
  }
}
