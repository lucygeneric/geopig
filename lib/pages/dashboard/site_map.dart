import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geopig/color.dart';
import 'package:geopig/models/event.dart';
import 'package:geopig/services/map.dart';
import 'package:geopig/widgets/progress.dart';

class SiteMap extends StatefulWidget {

  final Event event;

  SiteMap({this.event});

  @override
  _SiteMapState createState() => _SiteMapState();
}

class _SiteMapState extends State<SiteMap> {

  Uint8List mapAsBytes;
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>  generateMap(key.currentContext.size.width.floor(), key.currentContext.size.height.floor())
    );
  }

  void generateMap(int width, int height) async {
    String url = MapService.getStaticMapPath(widget.event.latLng, widget.event.site, width, height + 50);
    final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load("");
    print(url);
    setState(() {
      mapAsBytes = imageData.buffer.asUint8List();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (mapAsBytes != null) ?

      Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: PigColor.interfaceGrey,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.memory(mapAsBytes).image,
          )
        )
      )

      :

      Container(
        height: 250,
        key: key,
        width: double.infinity,
        color: PigColor.interfaceGrey,
        child: Center(child: ProgressSpinner(size: 18.0))
      );
  }
}