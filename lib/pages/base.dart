
import 'package:flutter/material.dart';
import 'package:geopig/pages/dashboard/dashboard.dart';
import 'package:geopig/pages/info/info.dart';
import 'package:geopig/pages/profile/profile.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/widgets/bottom_bar.dart';
import 'package:async_redux/async_redux.dart' as Redux;

class _Base extends StatefulWidget {

  final int pageIndex;
  _Base({this.pageIndex = 0});

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<_Base> {

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