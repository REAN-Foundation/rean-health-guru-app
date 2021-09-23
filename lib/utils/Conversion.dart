class Conversion {
  static double kgToLbs(double weightInKg) {
    return weightInKg * 2.20462;
  }

  static double lbsToKg(double weightInLbs) {
    return weightInLbs / 2.20462;
  }

  static double cmToFeet(double lenghtInCm) {
    return double.parse((lenghtInCm / 30.48).toStringAsFixed(1));
  }

  static double FeetToCm(double lenghtInFeet) {
    return double.parse((lenghtInFeet * 30.48).toStringAsFixed(0));
  }
}
