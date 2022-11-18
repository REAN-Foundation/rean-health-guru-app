
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/careplan/models/assesment_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';

//ignore: must_be_immutable
class TextTaskView extends StatefulWidget {
  Next? next;

  TextTaskView(this.next);

  @override
  _ChallengeCarePlanViewState createState() => _ChallengeCarePlanViewState();
}

class _ChallengeCarePlanViewState extends State<TextTaskView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _textController = TextEditingController();

  @override
  void initState() {
    /*if (widget.task!.action!.description != null) {
      _textController.text = widget.task!.action!.description.toString();
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              'Assessment',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
              /*IconButton(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 32.0,
                ),
                onPressed: () {
                  debugPrint("Clicked on profile icon");
                },
              )*/
            ],
          ),
          body: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    color: primaryColor,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: primaryColor,
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: body(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //headerText(),
          questionText(),
          _entryField(),
          _submitButton(),
        ],
      ),
    );
  }

  Widget headerText() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorF6F6FF,
      ),
      child: Center(
        child: Text(
          widget.next!.nodeType.toString(),
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget questionText() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: primaryLightColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12))),
      child: Center(
        child: Text(
          '\n' + widget.next!.title.toString(),
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _entryField() {
    return Container(
      margin: EdgeInsets.all(16.0),
      height: 360,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.black54,
            width: 1.0,
          ),
        ),
        child: TextFormField(
            obscureText: false,
            controller: _textController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
              color: Colors.black54,
            ),
            onFieldSubmitted: (term) {},
            decoration: InputDecoration(
                hintText: widget.next!.description ?? '',
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true)),
      ),
    );
  }

  Widget _submitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Material(
          //Wrap with Material
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          elevation: 4.0,
          color: primaryColor,
          clipBehavior: Clip.antiAlias,
          // Add This
          child: MaterialButton(
            minWidth: 120,
            child: Text('Next',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              Navigator.pop(context, _textController.text.toString());
            },
          ),
        ),
      ],
    );
  }
}
