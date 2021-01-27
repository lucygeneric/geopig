
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geopig/color.dart';
import 'package:geopig/widgets/circle.dart';

class ProgressSpinner extends StatelessWidget {

  final double size;
  ProgressSpinner({@required this.size});

  @override
  Widget build(BuildContext context) {
    double innerOffset = size / 10;
    return Stack(children: [
      Positioned(top: innerOffset * 0.5, left: innerOffset * 0.5, child:
        HollowCircle(color: PigColor.interfaceGrey, size: size - innerOffset),
      ),
      SizedBox(
        height: size, width: size,
        child: CircularProgressIndicator()
      )
    ]);
  }

}