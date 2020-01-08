import 'package:flutter/widgets.dart';
import 'package:repairservices/di/injector.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';

///This state already setups a [BlocProvider] as it's main child.
abstract class StateWithBloC<W extends StatefulWidget, B extends BaseBloC>
    extends State<W> {

  ///Current bloc instance
  B bloc;
  static bool alreadyNavigate = false;

  ///If the current widget is able to navigate forward to login again. Usually this is true if the widget is a page
  bool shouldReLogin() => false;

  @override
  void initState() {
    bloc = Injector.instance.getNewBloc();
    super.initState();
  }

  @override
  void dispose(){
    print('dispose $this');
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: buildWidget(context),
    );
  }

  ///Use this one instead of [build]
  Widget buildWidget(BuildContext context);
}
