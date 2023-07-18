import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdminPanelOptionButton extends StatelessWidget {
  final String optionName;
  final String image;
  final Widget navigateTo;
  const AdminPanelOptionButton(
      {super.key,
      required this.optionName,
      required this.image,
      required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => navigateTo));
      },
      child: Container(
        height: Adaptive.h(9),
        width: Adaptive.w(100),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(84, 168, 229, 0.1),
            borderRadius: BorderRadius.circular(13)),
        child: Row(
          children: [
            SizedBox(width: Adaptive.w(4)),
            SizedBox(
                height: Adaptive.h(5),
                width: Adaptive.w(11),
                child: Image.asset(image)),
            SizedBox(width: Adaptive.w(5)),
            Text(optionName,
                style: const TextStyle(color: Colors.white, fontSize: 23))
          ],
        ),
      ),
    );
  }
}
