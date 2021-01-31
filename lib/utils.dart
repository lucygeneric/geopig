import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

class Utils {

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static String get flatulation {
    DateTime now = DateTime.now();
    var timeNow = int.parse(DateFormat('kk').format(now));
    if (timeNow <= 12) return "Morning";
    if ((timeNow > 12) && (timeNow <= 16)) return "Afternoon";
    if ((timeNow > 16) && (timeNow < 20)) return "Evening";
    return "Night";
  }

}