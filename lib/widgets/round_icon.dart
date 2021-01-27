
import 'package:flutter/material.dart';

class RoundIcon extends StatelessWidget {

  final Size size;
  final Color color;
  final IconData icon;
  final Color iconColor;
  // colored border, no fill
  final bool stadium;
  // offset colored fill
  final bool stadiumFill;

  RoundIcon({
    this.size,
    this.icon,
    this.color,
    this.iconColor = Colors.white,
    this.stadium = false,
    this.stadiumFill = false,
  });

  Color get fill {
    if (stadium) return stadiumFill ? this.color.withOpacity(0.2): Colors.transparent;
    return color ?? Colors.black.withOpacity(0.4);
  }

  Color get border {
    if (stadium) return color ?? Colors.black.withOpacity(0.4);
    return Colors.transparent;
  }

  Color get text {
    if (stadium) return color ?? Colors.black.withOpacity(0.4);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:size.height,
      width: size.width,
      child: Container(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.all(Radius.circular(size.width)),
          border: Border.all(color: border, width: 1)
        ),
        child: Center(
          child: Icon(icon, size: size.width * 0.5, color: iconColor),
        )
      ),
    );
  }

}