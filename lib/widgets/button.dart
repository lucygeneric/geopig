import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/type.dart';
import 'package:geopig/utils.dart';

class Button extends StatelessWidget {

  final String label;
  final Function onTap;
  final Color color;

  Button({this.label, this.onTap, this.color = PigColor.interfaceGrey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity, child:
      RaisedButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius)
        ),
        color: color,
        onPressed: onTap,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(label, style: TextStyles.button(context).copyWith(color: Utils.darken(color, 0.5))
        )),
      )
    );
  }

}