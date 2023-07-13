import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:patient/infra/themes/app_colors.dart';

import '../../../misc/ui/base_widget.dart';
import '../view_models/all_achievement_view_model.dart';

//ignore: must_be_immutable
class BadgesDetailsDialog extends StatefulWidget {
  late String _image;
  late String _tittle;
  late String _description;

  //AllergiesDialog(@required this._allergiesCategoryMenuItems,@required this._allergiesSeveretyMenuItems, @required Function this.submitButtonListner, this.patientId);

  BadgesDetailsDialog({Key? key, required String image, required String tittle, required String description})
      : super(key: key) {
    _image = image;
    _tittle = tittle;
    _description = description;
  }

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<BadgesDetailsDialog> {

  var model = AllAchievementViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<AllAchievementViewModel?>(
        model: model,
        builder: (context, model, child) => Container(
              /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              backgroundColor: colorF6F6FF,*/
              child: dialog(context),
            ));
  }

  dialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: widget._image,
              width: 80,
              height: 80,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(height: 16,),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('How to earn ${widget._tittle} Badge',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16.0,
                  color: textBlack,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 8,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget._description.toString(),//+'\n\n'+widget._description.toString()+'\n\n'+widget._description.toString()
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: textBlack,
                        fontWeight: FontWeight.w500),
                  ),
                  /*SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('2. ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: textBlack,
                            fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Text('For 7 consistent days take your medications and earn a badge.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: textBlack,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),*/
                  SizedBox(height: 8,),
/*                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('3. ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: textBlack,
                            fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Text('Stay consistent: Regularly use the app and maintain a consistent engagement level to unlock additional badges and rewards.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: textBlack,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('4. ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: textBlack,
                            fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Text('Track your progress: Keep track of your achievements, milestones, and completed tasks through the app\'s tracking features.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: textBlack,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Text('Remember, each badge or award signifies your dedication and progress towards a healthier and more fulfilling lifestyle. Keep up the great work and enjoy earning your well-deserved recognition!',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: textBlack,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8,),*/


                ],
              ),
            ),
          ),
          SizedBox(height: 8,),
          Center(child: _submitButton(context)),
        ],
      ),
    );
  }


  Widget _submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Text(
        '      Okay       ',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(primaryLightColor),
          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: primaryColor)))),
    );
  }

}
