import 'package:flutter/material.dart';
import 'package:patient/features/common/appointment_booking/models/labs_list_api_response.dart';
import 'package:patient/infra/themes/app_colors.dart';

//ignore: must_be_immutable
class LabTileView extends StatefulWidget {
  Labs? labdetails;

  LabTileView(this.labdetails);

  @override
  _LabTileViewState createState() => _LabTileViewState(labdetails);
}

class _LabTileViewState extends State<LabTileView> {
  Labs? labdetails;

  _LabTileViewState(this.labdetails);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                height: 48,
                width: 48,
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: primaryColor,
                  child: CircleAvatar(
                      radius: 48,
                      backgroundImage: ((labdetails!.imageURL == '') ||
                                  (labdetails!.imageURL == null)
                              ? AssetImage('res/images/profile_placeholder.png')
                              : NetworkImage(labdetails!.imageURL!))
                          as ImageProvider<Object>?),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(labdetails!.firstName! + ' ' + labdetails!.lastName!,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(labdetails!.locality!,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        color: Color(0XFF909CAC))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
