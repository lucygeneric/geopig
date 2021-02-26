import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/mixins/dialog.dart';
import 'package:geopig/models/event.dart';
import 'package:geopig/models/site.dart';
import 'package:geopig/models/user.dart';
import 'package:geopig/pages/dashboard/site_map.dart';
import 'package:geopig/redux/actions/event.dart';
import 'package:geopig/redux/actions/scan.dart';
import 'package:geopig/redux/actions/site.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/states/scan.dart';
import 'package:geopig/redux/store.dart';
import 'package:geopig/services/scan.dart';
import 'package:geopig/type.dart';
import 'package:geopig/utils.dart';
import 'package:geopig/widgets/button.dart';
import 'package:geopig/widgets/qr_scanner.dart';
import 'package:async_redux/async_redux.dart' as Redux;
import 'package:geopig/widgets/round_icon.dart';
import 'package:uuid/uuid.dart';

class _Dashboard extends StatefulWidget {

  final ScanFlowState state;
  final User user;
  final Event event;

  _Dashboard({this.state, this.user, this.event});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<_Dashboard> with DialogBuilder {

  void handleScan(Map<String, dynamic>result, ScanFlowState state) async {
    List<dynamic> errors = await ScanService.decodeScan(result);
    if (errors.isEmpty){
      store.dispatch(UpdateScanFlowState(value: state));
    } else {
      generalDialog(context: context,
        title: "Does not compute!",
        copy: "I cannot complete this site scan.. the device tells me that '${errors.join(',')}.",
        buttons: [
          Button(label: "Try Again", onTap:() => Navigator.pop(context), state: ButtonState.PRIMARY),
        ]);
    }
  }

  /// WIDGETS //////////////////////////////////////////////////////////////////
  Widget get dashboardWidget {
    switch(widget.state){
      case ScanFlowState.SCANNED_IN:
        return scannedIn;
        break;
      case ScanFlowState.SCANNING_OUT:
        return scanningOut;
        break;
      case ScanFlowState.SCANNED_OUT:
        return scannedOut;
        break;
      case ScanFlowState.FORCE_SCAN_OUT:
        return forceScanOut;
        break;
      default:
        return idle;
    }
  }

  /// IDLE /////////////////////////////////////////////////////////////////////
  Widget get idle {

    Size size = MediaQuery.of(context).size;

    return Padding(padding: EdgeInsets.only(top: kGutterWidth), child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top:kGutterWidth, left:kGutterWidth), child:
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:[
                  Flexible(flex: 0, child: Text("Good ${Utils.flatulation} ", style: TextStyles.subtitle(context, PigColor.headlineText , FontWeight.bold))),
                  if (widget.user.name != '')
                    Flexible(flex: 1, child: Text(widget.user.name ?? '', style: TextStyles.subtitle(context))),
              ]),
            ),

            Padding(padding: EdgeInsets.symmetric(horizontal: kGutterWidth), child:
              Text("Let's get started", style: TextStyles.regular(context)),
            ),

            SizedBox(height: 20),

            Container(
              height: 350,
              width: size.width,
              child: Stack(children: [
                Container(child: QRScanner(onComplete: (res) => handleScan(res, ScanFlowState.SCANNED_IN)))
              ])
            ),

            Container(height: 40.0, width: size.width, color: PigColor.interfaceGrey, padding: EdgeInsets.only(top: 10), child:
              Text("Scan the barcode at your site station", style: TextStyles.regular(context), textAlign: TextAlign.center)
            ),

