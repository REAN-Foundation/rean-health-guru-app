import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends ChangeNotifier?> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child)? builder;
  final T? model;
  final Widget? child;
  final Function(T)? onModelReady;

  const BaseWidget({
    Key? key,
    this.builder,
    this.model,
    this.child,
    this.onModelReady,
  }) : super(key: key);

  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier?>
    extends State<BaseWidget<T?>> with WidgetsBindingObserver{
  T? model;

  @override
  void initState() {
    model = widget.model;

    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('App life cycle state ==> $state');
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  void onResumed(){
    debugPrint('<== Apps is in onResumed ==>');
  }

  void onPaused(){
    debugPrint('<== Apps is in onPaused ==>');
  }

  void onInactive(){
    debugPrint('<== Apps is in onInactive ==>');
  }

  void onDetached(){
    debugPrint('<== Apps is in onDetached ==>');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T?>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder!,
        child: widget.child,
      ),
    );
  }
}
