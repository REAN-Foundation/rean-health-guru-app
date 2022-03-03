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

  static String durationToString(int minutes) {
    final d = Duration(minutes: minutes);
    final List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')} hr ${parts[1].padLeft(2, '0')} min';
  }
}
