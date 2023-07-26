import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassRevenueTop extends StatelessWidget {
  final String title;
  final String value;
  const CinePassRevenueTop(
      {super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: Adaptive.w(28),
      height: Adaptive.h(8),
      borderRadius: 8,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 1,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(84, 168, 229, 0.1).withOpacity(0.1),
            const Color(0xFFFFFFFF).withOpacity(0.05),
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text('₹$value',
              style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 17))
        ],
      ),
    );
  }
}

class CinePassRevenueSide extends StatelessWidget {
  final String title;
  final String value;
  final bool? ruppeesSymbol;
  const CinePassRevenueSide(
      {super.key,
      required this.title,
      required this.value,
      this.ruppeesSymbol});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: Adaptive.w(28),
      height: Adaptive.h(7),
      borderRadius: 8,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 1,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(84, 168, 229, 0.1).withOpacity(0.1),
            const Color(0xFFFFFFFF).withOpacity(0.05),
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(ruppeesSymbol == true ? '₹$value' : value,
              style: TextStyle(
                  color:
                      ruppeesSymbol == true ? Colors.green : Colors.blue[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 17))
        ],
      ),
    );
  }
}
