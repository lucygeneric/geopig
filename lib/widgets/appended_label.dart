import 'package:flutter/cupertino.dart';

class AppendedLabel extends StatelessWidget {

  final Text str1;
  final Text str2;
  final bool leftDominant;

  AppendedLabel({this.str1, this.str2, this.leftDominant = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children:[
        Flexible(flex: 1,
          child: str1
        ),
        Flexible(flex: leftDominant ? 0 : 2,
          child: str2
        ),
      ]);
  }

}