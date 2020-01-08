import 'package:flutter/material.dart';

class CNTLoadingFullScreenWithStream extends StatelessWidget {
  final Stream<bool> loadingStream;
  final bool initialData;

  const CNTLoadingFullScreenWithStream({
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
            return CNTLoadingFullScreen();
          else
            return Container();
        },
      ),
    );
  }
}

class CNTLoadingFullScreen extends StatelessWidget {
  final double dimension;
  final bool dimBackground;

  const CNTLoadingFullScreen({
    Key key,
    this.dimension = 45,
    this.dimBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dimBackground ? Color(0x8A656C79) : Colors.transparent,
      constraints: BoxConstraints(),
      child: AbsorbPointer(
        child: Center(
          child: Container(
            width: dimension,
            height: dimension,
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.grey),
              strokeWidth: 3,
              backgroundColor: null,
            ),
          ),
        ),
      ),
    );
  }
}
