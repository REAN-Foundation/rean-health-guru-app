import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/achievement/view_models/all_achievement_view_model.dart';

import '../../../../infra/themes/app_colors.dart';
import '../../../../infra/utils/common_utils.dart';
import '../../../misc/ui/base_widget.dart';
import '../models/get_my_awards_list.dart';

class AllAchievementView extends StatefulWidget {
  @override
  _AllAchievementViewState createState() => _AllAchievementViewState();
}

class _AllAchievementViewState extends State<AllAchievementView> {

  var model = AllAchievementViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<BadgeList> awardsList = <BadgeList>[];
  List<BadgeList> medicationAwardsList = <BadgeList>[];
  List<BadgeList> nutritionAwardsList = <BadgeList>[];
  List<BadgeList> activityAwardsList = <BadgeList>[];
  List<BadgeList> vitalsAwardsList = <BadgeList>[];
  List<BadgeList> mentalHealthAwardsList = <BadgeList>[];


  getAwardsDetails() async {
    try {
      GetMyAwardsList getMyAwards =
      await model.getMyAwards();
      if (getMyAwards.status == 'success') {
        debugPrint('Awards List ==> ${getMyAwards.toJson().toString()}');
        awardsList.clear();
        awardsList.addAll(getMyAwards.data!.badgeList!.toList());
        sortAwardsListAccordingToCategory();
      } else {

        //showToast(getMyVitalsHistory.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  sortAwardsListAccordingToCategory(){
    debugPrint("Total number of awards ==> ${awardsList.length.toString()}");
    for ( int i = 0 ; i < awardsList.length ; i++ ) {
      debugPrint("Awards Category ==> ${awardsList[i].badge!.category!.name.toString()}");
      if(awardsList[i].badge!.category!.name == 'Medication'){
        medicationAwardsList.add(awardsList[i]);
      }else if(awardsList[i].badge!.category!.name == 'Nutrition'){
        nutritionAwardsList.add(awardsList[i]);
      }else if(awardsList[i].badge!.category!.name == 'Exercise'){
        activityAwardsList.add(awardsList[i]);
      }else if(awardsList[i].badge!.category!.name == 'Vital'){
        vitalsAwardsList.add(awardsList[i]);
      }else if(awardsList[i].badge!.category!.name == 'MentalHealth'){
        mentalHealthAwardsList.add(awardsList[i]);
      }
  }
    debugPrint("Total number of Medication awards ==> ${medicationAwardsList.length.toString()}");
    debugPrint("Total number of Nutrition awards ==> ${nutritionAwardsList.length.toString()}");
    debugPrint("Total number of Exercise awards ==> ${activityAwardsList.length.toString()}");
    debugPrint("Total number of Vital awards ==> ${vitalsAwardsList.length.toString()}");
    debugPrint("Total number of Mental Health awards ==> ${medicationAwardsList.length.toString()}");
    setState(() {

    });

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
                                      Text('Awards:',
                                          style: TextStyle(
                                              color: textBlack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat')),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(awardsList.length.toString()+'',
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
                child: medicationAwardsListView()),
            SizedBox(height: 16,),
            Text(
              'Nutrition',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4,),
            SizedBox(
                height: 140,
                child: nutritionAwardsListView()),
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
                height: 140,
                child: activityAwardsListView()),
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
                height: 140,
                child: mentalHealthAwardsListView()),
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
                height: 140,
                child: vitalAwardsListView()),
            SizedBox(height: 16,),
/*            Text(
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

  Widget medicationAwardsListView(){
    return ListView.separated(
        itemBuilder: (context, index) => _makeMedicationAwardsListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 2,
          );
        },
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true);
  }

  Widget _makeMedicationAwardsListCard(BuildContext context, int index) {
    String name = '';
    String image = '';
    double opacity = 0.2;
    Color textColor = Colors.grey;

    if(index == 0){
      name = '7 - Days';
      image = "res/images/awards/ic_bronze_medicatio_medal.png";
    }else if(index == 1){
      name = '15 - Days';
      image = "res/images/awards/ic_silver_medicatio_medal.png";
    }else if(index == 2){
      name = '30 - Days';
      image = "res/images/awards/ic_gold_medicatio_medal.png";
    }


      for ( int i = 0 ; i < medicationAwardsList.length ; i++ ) {

      if(medicationAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
      }/*else{
        name = '7 - Days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(medicationAwardsList[i].badge!.name!.contains('15-day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '15 - Days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(medicationAwardsList[i].badge!.name!.contains('30-day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '30 - Days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

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

  Widget nutritionAwardsListView(){
    return ListView.separated(
        itemBuilder: (context, index) => _makeNutritionAwardsListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 2,
          );
        },
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true);
  }

  Widget _makeNutritionAwardsListCard(BuildContext context, int index) {
    String name = '';
    String image = '';
    double opacity = 0.2;
    Color textColor = Colors.grey;

    if(index == 0){
      name = '7 - Days';
      image = "res/images/awards/ic_bronze_nutrtion_medal.png";
    }else if(index == 1){
      name = '15 - Days';
      image = "res/images/awards/ic_silver_nutritiono_medal.png";
    }else if(index == 2){
      name = '30 - Days';
      image = "res/images/awards/ic_gold_nutrition_medal.png";
    }


    for ( int i = 0 ; i < nutritionAwardsList.length ; i++ ) {

      if(nutritionAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
      }/*else{
        name = '7 - Days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(nutritionAwardsList[i].badge!.name!.contains('15-day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '15 - Days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(nutritionAwardsList[i].badge!.name!.contains('30-day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '30 - Days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

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
            Text('Nutrition',
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

  Widget activityAwardsListView(){
    return ListView.separated(
        itemBuilder: (context, index) => _makeActivityAwardsListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 2,
          );
        },
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true);
  }

  Widget _makeActivityAwardsListCard(BuildContext context, int index) {
    String name = '';
    String image = '';
    double opacity = 0.2;
    Color textColor = Colors.grey;
    //int count = 0;

    if(index == 0){
      name = '7 - Days';
      image = "res/images/awards/ic_bronze_activity_medal.png";
    }else if(index == 1){
      name = '15 - Days';
      image = "res/images/awards/ic_silver_activity_medal.png";
    }else if(index == 2){
      name = '30 - Days';
      image = "res/images/awards/ic_gold_activity_medal.png";
    }


    for ( int i = 0 ; i < activityAwardsList.length ; i++ ) {

      if(activityAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
      }/*else{
        name = '7 - Days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(activityAwardsList[i].badge!.name!.contains('15-Day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '15 - Days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(activityAwardsList[i].badge!.name!.contains('30-day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '30 - Days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

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
            Text('Physical Activity',
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

  Widget mentalHealthAwardsListView(){
    return ListView.separated(
        itemBuilder: (context, index) => _makeMentalHealthAwardsListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 2,
          );
        },
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true);
  }

  Widget _makeMentalHealthAwardsListCard(BuildContext context, int index) {
    String name = '';
    String image = '';
    double opacity = 0.2;
    Color textColor = Colors.grey;
    //int count = 0;

    if(index == 0){
      name = '7 - Days';
      image = "res/images/awards/ic_bronze_activity_medal.png";
    }else if(index == 1){
      name = '15 - Days';
      image = "res/images/awards/ic_silver_activity_medal.png";
    }else if(index == 2){
      name = '30 - Days';
      image = "res/images/awards/ic_gold_activity_medal.png";
    }


    for ( int i = 0 ; i < mentalHealthAwardsList.length ; i++ ) {

      if(mentalHealthAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
      }/*else{
        name = '7 - Days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(mentalHealthAwardsList[i].badge!.name!.contains('15-Day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '15 - Days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(mentalHealthAwardsList[i].badge!.name!.contains('30-day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '30 - Days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

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
            Text('Mental Well-Being',
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

  Widget vitalAwardsListView(){
    return ListView.separated(
        itemBuilder: (context, index) => _makeVitalAwardsListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 2,
          );
        },
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true);
  }

  Widget _makeVitalAwardsListCard(BuildContext context, int index) {
    String name = '';
    String image = '';
    double opacity = 0.2;
    Color textColor = Colors.grey;
    //int count = 0;

    if(index == 0){
      name = '7 - Days';
      image = "res/images/awards/ic_bronze_activity_medal.png";
    }else if(index == 1){
      name = '15 - Days';
      image = "res/images/awards/ic_silver_activity_medal.png";
    }else if(index == 2){
      name = '30 - Days';
      image = "res/images/awards/ic_gold_activity_medal.png";
    }


    for ( int i = 0 ; i < vitalsAwardsList.length ; i++ ) {

      if(vitalsAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
      }/*else{
        name = '7 - Days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(vitalsAwardsList[i].badge!.name!.contains('15-Day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '15 - Days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(vitalsAwardsList[i].badge!.name!.contains('30-day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
      }/*else {
        name = '30 - Days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

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
            Text('Vitals',
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