import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/models/site.dart';
import 'package:geopig/pages/navigation/turn_by_turn.dart';
import 'package:geopig/services/location.dart';
import 'package:geopig/services/map.dart';
import 'package:geopig/type.dart';
import 'package:geopig/widgets/round_icon.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';

class SiteTile extends StatefulWidget {

  final Site site;
  final bool hilite;

  SiteTile({this.site, this.hilite = false});

  @override
  _SiteTileState createState() => _SiteTileState();
}

class _SiteTileState extends State<SiteTile> {

  Uint8List mapAsBytes;
  final GlobalKey activityKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.hilite)
      WidgetsBinding.instance.addPostFrameCallback(
        (_) =>  generateMap(activityKey.currentContext.size.width.floor(), activityKey.currentContext.size.height.floor())
      );
  }

  void generateMap(int width, int height) async {
    String url = MapService.getStaticMapPath(widget.site.latLng, widget.site, width, height + 50);
    final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load("");
    setState(() {
      mapAsBytes = imageData.buffer.asUint8List();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        margin: EdgeInsets.only(bottom: 10.0),
        key: activityKey,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
          color: PigColor.interfaceGrey,
          image: (mapAsBytes != null) ?
            DecorationImage(
            fit: BoxFit.cover,
            image: Image.memory(mapAsBytes).image,
          ) : null,
        ),
        child: Container()
      ),

      InkWell(
        onTap: () async {
          dynamic location = await LocationService.currentLocation;
          TurnByTurnNavigationArguments args = TurnByTurnNavigationArguments(
            //origin: LatLng(location.latitue, location.longitude),
            origin: LatLng(-36.863360,174.906490),
            destination: widget.site.latLng,
            name: widget.site.name
          );
          Navigator.pushNamed(context, '/routing', arguments: args);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(kBorderRadius), topRight: Radius.circular(kBorderRadius)),
            color: PigColor.primary,
          ),
          child: Text(widget.site.name, style: TextStyles.important(context).copyWith(color: Colors.white))
        ),
      ),

      Positioned(bottom: 25, left:15, child:
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),

          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
            color: Colors.white,
          ),
          child: Text(widget.site.address, style: TextStyles.smol(context))
        )
      ),

      Positioned(top: 10, right:10, child:
        RoundIcon(color: Colors.white, iconColor: PigColor.primary, icon: Icons.navigation, size: Size(20,20))
      ),
    ]);
  }
}