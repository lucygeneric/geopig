import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geopig/color.dart';

class TextStyles {
  // headlines
  static TextStyle headline(BuildContext context, [Color color, FontWeight fontWeight]) {
    return CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 40.0, color: color ?? PigColor.headlineText, fontWeight: fontWeight ?? FontWeight.w900);
  }

  static TextStyle tagline(BuildContext context, [Color color, FontWeight fontWeight]) {
    return CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 32.0, color: color ?? PigColor.headlineText, fontWeight: fontWeight ?? FontWeight.normal);
  }

  static TextStyle subtitle(BuildContext context, [Color color, FontWeight fontWeight]) {
    return CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 24.0, color: color ?? PigColor.headlineText, fontWeight: fontWeight ?? FontWeight.normal);
  }

  // body
  static TextStyle regular(BuildContext context, [Color color, FontWeight fontWeight]) {
    return CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 16.0, color: color ?? PigColor.standardText, fontWeight: fontWeight ?? FontWeight.normal);
  }

  static TextStyle important(BuildContext context, [Color color, FontWeight fontWeight]) {
    return TextStyles.regular(context).copyWith(fontWeight: FontWeight.w600, color: PigColor.headlineText, inherit: true);
  }

  // button
  static TextStyle button(BuildContext context, [Color color, FontWeight fontWeight]) {
    return TextStyles.regular(context).copyWith(fontWeight: FontWeight.w600, color: PigColor.headlineText, inherit: true);
  }
}