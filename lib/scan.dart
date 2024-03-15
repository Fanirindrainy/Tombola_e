import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:tombola/resultScan.dart';

class ScanView extends StatefulWidget {
  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  String result = "Hey there!";

  @override
  Widget build(BuildContext context) {
    // Aller directement à la page QRViewExample
    Future.delayed(Duration.zero, () {
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (context) => const QRViewExample(),
      ))
          .then((_) {
        final qrViewExampleState = context.read<_QRViewExampleState>();
        qrViewExampleState?.stopCamera();
      });
    });

    // Retourner un conteneur vide car la page précédente ne sera pas affichée
    return Container();
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  bool isScanning = true;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  // In order to get hot reload to work we need to pafuse the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  void stopCamera() {
    qrController?.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /* if (result != null)
                    Text(
                        'Type: ${describeEnum(result!.format)}   Donnée: ${result!.code}')
                  else
                    const Text(
                      'Scan Qr billets Tombola',
                      style: TextStyle(color: Color(0xFF02023B)),
                    ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: IconButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          icon: FutureBuilder<bool?>(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Icon(snapshot.data == true
                                  ? Icons.flash_on
                                  : Icons.flash_off);
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: IconButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          icon: FutureBuilder<CameraFacing>(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Icon(snapshot.data == CameraFacing.back
                                    ? Icons.camera_rear
                                    : Icons.camera_front);
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: IconButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                            setState(() {});
                          },
                          icon: const Icon(Icons.pause, size: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: IconButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                            setState(() {});
                          },
                          icon: const Icon(Icons.play_arrow, size: 20),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (isScanning) {
        setState(() {
          isScanning =
              false; // Désactivez le scanner après la première détection
          result = scanData;
          if (result.toString().isNotEmpty) {
            controller.dispose();
            qrController?.stopCamera();
            controller?.stopCamera();

            String? code = result?.code;
            Map<String, dynamic>? decodedToken = decodeJWT(code!);
            if (decodedToken != null) {
              // Accéder aux données du token
              String ticket = decodedToken.toString();
              String trimmedTicket = ticket.substring(1, ticket.length - 1);
            
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Result(
                      title: "Resultat du scanne ", result: trimmedTicket),
                ),
              );
            } else {
            }
          }
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    qrController?.dispose();
    super.dispose();
  }
}

Map<String, dynamic>? decodeJWT(String jwtToken) {
  try {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
    return decodedToken;
  } catch (e) {
  
    return null;
  }
}
