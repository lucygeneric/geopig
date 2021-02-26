
import 'package:flutter/material.dart';
import 'package:geopig/models/event.dart';
import 'package:geopig/models/site.dart';
import 'package:geopig/models/user.dart';
import 'package:geopig/pages/dashboard/dashboard.dart';
import 'package:geopig/pages/info/info.dart';
import 'package:geopig/pages/profile/profile.dart';
import 'package:geopig/redux/actions/interface.dart';
import 'package:geopig/redux/actions/scan.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/states/event.dart';
import 'package:geopig/redux/states/scan.dart';
import 'package:geopig/redux/store.dart';
import 'package:geopig/widgets/bottom_bar.dart';
import 'package:async_redux/async_redux.dart' as Redux;

class _Base extends StatefulWidget {

  final int pageIndex;
  _Base({this.pageIndex = 0});

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<_Base> {

  @override
  void initState(){
    // preload some stuff
    startup();
    super.initState();
  }

  void startup() async {
    // check models
    await User.db.load();
    await Site.db.load();
    await Event.db.load();
    // preset state based on data
    List<Event> events = store.state.eventState.events;
    if (events.isNotEmpty && events.first.type == EventType.SCAN_IN){
      store.state.scanState.forceState(ScanFlowState.SCANNED_IN);
      store.dispatch(UpdatePage(index: 1));
    }
  }

  Widget get currentPage {
    switch(widget.pageIndex){
      case 0:
        return Info();
        break;
      case 1:
        return Dashboard();
        break;
      case 2:
        return Profile();
        break;
      default:
        return Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomBar(),
    );
  }
}

class BaseModel extends Redux.BaseModel<AppState> {
  BaseModel();

  int pageIndex;

  BaseModel.build({
    @required this.pageIndex,
  }) : super(equals: [pageIndex]);

  @override
  BaseModel fromStore() {
    return BaseModel.build(
      pageIndex: state.interfaceState.pageIndex,
    );
  }
}

class Base extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Redux.StoreConnector<AppState, BaseModel>(
      model: BaseModel(),
      builder: (BuildContext context, BaseModel vm) => _Base(
        pageIndex: vm.pageIndex
      ),
    );
  }
}