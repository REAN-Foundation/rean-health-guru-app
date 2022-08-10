import 'package:flutter/material.dart';

class Conversion {
  static double kgToLbs(double weightInKg) {
    return weightInKg * 2.20462;
  }

  static double lbsToKg(double weightInLbs) {
    return weightInLbs / 2.20462;
  }

  static double cmToFeet(double lenghtInCm) {
    debugPrint('Height In cm ==> $lenghtInCm');
    return double.parse((lenghtInCm / 30.48).toStringAsFixed(2));
  }

  static double FeetToCm(double lenghtInFeet) {
    debugPrint('Height In Feet ==> $lenghtInFeet');
    return double.parse((lenghtInFeet * 30.48).toStringAsFixed(3));
  }

  static String durationFromMinToHrsToString(int minutes) {
    final d = Duration(minutes: minutes);
    final List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')} hr ${parts[1].padLeft(2, '0')} min';
  }

  static String durationFromSecToMinToString(int seconds) {
    final d = Duration(seconds: seconds);
    final List<String> parts = d.toString().split(':');
    return '${parts[1].padLeft(2, '0')} min ${parts[2].padLeft(2, '0').replaceRange(2, parts[2].padLeft(2, '0').length, '')} sec';
  }
}