            Padding(padding: EdgeInsets.all(kGutterWidth), child:
              Button(label: "Fake It till ya Bake it (debug)",
                onTap: () async {
                  Site site1 = Site.fromMap({
                    'id': "18008008",
                    'name': "Countdown Meadlowlands",
                    'address': "Cnr Meadowlands Drive & Whitford Road Howick, Auckland 2014",
                    'lat': -36.91358480134965,
                    'lng': 174.9281519651413,
                    'geojson': "{\"type\":\"Feature\",\"properties\": {\"stroke\": \"#019ade\",\"stroke-width\": 2,\"stroke-opacity\": 1,\"fill\": \"#019ade\",\"fill-opacity\": 0.5},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[174.9281519651413,-36.91358480134965],[174.92881447076797,-36.91404802047552],[174.9290773272514,-36.913831422993695],[174.92905586957932,-36.91376494245511],[174.92925435304642,-36.913597668585574],[174.9292328953743,-36.91326526429449],[174.92897808551788,-36.913091555669276],[174.92866694927216,-36.91312157941055],[174.9281519651413,-36.91358480134965]]]}}"
                  });
                  await store.dispatchFuture(AddSite(site: site1));

                  Event e = Event(id: Uuid().v4(), timestamp: DateTime.now().subtract(Duration(days: 1, seconds: 200)), type: EventType.SCAN_IN, data: EventData(
                    latitude: -36.91345183978462,
                    longitude: 174.92854356765747,
                    accuracy: 8.0,
                    siteId: site1.id
                  ));

                  await store.dispatchFuture(AddEvent(event: e));
                  store.dispatchFuture(UpdateScanFlowState(value: ScanFlowState.SCANNED_IN));
                },
              )
            )
          ]),
        );
  }

  /// SCANNED IN ///////////////////////////////////////////////////////////////
  Widget get scannedIn {

    Size size = MediaQuery.of(context).size;

    return Padding(padding: EdgeInsets.only(top: kGutterWidth), child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top:kGutterWidth, left:kGutterWidth), child:
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:[
                  Flexible(flex: 0, child: Text("Good ${Utils.flatulation} ", style: TextStyles.subtitle(context, PigColor.headlineText , FontWeight.bold))),
                  if (widget.user.name != '')
                    Flexible(flex: 1, child: Text(widget.user.name ?? '', style: TextStyles.subtitle(context))),
              ]),
            ),

            Padding(padding: EdgeInsets.symmetric(horizontal: kGutterWidth), child:
              Text("You are on site.", style: TextStyles.regular(context).copyWith(color: PigColor.primary, fontWeight: FontWeight.w600)),
            ),

            SizedBox(height: 20),

            Container(
              height: 350,
              width: size.width,
              child: SiteMap(event: widget.event)
            ),

            Padding(padding: EdgeInsets.symmetric(horizontal: kGutterWidth, vertical: kGutterWidth * 0.5), child:
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.event.site.name, style: TextStyles.important(context)),
                  Text(widget.event.site.address, style: TextStyles.regular(context)),
                ],
              )
            ),

            Spacer(),

            Padding(padding: EdgeInsets.symmetric(horizontal: kGutterWidth, vertical: kGutterWidth * 0.5), child:
              Button(label: "Scan out of site", state: ButtonState.PRIMARY,
                onTap: () => store.dispatch(UpdateScanFlowState(value: ScanFlowState.SCANNING_OUT)),
              )
            )
          ]),
        );
  }

  /// SCANNING OUT /////////////////////////////////////////////////////////////
  Widget get scanningOut {

    Size size = MediaQuery.of(context).size;

    return Padding(padding: EdgeInsets.only(top: kGutterWidth), child:
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top:kGutterWidth, left:kGutterWidth), child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:[
              Flexible(flex: 0, child: Text("Good ${Utils.flatulation} ", style: TextStyles.subtitle(context, PigColor.headlineText , FontWeight.bold))),
              if (widget.user.name != '')
                Flexible(flex: 1, child: Text(widget.user.name ?? '', style: TextStyles.subtitle(context))),
          ]),
        ),

        Padding(padding: EdgeInsets.symmetric(horizontal: kGutterWidth), child:
          Text("Good work, time to go!", style: TextStyles.regular(context).copyWith(color: PigColor.primary)),
        ),

        SizedBox(height: 20),

        Container(
          height: 350,
          width: size.width,
          child: Stack(children: [
            Container(child: QRScanner(onComplete: (res) => handleScan(res, ScanFlowState.SCANNED_OUT)))
          ])
        ),

        Container(height: 40.0, width: size.width, color: PigColor.interfaceGrey, padding: EdgeInsets.only(top: 10), child:
          Text("Scan the barcode at your site station", style: TextStyles.regular(context), textAlign: TextAlign.center)
        ),

        Spacer(),

        Padding(padding: EdgeInsets.symmetric(horizontal: kGutterWidth), child:
          Button(label: "Can't scan out?",
            onTap: () => store.dispatch(UpdateScanFlowState(value: ScanFlowState.FORCE_SCAN_OUT)),
          )
        ),

        Padding(padding: EdgeInsets.symmetric(horizontal: kGutterWidth), child:
          Button(label: "Cancel", state: ButtonState.WARN,
            onTap: () => store.dispatch(UpdateScanFlowState(value: ScanFlowState.SCANNED_IN)),
          )
        )
      ]),
    );
  }

  /// SCANNED OUT //////////////////////////////////////////////////////////////
  Widget get scannedOut {

    Size size = MediaQuery.of(context).size;

    return Container(height: size.height, width: size.width, color: Colors.white, child:
      Padding(padding: EdgeInsets.symmetric(horizontal: kGutterWidth), child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            RoundIcon(color: PigColor.primary, icon: Icons.done, size: Size(80,80)),
            SizedBox(height: 30),
            Text("You have scanned out!", style: TextStyles.important(context)),
             SizedBox(height: 15),
            Text("Excellent work today ${(widget.user.name != '') ? widget.user.name : ''}.", style: TextStyles.regular(context), textAlign: TextAlign.center,),
            Spacer(),
            Button(label: "Awesome Sauce", state: ButtonState.PRIMARY,
              onTap: () => store.dispatch(UpdateScanFlowState(value: ScanFlowState.IDLE))
            ),
          ],
        )
      )
    );
  }

  /// FORCE SCAN OUT ///////////////////////////////////////////////////////////
  Widget get forceScanOut {

    Size size = MediaQuery.of(context).size;

    return Container(height: size.height, width: size.width, color: Colors.white, child:
      Padding(padding: EdgeInsets.symmetric(horizontal: kGutterWidth), child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            RoundIcon(color: PigColor.warn, icon: Icons.remove, size: Size(80,80)),
            SizedBox(height: 30),
            Text("Problems scanning out?", style: TextStyles.important(context)),
             SizedBox(height: 15),
            Text("I can do this for you but I will have to record this as a missing scan-out event.", style: TextStyles.regular(context), textAlign: TextAlign.center,),
            Spacer(),
            Button(label: "Go ahead and log me out of this site", state: ButtonState.PRIMARY,
              onTap: () async  {
                await ScanService.forceScanOut();
                store.dispatch(UpdateScanFlowState(value: ScanFlowState.IDLE));
              }
            ),
            Button(label: "No! Take me back to safety",
              onTap: () => store.dispatch(UpdateScanFlowState(value: ScanFlowState.SCANNED_IN)),
            )
          ],
        )
      )
    );
  }









  @override
  Widget build(BuildContext context) {
    return dashboardWidget;
  }
}


class DashboardModel extends Redux.BaseModel<AppState> {
  DashboardModel();

  ScanFlowState flowState;
  User user;
  Event event;

  DashboardModel.build({
    @required this.flowState,
    @required this.user,
    @required this.event,
  }) : super(equals: [user, flowState, event]);

  @override
  DashboardModel fromStore() {

    Event event;

    if (state.eventState.events.isNotEmpty)
      event = state.eventState.events.first;

    if (event != null && event.type != EventType.SCAN_IN)
      event = null;

    return DashboardModel.build(
      flowState: state.scanState.state,
      user: state.userState.user,
      event: event
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Redux.StoreConnector<AppState, DashboardModel>(
      model: DashboardModel(),
      builder: (BuildContext context, DashboardModel vm) => _Dashboard(
        state: vm.flowState,
        user: vm.user,
        event: vm.event
      ),
    );
  }
}