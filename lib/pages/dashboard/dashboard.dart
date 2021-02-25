import 'package:flutter/material.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/mixins/dialog.dart';
import 'package:geopig/models/event.dart';
import 'package:geopig/models/user.dart';
import 'package:geopig/pages/dashboard/site_map.dart';
import 'package:geopig/redux/actions/scan.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/states/scan.dart';
import 'package:geopig/redux/states/user.dart';
import 'package:geopig/redux/store.dart';
import 'package:geopig/services/scan.dart';
import 'package:geopig/type.dart';
import 'package:geopig/utils.dart';
import 'package:geopig/widgets/button.dart';
import 'package:geopig/widgets/qr_scanner.dart';
import 'package:async_redux/async_redux.dart' as Redux;

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
      default:
        return idle;
    }
  }

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
          ]),
        );
  }


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
          ]),
        );
  }

  Widget get scanningOut => Container();

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
      event = state.eventState.events.last;
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
        user: vm.user
      ),
    );
  }
}