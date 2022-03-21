import 'package:flutter/material.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/infra/themes/app_colors.dart';

//ignore: must_be_immutable
class DoctorTileView extends StatefulWidget {
  Doctors doctorDetails;

  DoctorTileView(this.doctorDetails);

  @override
  _DoctorTileViewState createState() => _DoctorTileViewState(doctorDetails);
}

class _DoctorTileViewState extends State<DoctorTileView> {
  Doctors doctorDetails;

  _DoctorTileViewState(this.doctorDetails);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                    child: Container(
                  height: 48,
                  width: 48,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: primaryColor,
                    child: CircleAvatar(
                        radius: 38,
                        backgroundImage: doctorDetails.imageURL == ''
                            ? AssetImage('res/images/profile_placeholder.png')
                            : NetworkImage(doctorDetails.imageURL)),
                  ),
                )),
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
                    Text(
                        doctorDetails.prefix +
                            doctorDetails.firstName +
                            ' ' +
                            doctorDetails.lastName,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: primaryColor)),
                    Text(
                        doctorDetails.specialities +
                            ', ' +
                            doctorDetails.qualification,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w100,
                            color: textBlack,
                            fontFamily: 'Montserrat')),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 55,
              ),
              RichText(
                text: TextSpan(
                  text: '    Consultation Fee :',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textBlack,
                      fontSize: 14,
                      fontFamily: 'Montserrat'),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' ₹' + doctorDetails.consultationFee.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontSize: 14,
                            fontFamily: 'Montserrat')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
