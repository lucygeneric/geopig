import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/models/event.dart';
import 'package:geopig/services/map.dart';
import 'package:geopig/type.dart';
import 'package:geopig/widgets/appended_label.dart';
import 'package:geopig/widgets/progress.dart';
import 'package:geopig/widgets/round_icon.dart';

class ActivityTile extends StatefulWidget {

  final Event event;
  final bool hilite;

  ActivityTile({this.event, this.hilite = false});

  @override
  _ActivityTileState createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {

  Uint8List mapAsBytes;
  final GlobalKey activityKey = GlobalKey();

  bool get isMissingScan => widget.event.type == EventType.SCAN_MISSING;

  @override
  void initState() {
    super.initState();
    if (widget.hilite)
      WidgetsBinding.instance.addPostFrameCallback(
        (_) =>  generateMap(activityKey.currentContext.size.width.floor(), activityKey.currentContext.size.height.floor())
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

    // HILITED
    if (widget.hilite)
      return Container(
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
        child: Column(children: [
          Flexible(flex: 0, child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
              color: Colors.white,

            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children:[
                Flexible(flex: 1, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppendedLabel(
                      str1: Text("${kHumanDateFormat.format(widget.event.timestamp)} @ ", style: TextStyles.regular(context).copyWith(fontSize: 14.0)),
                      str2: Text(kHourMinuteJMFormat.format(widget.event.timestamp), style: TextStyles.important(context).copyWith(fontSize: 14.0)),
                      leftDominant: true,
                    ),
                    AppendedLabel(
                      str1: Text("${widget.event.typeAsString}: ", style: TextStyles.important(context)),
                      str2: Text("${widget.event.site?.name ?? 'Unknown Site'} ", style: TextStyles.regular(context), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false,),
                      leftDominant: false,
                    )
                  ])),
                Flexible(flex: 0, child: RoundIcon(color: isMissingScan ? PigColor.error : PigColor.primary, icon: isMissingScan ? Icons.close : Icons.done, size: Size(18,18)))
              ]),
            )
          ),
          Flexible(flex: 1, child: Container(child: (mapAsBytes == null ? Center(child: ProgressSpinner(size: 10)) : Container())))
        ])

      );



    // SINGLE
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
          color: PigColor.interfaceGrey
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children:[
            Flexible(flex: 1, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${kHumanDateFormat.format(widget.event.timestamp)}", style: TextStyles.regular(context).copyWith(fontSize: 14.0)),
                AppendedLabel(
                  str1: Text("${widget.event.typeAsString}: ", style: TextStyles.important(context)),
                  str2: Text("${widget.event.site?.name ?? 'Unknown Site'} ", style: TextStyles.regular(context)),
                )
              ])),
            Flexible(flex: 0, child: RoundIcon(color: PigColor.primary, icon: Icons.done, size: Size(18,18)))
          ]),
      );
  }
}