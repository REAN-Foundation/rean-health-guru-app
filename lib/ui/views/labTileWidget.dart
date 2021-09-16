import 'package:flutter/material.dart';
import 'package:paitent/core/models/labsListApiResponse.dart';
import 'package:paitent/ui/shared/app_colors.dart';

class LabTileView extends StatefulWidget {
  Labs labdetails;

  LabTileView(@required this.labdetails);

  @override
  _LabTileViewState createState() => _LabTileViewState(labdetails);
}

class _LabTileViewState extends State<LabTileView> {
  Labs labdetails;

  _LabTileViewState(@required this.labdetails);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                      backgroundImage: (labdetails.imageURL == '') ||
                              (labdetails.imageURL == null)
                          ? AssetImage('res/images/profile_placeholder.png')
                          : NetworkImage(labdetails.imageURL)),
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
                Text(labdetails.firstName + ' ' + labdetails.lastName,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(labdetails.locality,
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
