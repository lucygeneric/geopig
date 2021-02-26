import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:latlng/latlng.dart';

class TurnByTurnNavigationArguments {
  LatLng origin;
  LatLng destination;
  String name;

  TurnByTurnNavigationArguments({ this.origin, this.destination, this.name });
}

class TurnByTurnNavigation extends StatefulWidget {

  final LatLng origin;
  final LatLng destination;
  final String destinationName;

  TurnByTurnNavigation({
    this.origin,
    this.destination,
    this.destinationName
  });

  @override
  _TurnByTurnNavigationState createState() => _TurnByTurnNavigationState();
}

class _TurnByTurnNavigationState extends State<TurnByTurnNavigation> {

  MapBoxNavigation directions;
  MapBoxOptions options;

  bool arrived = false;
  bool isMultipleStop = false;
  bool routeBuilt = false;
  bool isNavigating = false;

  double distanceRemaining, durationRemaining;
  MapBoxNavigationViewController navigationViewController;

  String platformVersion = 'Unknown';
  String instruction = "";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  WayPoint get originWaypoint => WayPoint(
    name: "My Location",
    latitude: widget.origin.latitude,
    longitude: widget.origin.longitude
  );

  WayPoint get desitinationWaypoint => WayPoint(
    name: widget.destinationName,
    latitude: widget.destination.latitude,
    longitude: widget.destination.longitude
  );

  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    directions = MapBoxNavigation(onRouteEvent: onEmbeddedRouteEvent);
    options = MapBoxOptions(
      initialLatitude: widget.origin.latitude,
      initialLongitude: widget.origin.longitude,
      zoom: 15.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      units: VoiceUnits.imperial,
      simulateRoute: false,
      animateBuildRoute: true,
      longPressDestinationEnabled: true,
      language: "en");

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      platformVersion = platformVersion;
    });
  }

  Future<void> onEmbeddedRouteEvent(e) async {
    // distanceRemaining = await directions.distanceRemaining;
    // durationRemaining = await directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived;
        if (progressEvent.currentStepInstruction != null)
          instruction = progressEvent.currentStepInstruction;
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        arrived = true;
        if (!isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await navigationViewController.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          routeBuilt = false;
          isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }

  void buildRoute(){
    var wayPoints = List<WayPoint>();
        wayPoints.add(originWaypoint);
        wayPoints.add(desitinationWaypoint);
        navigationViewController.buildRoute(wayPoints: wayPoints);
    directions.startNavigation(
      wayPoints: wayPoints,
      options: MapBoxOptions(
        mode:
            MapBoxNavigationMode.drivingWithTraffic,
        simulateRoute: true,
        language: "en",
        units: VoiceUnits.metric));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey,
          child: MapBoxNavigationView(
              options: options,
              onRouteEvent: onEmbeddedRouteEvent,
              onCreated:
                  (MapBoxNavigationViewController controller) async {
                navigationViewController = controller;
                await navigationViewController.initialize();
                buildRoute();
              }),
        ),
      )
    );
  }
}