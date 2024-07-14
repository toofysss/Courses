import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycourse/UI/buttondesign.dart';

class Design extends StatelessWidget {
  final Function()? onUpdate;
  final Function()? onDelete;
  final String title;
  final String img;
  const Design(
      {required this.onDelete,
      required this.onUpdate,
      required this.title,
      this.img = '',
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          img.isNotEmpty
              ? Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(img), fit: BoxFit.fill)),
                )
              : const SizedBox(),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Get.width / 22),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ButtonDesign(
                  onTap: onUpdate,
                  iconData: Icons.edit,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ButtonDesign(
                  onTap: onDelete,
                  iconData: CupertinoIcons.trash_fill,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
