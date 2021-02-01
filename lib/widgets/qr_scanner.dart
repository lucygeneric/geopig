
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {

  static const FLASH_ON   = 'FLASH ON';
  static const FLASH_OFF  = 'FLASH OFF';
  static const CAM_FRONT  = 'FRONT CAMERA';
  static const CAM_BACK   = 'BACK CAMERA';

  final Function onComplete;
  final bool exitOnScan;

  QRScanner({this.onComplete, this.exitOnScan = true});

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {

  var flashState = QRScanner.FLASH_ON;
  var cameraState = QRScanner.CAM_FRONT;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  Barcode result;

  bool isFlashOn(String current) {
    return QRScanner.FLASH_ON == current;
  }

  bool isBackCamera(String current) {
    return QRScanner.CAM_BACK == current;
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void completeScan(){
    widget.onComplete(result);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Stack(
        children: [
          Positioned(left: 0, right: 0, top: 20, child:
            Container(width: size.width, height: 350, child:
              QRView(key: qrKey, onQRViewCreated: onQRViewCreated),
            )
          ),

          Positioned(left: 0, right: 0, bottom: 0, top: 20,
            child: Container(height: 150.0, color: Colors.black.withOpacity(0.4)),
          ),

          Positioned(bottom: 10,  right: 10,
            child: Row(children: <Widget>[
              IconButton(iconSize: 20, color: Colors.white, icon: Icon(Icons.switch_camera),
                onPressed: (){
                  if (controller != null) {
                    controller.flipCamera();
                    if (isBackCamera(cameraState)) {
                      setState(() { cameraState = QRScanner.CAM_FRONT; });
                    } else {
                      setState(() { cameraState = QRScanner.CAM_BACK; });
                    }
                  }
                }),

              IconButton(iconSize: 20, color: Colors.white, icon: Icon(Icons.flash_on),
                onPressed: (){
                  if (controller != null) {
                    controller.flipCamera();
                    if (isFlashOn(flashState)) {
                      setState(() { cameraState = QRScanner.FLASH_OFF; });
                    } else {
                      setState(() { cameraState = QRScanner.FLASH_ON; });
                    }
                  }
                }),
            ])
          ),

          Positioned(top: 0,  right: (size.width * 0.5) - 20, child:
            RotationTransition(
              turns: AlwaysStoppedAnimation(45 / 360),
              child: Container(color: Colors.white, width: 40, height: 40)
            )
          ),

          Positioned(top: 0,  right: (size.width * 0.5) - 18, child:
            Image.asset("assets/pigo_single_vertical.png", width: 36, height: 36)
          )

        ],
      );
  }
}