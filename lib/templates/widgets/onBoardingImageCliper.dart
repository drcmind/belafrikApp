import 'package:flutter/material.dart';

class OnBoardingImageCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height-10);
    path.quadraticBezierTo(
        size.width-100, size.height -50, size.width, size.height-10);
    path.lineTo(size.width, -0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
