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
import 'package:mycourse/UI/customtextfield.dart';
import 'package:mycourse/UI/loadingdesign.dart';
import 'package:mycourse/constant/root.dart';
import 'package:path/path.dart';

class NewsController extends GetxController {
  final data = FirebaseFirestore.instance.collection("News");
  DateTime now = DateTime.now();

  String id = "", imgpath = "";
  File? imgLogo;

  bool animation = false;

  TextEditingController titleAController = TextEditingController();
  TextEditingController titleEController = TextEditingController();
  TextEditingController dscrpController = TextEditingController();
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

    if (imgLogo == null) {
      if (id.isNotEmpty) {
        data.doc(id).update({
          "Dscrp": dscrpController.text,
          "year": '${now.year}/${now.month}/${now.day}',
          "titleA": titleAController.text,
          "titleE": titleEController.text,
        });
      } else {
        data.add({
          "Dscrp": dscrpController.text,
          "year": '${now.year}/${now.month}/${now.day}',
          "titleA": titleAController.text,
          "titleE": titleEController.text,
        });
      }
    } else {
      var firebasestorage = FirebaseStorage.instance.ref("News/$imgpath");
      await firebasestorage.putFile(imgLogo!);
      var imglink = await firebasestorage.getDownloadURL();
      if (id.isNotEmpty) {
        data.doc(id).update({
          "img": imglink,
          "Dscrp": dscrpController.text,
          "year": '${now.year}/${now.month}/${now.day}',
          "titleA": titleAController.text,
          "titleE": titleEController.text,
        });
      } else {
        data.add({
          "img": imglink,
          "Dscrp": dscrpController.text,
          "year": '${now.year}/${now.month}/${now.day}',
          "titleA": titleAController.text,
          "titleE": titleEController.text,
        });
      }
    }

    Get.back();
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

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
        init: NewsController(),
        builder: (controller) {
          return Scaffold(
              body: BgDesgin(
            page: SafeArea(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonDesign(
                          onTap: () => Get.back(),
                          iconData: Icons.arrow_back_ios_new_rounded,
                        ),
                        Text(
                          "4".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: Get.width / 18),
                        ),
                        ButtonDesign(
                          onTap: () => Get.to(() => const Newsoperation(),
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
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snap.data!.docs.length,
                            itemBuilder: (_, index) {
                              var data = snap.data!.docs[index];
                              return GestureDetector(
                                  onTap: () => Get.to(
                                      () => NewsView(
                                            img: data['img'],
                                            title: data['titleA'],
                                            titleE: data['titleE'],
                                            year: data['year'],
                                            dscrp: data['Dscrp'],
                                            id: data.id,
                                          ),
                                      transition: Transition.zoom),
                                  child: Container(
                                    height: 300,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.25),
                                            offset: Offset(0, 14),
                                            blurRadius: 28,
                                          ),
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.22),
                                            offset: Offset(0, 10),
                                            blurRadius: 10,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: Get.width,
                                          height: 200,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    data['img'],
                                                  ),
                                                  fit: BoxFit.fill)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            data['year'],
                                            style: TextStyle(
                                                fontSize: Get.width / 22,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            data[Root.lang == "en"
                                                ? 'titleE'
                                                : 'titleA'],
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: Get.width / 22,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            },
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

class NewsView extends StatelessWidget {
  final String img;
  final String year;
  final String title;
  final String titleE;
  final String dscrp;
  final String id;
  const NewsView(
      {this.img = '',
      this.id = '',
      this.dscrp = '',
      this.title = '',
      this.titleE = '',
      this.year = '',
      super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
        init: NewsController(),
        builder: (controller) {
          return Scaffold(
              body: BgDesgin(
            page: SafeArea(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: Get.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
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
                                onTap: () => Get.to(
                                    () => Newsoperation(
                                          img: img,
                                          title: title,
                                          titleE: titleE,
                                          year: year,
                                          dscrp: dscrp,
                                          id: id,
                                        ),
                                    transition: Transition.zoom),
                                iconData: Icons.edit,
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
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
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
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(img),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  year,
                                  style: TextStyle(
                                    fontSize: Get.width / 20,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  Root.lang == "en" ? titleE : title,
                                  style: TextStyle(
                                    fontSize: Get.width / 22,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  dscrp,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: Get.width / 22,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
        });
  }
}

class Newsoperation extends StatelessWidget {
  final String img;
  final String year;
  final String title;
  final String titleE;
  final String dscrp;
  final String id;
  const Newsoperation(
      {this.img = '',
      this.id = '',
      this.dscrp = '',
      this.title = '',
      this.titleE = '',
      this.year = '',
      super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
        init: NewsController(),
        builder: (controller) {
          controller.titleAController.text = title;
          controller.titleEController.text = titleE;
          controller.dscrpController.text = dscrp;
          return Scaffold(
              body: BgDesgin(
            page: SafeArea(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonDesign(
                          onTap: () => Get.back(),
                          iconData: Icons.arrow_back_ios_new_rounded,
                        ),
                        ButtonDesign(
                          onTap: () => controller.operation(id),
                          iconData: Icons.save,
                        ),
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
                            ),
                  CustomtextField(
                      hint: "${"7".tr} ${"Ar".tr}",
                      textEditingController: controller.titleAController),
                  CustomtextField(
                      hint: "${"7".tr} ${"En".tr}",
                      textEditingController: controller.titleEController),
                  CustomtextField(
                      hint: "8".tr,
                      textEditingController: controller.dscrpController),
                ],
              ),
            )),
          ));
        });
  }
}
