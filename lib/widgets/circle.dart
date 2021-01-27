import 'package:flutter/cupertino.dart';

class HollowCircle extends StatelessWidget {

  final Color color;
  final double size;
  HollowCircle({
    @required this.color,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size)),
        border: Border.all(width: size / 10, color: color)
      )
    );
  }

}