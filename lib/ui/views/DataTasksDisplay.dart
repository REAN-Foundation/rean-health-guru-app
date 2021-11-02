import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/ui/shared/app_colors.dart';

class DataTasksDisplay extends StatelessWidget {
  final Widget icon;
  final String title;
  final int count;
  final String text;

  DataTasksDisplay({
    @required this.icon,
    @required this.title,
    @required this.count,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 90,
      width: screenWidth * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 1.1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: textBlack,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
