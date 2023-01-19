import 'package:flutter/material.dart';

class Conversion {
  static double kgToLbs(double weightInKg) {
    return weightInKg * 2.20462;
  }

  static double lbsToKg(double weightInLbs) {
    return weightInLbs / 2.20462;
  }

  static String cmToFeet(int lenghtInCm) {
    debugPrint('Height In cm ==> $lenghtInCm');
    double heightInInches = lenghtInCm * 0.393701;
    double heightInFoot = heightInInches / 12;
    double heightInInch = heightInInches % 12;
    return heightInFoot.toInt().toString() +
        '.' +
        heightInInch.round().toString();
  }

  static double FeetToCm(double lenghtInFeet) {
    debugPrint('Height In Feet ==> $lenghtInFeet');
    return double.parse((lenghtInFeet * 30.48).toStringAsFixed(3));
  }

  static String FeetAndInchToCm(int lenghtInFeet, int lenghtInInch) {
    debugPrint('Height In Feet ==> $lenghtInFeet');
    debugPrint('Height In Inch ==> $lenghtInInch');

    double heightInInches = lenghtInFeet * 12;
    heightInInches = heightInInches + lenghtInInch;
    double heightInCm = heightInInches * 2.54;
    debugPrint('Height In Cm in Conversion ==> $heightInCm');
    return heightInCm.round().toString();
  }

  static String durationFromMinToHrsToString(int minutes) {
    final d = Duration(minutes: minutes);
    final List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')} hr ${parts[1].padLeft(2, '0')} min';
  }

  static String durationFromSecToMinToString(int seconds) {
    final d = Duration(seconds: seconds);
    final List<String> parts = d.toString().split(':');
    if(parts[0] == '0') {
      return '${parts[1].padLeft(2, '0')} min ${parts[2]
          .padLeft(2, '0')
          .replaceRange(2, parts[2]
          .padLeft(2, '0')
          .length, '')} sec';
    }else{
      return '${parts[0].padLeft(2, '0')} hrs ${parts[1].padLeft(2, '0')} min ${parts[2]
          .padLeft(2, '0')
          .replaceRange(2, parts[2]
          .padLeft(2, '0')
          .length, '')} sec';
    }
  }
}
