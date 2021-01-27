import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/type.dart';


class Input extends StatelessWidget {

  final TextEditingController controller;
  final bool enabled;
  final int maxLength;

  Input({
    this.controller,
    this.enabled = true,
    this.maxLength
  });

  OutlineInputBorder standardBorder({Color color}){
    return OutlineInputBorder(borderSide:
      BorderSide(width: 2, color: color ?? PigColor.interfaceGrey.withOpacity(0.5)),
      borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)));
  }

  InputDecoration get codeDecoration =>  InputDecoration(
    hintText: '',
    counterText: '',
    fillColor: PigColor.interfaceGrey.withOpacity(enabled ? 0.5 : 0.1),
    filled: true,
    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
    focusedBorder: standardBorder(color: PigColor.primary),
    errorBorder: standardBorder(color: PigColor.error),
    disabledBorder: standardBorder(color: PigColor.interfaceGrey.withOpacity(0.1)),
    enabledBorder: standardBorder()
  );


  @override
  Widget build(BuildContext context) {
    return
      TextField(
        controller: controller,
        maxLength: maxLength ?? TextField.noMaxLength,
        decoration: codeDecoration,
        style: TextStyles.button(context),
        textAlign: TextAlign.center);

  }
}