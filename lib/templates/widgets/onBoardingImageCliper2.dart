import 'package:flutter/material.dart';

class OnBoardingImageCliper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height-100);
    path.lineTo(size.width, -0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
