import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/achievement/view_models/all_achievement_view_model.dart';

import '../../../../infra/themes/app_colors.dart';
import '../../../../infra/utils/common_utils.dart';
import '../../../misc/ui/base_widget.dart';
import '../models/get_my_awards.dart';

class AllAchievementView extends StatefulWidget {
  @override
  _AllAchievementViewState createState() => _AllAchievementViewState();
}

class _AllAchievementViewState extends State<AllAchievementView> {

  var model = AllAchievementViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Data> awardsList = <Data>[];

  getAwardsDetails() async {
    try {
      GetMyAwards getMyAwards =
      await model.getMyAwards();
      if (getMyAwards.status == 'success') {
        debugPrint('Awards List ==> ${getMyAwards.toJson().toString()}');
        awardsList.clear();
        awardsList.addAll(getMyAwards.data!.toList());
        setState(() {

        });
      } else {

        //showToast(getMyVitalsHistory.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  @override
  void initState() {
    getAwardsDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<AllAchievementViewModel?>(
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
              'Achievements',
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
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    color: primaryColor,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                              height: 60,
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 0,),
                                Text(
                                  'My Badges',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 8,),
                                Container(
                                  height: 24,
                                  width: MediaQuery.of(context).size.width * 0.34,
                                  decoration: BoxDecoration(
                                      color: primaryLightColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.all( Radius.circular(12))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amberAccent,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text('Awards',
                                          style: TextStyle(
                                              color: textBlack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat')),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(awardsList.length.toString()+'/3',
                                          style: TextStyle(
                                              color: textBlack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat')),
                                    ],
                                  ),

                                ),

                                SizedBox(height: 0,),
                              ],
                        ),
                            )),
                        Container(
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('res/images/awards/ic_medicatio_medal.png',
                                height: 80,
                                width: 80,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: model!.busy ? Center(child: CircularProgressIndicator(color: primaryColor,),) :allAchievements(),
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

  Widget allAchievements(){
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8,),
            Text(
              'Medication',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4,),
            SizedBox(
                height: 140,
                child: awardsListView()),
/*            SizedBox(height: 16,),
            Text(
              'Nutrition',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4,),
            SizedBox(
                height: 120,
                child: awardsListView(3)),
            SizedBox(height: 16,),
            Text(
              'Physical Activity',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4,),
            SizedBox(
                height: 120,
                child: awardsListView(6)),
            SizedBox(height: 16,),
            Text(
              'Mental Well-Being',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4,),
            SizedBox(
                height: 120,
                child: awardsListView(4)),
            SizedBox(height: 16,),
            Text(
              'Vitals',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4,),
            SizedBox(
                height: 120,
                child: awardsListView(6)),
            SizedBox(height: 16,),
            Text(
              'Symptoms',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4,),
            SizedBox(
                height: 120,
                child: awardsListView(5)),
            SizedBox(height: 16,),
            Text(
              'Lab Values',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4,),
            SizedBox(
                height: 120,
                child: awardsListView(3)),*/
          ],
        ),
      ),
    );
  }

  Widget awardsListView(){
    return ListView.separated(
        itemBuilder: (context, index) => _makeAwardsListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 2,
          );
        },
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true);
  }

  Widget _makeAwardsListCard(BuildContext context, int index) {
    String name = '';
    String image = '';
    double opacity = 0.2;
    Color textColor = Colors.black;

    if(awardsList.length == 1 && index == 0){
      //Data data = awardsList.elementAt(index);
      name = '7 - Days';
      image = 'res/images/awards/ic_bronze_medicatio_medal.png';
      opacity = 1.0;
    }else{
      name = '7 - Days';
      image = 'res/images/awards/ic_bronze_medicatio_medal.png';
      opacity = 0.2;
      textColor = Colors.grey;
    }

    if(index == 1){
      name = '14 - Days';
      image = 'res/images/awards/ic_silver_medicatio_medal.png';
      opacity = 0.3;
      textColor = Colors.grey;
    }
     
    if(index == 2){
      name = '30 - Days';
      image = 'res/images/awards/ic_gold_medicatio_medal.png';
      opacity = 0.2;
      textColor = Colors.grey;
    }


    return Container(
      height: 120,
      width: 112,
      child: Card(
        semanticContainer: false,
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12.0,
                color: textColor,
                fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4,),
            Image.asset(image,
              opacity: AlwaysStoppedAnimation(opacity),
              height: 68,
              width: 68,
            ),
            SizedBox(height: 4,),
            Text('Medication',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: textColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

}