import 'package:flutter/material.dart';
import 'package:paitent/features/common/appoinment_booking/models/doctorListApiResponse.dart';
import 'package:paitent/features/common/careplan/view_models/patients_care_plan.dart';
import 'package:paitent/features/misc/ui/base_widget.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';

//ignore: must_be_immutable
class AddDoctorDialog extends StatefulWidget {
  Function _submitButtonListner;

  //AllergiesDialog(@required this._allergiesCategoryMenuItems,@required this._allergiesSeveretyMenuItems, @required Function this.submitButtonListner, this.patientId);

  AddDoctorDialog({Key key, @required Function submitButtonListner})
      : super(key: key) {
    _submitButtonListner = submitButtonListner;
  }

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<AddDoctorDialog> {
  var model = PatientCarePlanViewModel();
  var doctorSearchList = <Doctors>[];

  @override
  void initState() {
    super.initState();
  }

  getDoctorListByLocality() async {
    try {
      final DoctorListApiResponse doctorListApiResponse =
          await model.getDoctorList('Bearer ' + auth);

      if (doctorListApiResponse.status == 'success') {
        if (doctorListApiResponse.data.doctors.isNotEmpty) {
          setState(() {
            doctorSearchList.addAll(doctorListApiResponse.data.doctors);
          });
        }
      } else {
        showToast(doctorListApiResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel>(
        model: model,
        builder: (context, model, child) => Container(
              /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              backgroundColor: colorF6F6FF,*/
              child: addOrEditDoctorDialog(context),
            ));
  }

  addOrEditDoctorDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: MediaQuery.of(context).size.width,
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
                  : doctorSearchResultListView()),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }

  Widget doctorSearchResultListView() {
    return ListView.separated(
        itemBuilder: (context, index) => _makeDoctorListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        itemCount: doctorSearchList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget _makeDoctorListCard(BuildContext context, int index) {
    final Doctors doctorDetails = doctorSearchList.elementAt(index);
    debugPrint(doctorDetails.specialities);
    return InkWell(
      onTap: () {
        widget._submitButtonListner(doctorDetails);
      },
      child: MergeSemantics(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryLightColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 40,
                          width: 40,
                          child: Semantics(
                            image: true,
                            label: 'doctors profile photo',
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: primaryColor,
                              child: CircleAvatar(
                                  radius: 38,
                                  backgroundImage: doctorDetails.imageURL ==
                                              '' ||
                                          doctorDetails.imageURL == null
                                      ? AssetImage(
                                          'res/images/profile_placeholder.png')
                                      : NetworkImage(doctorDetails.imageURL)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Semantics(
                              readOnly: true,
                              child: Text(
                                  doctorDetails.prefix +
                                      doctorDetails.firstName +
                                      ' ' +
                                      doctorDetails.lastName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat',
                                      color: primaryColor)),
                            ),
                            ExcludeSemantics(
                              excluding: true,
                              child: Row(
                                children: [
                                  Text(
                                      doctorDetails.specialities ??
                                          doctorDetails.qualification,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w300,
                                          color: textBlack)),
                                  Expanded(
                                    child: Text(
                                      doctorDetails.qualification == null
                                          ? ''
                                          : ', ' + doctorDetails.qualification,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w300,
                                          color: textBlack),
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
