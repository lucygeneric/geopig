import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/type.dart';

enum ButtonState { PRIMARY, SECONDARY, WARN, INTERFACE }

class Button extends StatelessWidget {

  final String label;
  final Function onTap;
  final Color color;
  final ButtonState state;

  Button({this.label, this.onTap, this.color, this.state = ButtonState.SECONDARY});

  Color get backgroundFromState {

    if (color != null) return color;

    switch(this.state){
      case ButtonState.PRIMARY:
        return PigColor.primary;
      break;
      case ButtonState.WARN:
        return PigColor.warn;
      break;
      case ButtonState.INTERFACE:
        return Colors.white;
      break;
      default: // ButtonState.SECONDARY
        return PigColor.interfaceGrey;
    }
  }

  Color get textColorFromState {
    if (this.state == ButtonState.SECONDARY)
      return onTap != null ? PigColor.standardText : PigColor.standardText.withOpacity(0.5);
    if (this.state == ButtonState.INTERFACE)
      return PigColor.interfaceGrey;
    return Colors.white;
  }

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
        color: backgroundFromState,
        onPressed: onTap,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(label, style: TextStyles.button(context).copyWith(color: textColorFromState)
        )),
        disabledColor: backgroundFromState.withOpacity(0.5),
      )
    );
  }

}