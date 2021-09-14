import 'package:flutter/material.dart';
import 'package:paitent/core/models/pharmacyListApiResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';

class AddPharmaDialog extends StatefulWidget {
  Function _submitButtonListner;

  //AllergiesDialog(@required this._allergiesCategoryMenuItems,@required this._allergiesSeveretyMenuItems, @required Function this.submitButtonListner, this.patientId);

  AddPharmaDialog({Key key, @required Function submitButtonListner})
      : super(key: key) {
    _submitButtonListner = submitButtonListner;
  }

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<AddPharmaDialog> {
  var model = PatientCarePlanViewModel();
  var parmacySearchList = new List<Pharmacies>();

  @override
  void initState() {
    // TODO: implement initState
    getLabListByLocality();
  }

  getLabListByLocality() async {
    try {
      PharmacyListApiResponse listApiResponse = await model
          .getPhrmacyListByLocality("18.526301", "73.834522", 'Bearer ' + auth);

      if (listApiResponse.status == 'success') {
        if (listApiResponse.data.pharmacies.length != 0) {
          parmacySearchList.addAll(listApiResponse.data.pharmacies);
        }
      } else {
        showToast(listApiResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      debugPrint(CustomException);
      //showToast(CustomException.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<PatientCarePlanViewModel>(
        model: model,
        builder: (context, model, child) => Container(
              /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              backgroundColor: colorF6F6FF,*/
              child: addOrEditPharmaDialog(context),
            ));
  }

  addOrEditPharmaDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: MediaQuery.of(context).size.width,
      child: Semantics(
        label: 'circular progress indicator',
        hint: 'stay calm system is busy',
        readOnly: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: model.busy
                    ? Center(
                        child: SizedBox(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator()))
                    : phamacySearchResultListView()),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget noPharmacyFound() {
    return Center(
      child: Semantics(
          readOnly: true,
          child: Text("No Pharmacy found in your Locality",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: primaryLightColor))),
    );
  }

  Widget phamacySearchResultListView() {
    return ListView.separated(
        itemBuilder: (context, index) => _makePharmacyListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        itemCount: parmacySearchList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget _makePharmacyListCard(BuildContext context, int index) {
    Pharmacies pharmaciesDetails = parmacySearchList.elementAt(index);
    return InkWell(
      onTap: () {
        widget._submitButtonListner(pharmaciesDetails);
      },
      child: Container(
        height: 80,
        decoration: new BoxDecoration(
            color: Color(0XFFF5F8FA),
            border: Border.all(color: Color(0XFFF5F8FA)),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(4),
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        child: Center(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image(
                              image: AssetImage(
                                  'res/images/profile_placeholder.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              pharmaciesDetails.firstName +
                                  ' ' +
                                  pharmaciesDetails.lastName,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor)),
                          Text(
                            pharmaciesDetails.address,
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                                color: Color(0XFF909CAC)),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Semantics(
      button: true,
      label: 'save medicines button',
      onTap: () {},
      child: RaisedButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        child: Text(
          '      Add       ',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        textColor: Colors.white,
        color: primaryColor,
      ),
    );
  }
}
