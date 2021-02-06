import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/redux/actions/interface.dart';
import 'package:geopig/widgets/bottom_bar_button.dart';
import 'package:geopig/redux/store.dart';


class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      child: Container(height: kBottomAppBarHeight, child:
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            BottomBarButton(
              icon: SvgPicture.asset("assets/icon/icon_info.svg"),
              onTap: () => store.dispatch(UpdatePage(index: 0)),
            ),
            BottomBarButton(
              icon: SvgPicture.asset("assets/icon/icon_scan.svg"),
              onTap: () => store.dispatch(UpdatePage(index: 1)),
            ),
            BottomBarButton(
              icon: SvgPicture.asset("assets/icon/icon_profile.svg"),
              onTap: () => store.dispatch(UpdatePage(index: 2)),
            )
          ]
        )
      )
    );
  }
}