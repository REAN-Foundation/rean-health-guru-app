import 'package:flutter/material.dart';

//ignore: must_be_immutable
class PrimaryLightColorContainer extends StatelessWidget {
  double? size;

  PrimaryLightColorContainer(double size) {
    this.size = size;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
      angle: 40,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white.withAlpha((0.09 * 255).round())),
      ),
    ));
  }
}
