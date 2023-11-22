import 'package:flutter/material.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
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
  late BuildContext _context;

  @override
  void initState() {
    model = widget.model;
    eventTrigger();
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

  eventTrigger(){
    //myEvent + (args) => debugPrint('MyEvent Occured ==> Title :  ${args!.title.toString()}\nBody :  ${args.body.toString()}\nType :  ${args.type.toString()}');
    myEvent.subscribe((args) {
      debugPrint('MyEvent Occured ==> \nTitle :  ${args!.title.toString()}\nBody :  ${args.body.toString()}\nType :  ${args.type.toString()}');
      if(args.type.toString() == "Reminder"){
       /// reminderAlert(args.title.toString());
      }
    });
  }

  reminderAlert(String message){
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        width: 300.0,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.all(16.0),
              child: Center(child: Text('Reminder', style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w700),)),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView( scrollDirection: Axis.vertical, child: Text(message.toString(), style: TextStyle(color: textBlack, fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.left,)),
            )),
            Center(
              child: ElevatedButton(onPressed: () {
                Navigator.of(_context).pop();
              },
                  child: Text('Got It!', style: TextStyle(color: Colors.white, fontSize: 18.0),)),
            ),
            SizedBox(height: 16,)
          ],
        ),
      ),
    );
    showDialog(context: _context, builder: (BuildContext context) => errorDialog);
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
      default:
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
    _context = context;
    return ChangeNotifierProvider<T?>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder!,
        child: widget.child,
      ),
    );
  }




}
