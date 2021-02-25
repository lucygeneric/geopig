import 'package:flutter/material.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/type.dart';

mixin DialogBuilder {
  void generalDialog({
    BuildContext context,
    String title,
    String copy,
    List<Widget> buttons = const []
    }){


    showGeneralDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: "Dialog",
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Padding(padding: EdgeInsets.all(kGutterWidth), child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(title, style: TextStyles.subtitle(context, Colors.black, FontWeight.bold), textAlign: TextAlign.center),
                    SizedBox(height: 10),
                    Text(copy, style: TextStyles.regular(context), textAlign: TextAlign.center)
                  ]),
                ),
                Expanded(
                  flex: 1,
                  child:
                    SizedBox.expand(
                    child: Column(
                      children: <Widget>[
                        ...buttons
                      ])
                    )
                ),
              ],
            ),
          ));
        },
      );
  }
}