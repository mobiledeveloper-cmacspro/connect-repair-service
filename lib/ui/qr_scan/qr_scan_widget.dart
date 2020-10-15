import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/qr_scan/qr_scan_widget_bloc.dart';

class QrCodeReaderView extends StatefulWidget {
  final Future Function(String) onScan;
  final double scanBoxSize;
  final Color boxLineColor;
  final Orientation initialOrientation;

  const QrCodeReaderView({
    Key key,
    @required this.onScan,
    this.boxLineColor = Colors.cyanAccent,
    this.scanBoxSize = 200,
    this.initialOrientation,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrCodeReaderViewState();
}

class _QrCodeReaderViewState
    extends StateWithBloC<QrCodeReaderView, QRScanWidgetBloC>
    with TickerProviderStateMixin {
  QrReaderViewController _controller;
  AnimationController _animationController;
  Animation<double> _verticalPosition;
  bool openFlashlight = false;

  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );

    _animationController.addListener(() {
      this.setState(() {});
    });
    _animationController.forward();
    _verticalPosition = Tween<double>(begin: 0.0, end: widget.scanBoxSize)
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.linear))
          ..addStatusListener((state) {
            if (state == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (state == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });
  }

  void _clearAnimation() {
    if (_animationController != null) {
      _animationController?.dispose();
      _animationController = null;
    }
  }

  void _onCreateController(QrReaderViewController controller) async {
    _controller = controller;
    _controller.startCamera(_onQrBack);
  }

  bool isScan = false;

  Future _onQrBack(data, _) async {
    if (isScan == true) return;
    isScan = true;
    stopScan();
    await widget.onScan(data);
  }

  void startScan() {
    isScan = false;
    _controller.startCamera(_onQrBack);
    _initAnimation();
  }

  void stopScan() {
    _clearAnimation();
    _controller.stopCamera();
  }

  Future<void> setFlashlight() async {
    openFlashlight = !openFlashlight;
    bloc.switchFlashlight(openFlashlight);
    await _controller.setFlashlight();
  }

  @override
  Widget buildWidget(BuildContext context) {
    final flashOpen = Icon(Icons.flash_on, color: Colors.white, size: 35);
    final flashClose = Icon(Icons.flash_off, color: Colors.white, size: 35);
    var size = MediaQuery.of(context).size;
    var orientation = MediaQuery.of(context).orientation;
    return Material(
      child: LayoutBuilder(builder: (context, constraint) {
        return Stack(
          children: <Widget>[
            NativeDeviceOrientationReader(
              builder: (context) {
                final readerOrientation =
                    NativeDeviceOrientationReader.orientation(context);
                final turns = orientation == Orientation.portrait
                    ? 0
                    : (readerOrientation ==
                            NativeDeviceOrientation.landscapeRight
                        ? 1
                        : 3);
                return RotatedBox(
                  quarterTurns: turns,
                  child: QrReaderView(
                    width: widget.initialOrientation == Orientation.landscape
                        ? (orientation == Orientation.portrait
                            ? size.width
                            : size.height)
                        : size.width,
                    height: widget.initialOrientation == Orientation.portrait
                        ? size.height
                        : size.width,
                    callback: _onCreateController,
                  ),
                );
              },
              useSensor: false,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 80),
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      height: widget.scanBoxSize,
                      width: widget.scanBoxSize,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: widget.boxLineColor, width: 2.0)),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 120),
                              child: StreamBuilder<bool>(
                                stream: bloc.flashlightStatus,
                                initialData: false,
                                builder: (context, snapshot) {
                                  return IconButton(
                                    icon:
                                        snapshot.data ? flashOpen : flashClose,
                                    onPressed: setFlashlight,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: _verticalPosition.value,
                      child: Container(
                        width: widget.scanBoxSize,
                        height: 2.0,
                        color: widget.boxLineColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _clearAnimation();
    stopScan();
    if (openFlashlight) setFlashlight();
    super.dispose();
  }
}
