import 'package:flutter/material.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/type.dart';
import 'package:geopig/utils.dart';
import 'package:geopig/widgets/bottom_bar.dart';
import 'package:geopig/widgets/qr_scanner.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(padding: EdgeInsets.only(top: kGutterWidth), child:
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
                  Flexible(flex: 1, child: Text("Lashawnah.", style: TextStyles.subtitle(context))),
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
                Container(child: QRScanner())
              ])
            ),

            Container(height: 40.0, width: size.width, color: PigColor.interfaceGrey, padding: EdgeInsets.only(top: 10), child:
              Text("Scan the barcode at your site station", style: TextStyles.regular(context), textAlign: TextAlign.center)
            ),
        ]),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }


}