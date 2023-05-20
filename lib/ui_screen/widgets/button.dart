import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booktickets_app/ui_screen/theme.dart';

class MyButton extends StatelessWidget {
  final String? label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: primaryClr
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label!,
              textAlign: TextAlign.center,
              // style: const TextStyle(
              //   color: Colors.white,
              // ),
              style: subBtnTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
