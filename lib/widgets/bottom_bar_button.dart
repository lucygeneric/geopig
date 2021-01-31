import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBarButton extends StatefulWidget {

  final Widget icon;
  final Function onTap;

  BottomBarButton({
    this.icon,
    this.onTap
  });

  @override
  _BottomBarButtonState createState() => _BottomBarButtonState();
}

class _BottomBarButtonState extends State<BottomBarButton> {


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: widget.icon
    );
  }
}