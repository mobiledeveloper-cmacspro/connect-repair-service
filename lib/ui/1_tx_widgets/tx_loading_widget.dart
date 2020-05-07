import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';

class TXLoadingWidget extends StatelessWidget {
  final Stream<bool> loadingStream;
  final bool initialData;

  const TXLoadingWidget({
    Key key,
    @required this.loadingStream,
    this.initialData = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<bool>(
        stream: loadingStream,
        initialData: initialData,
        builder: (_, snapshot) {
          if (snapshot.data)
            return _TXLoadingFullScreen();
          else
            return Container();
        },
      ),
    );
  }
}

class _TXLoadingFullScreen extends StatelessWidget {
  final double dimension;
  final bool dimBackground;

  const _TXLoadingFullScreen({
    Key key,
    this.dimension = 45,
    this.dimBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x8A656C79),
      constraints: BoxConstraints(),
      child: AbsorbPointer(
        child: Center(
          child: Container(
            width: dimension,
            height: dimension,
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(R.color.primary_dark_color),
              strokeWidth: 3,
              backgroundColor: null,
            ),
          ),
        ),
      ),
    );
  }
}
