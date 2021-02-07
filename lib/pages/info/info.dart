import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/models/event.dart';
import 'package:geopig/models/site.dart';
import 'package:geopig/redux/actions/event.dart';
import 'package:geopig/redux/actions/site.dart';
import 'package:geopig/redux/store.dart';
import 'package:geopig/type.dart';
import 'package:geopig/widgets/button.dart';
import 'package:uuid/uuid.dart';

class Info extends StatefulWidget {

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

  void precan() async {

    await Event.db.destroyAll();
    await Site.db.destroyAll();


    List<Event> events = await Event.db.load();
    if (events.isNotEmpty) return;

    Site site1 = Site.fromMap({
      'name': "Robbies Buttons",
      'address': "1 Robbies Road, Cockle Bay, Auckland 2014",
      'geojson': "{\"type\":\"Feature\",\"properties\": {\"stroke\": \"#019ade\",\"stroke-width\": 2,\"stroke-opacity\": 1,\"fill\": \"#019ade\",\"fill-opacity\": 0.5},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[174.9507375061512,-36.90656325586226],[174.95083540678024,-36.90643671627975],[174.95055243372917,-36.906314465975285],[174.95051622390747,-36.90636165032654],[174.95061680674553,-36.906399183312374],[174.9505591392517,-36.906469959749714],[174.9507375061512,-36.90656325586226]]]}}"
    });

    Site site2 = Site.fromMap({
      'name': "Countdown Meadlowlands",
      'address': "Cnr Meadowlands Drive & Whitford Road Howick, Auckland 2014",
      'geojson': "{\"type\":\"Feature\",\"properties\": {\"stroke\": \"#019ade\",\"stroke-width\": 2,\"stroke-opacity\": 1,\"fill\": \"#019ade\",\"fill-opacity\": 0.5},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[174.9281519651413,-36.91358480134965],[174.92881447076797,-36.91404802047552],[174.9290773272514,-36.913831422993695],[174.92905586957932,-36.91376494245511],[174.92925435304642,-36.913597668585574],[174.9292328953743,-36.91326526429449],[174.92897808551788,-36.913091555669276],[174.92866694927216,-36.91312157941055],[174.9281519651413,-36.91358480134965]]]}}"
    });

    await store.dispatchFuture(AddSite(site: site1));
    await store.dispatchFuture(AddSite(site: site2));

    Event e1 = Event(id: Uuid().v4(), timestamp: DateTime.now().subtract(Duration(days: 2, seconds: 12800)), type: EventType.SCAN_IN, data: EventData(
      latitude: -36.904970,
      longitude: 174.948990,
      accuracy: 53.0,
      siteId: site1.id
    ));

    Event e2 = Event(id: Uuid().v4(), timestamp: DateTime.now().subtract(Duration(days: 2, seconds: 11400)), type: EventType.SCAN_OUT, data: EventData(
      latitude: -36.904970,
      longitude: 174.948990,
      accuracy: 20.0,
      siteId: site1.id
    ));

    Event e3 = Event(id: Uuid().v4(), timestamp: DateTime.now().subtract(Duration(days: 1, seconds: 200)), type: EventType.SCAN_IN, data: EventData(
      latitude: -36.91345183978462,
      longitude: 174.92854356765747,
      accuracy: 8.0,
      siteId: site2.id
    ));

    await store.dispatchFuture(AddEvent(event: e1));
    await store.dispatchFuture(AddEvent(event: e2));
    await store.dispatchFuture(AddEvent(event: e3));

  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Container(
      width: s.width, height: s.height,
      padding: EdgeInsets.only(top:kGutterWidth,left:kGutterWidth,right: kGutterWidth),
      child: Stack(children: [
        Positioned(
          top: 0, left: 0, right: 0, bottom: 0,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Padding(padding: EdgeInsets.symmetric(vertical: 20.0), child:
                  SvgPicture.asset("assets/icon/icon_info.svg", width: 100)
                ),

                Text("Welcome to the RealClean onsite app prototype", style: TextStyles.heading(context)),
                SizedBox(height: 20),
                Text(
                  "The purpose of this early-access beta is to facilitate closed alpha user testing.  Questions, complaints or suggestions can be directed at Todd via the RealClean headquarters."
                , style: TextStyles.regular(context)),
                SizedBox(height: 20),
                Text(
                  "To generate a few test sites and some dummy data hit the 'Generate' button below."
                , style: TextStyles.regular(context)),

                Spacer(),
                Button(label: "Generate Test Data", onTap: () => precan())
            ])
        )
      ])
      );
  }
}