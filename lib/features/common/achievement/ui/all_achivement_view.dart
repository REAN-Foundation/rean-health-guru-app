import 'dart:async';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/achievement/view_models/all_achievement_view_model.dart';

import '../../../../infra/themes/app_colors.dart';
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
      //showToast(e.toString(), context);
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
    Timer(Duration(seconds: 4), () {
      setState(() {});
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
                            child: Semantics(
                              label: awardsList.length.toString()+' Badges Earned',
                              child: ExcludeSemantics(
                                child: Container(
                                  height: 80,
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 0,),
                                    Text(
                                      awardsList.length.toString()+'',
                                      style: TextStyle(
                                          fontSize: 38.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 8,),
                                    Container(
                                      /*height: 24,
                                      width: MediaQuery.of(context).size.width * 0.34,
                                      decoration: BoxDecoration(
                                          color: primaryLightColor.withOpacity(0.5),
                                          borderRadius: BorderRadius.all( Radius.circular(12))),*/
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                         /* SizedBox(
                                            width: 8,
                                          ),*/
                                          /*Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.amberAccent,
                                          ),
                                          ImageIcon(
                                            AssetImage('res/images/ic_badges.png'),
                                            size: 16,
                                            color: Colors.amber,
                                            semanticLabel: 'Achievements',
                                          ),*/
                                          /*SizedBox(
                                            width: 2,
                                          ),*/
                                          Text('Badge Earned',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Montserrat')),
                                          /*SizedBox(
                                            width: 8,
                                          ),
                                          Text(awardsList.length.toString()+'',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Montserrat')),*/
                                        ],
                                      ),

                                    ),

                                    SizedBox(height: 0,),
                                  ],
                        ),
                                ),
                              ),
                            )),
                        ExcludeSemantics(
                          child: Container(
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
              'Medications',
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
    int count = 0;

    if(index == 0){
      name = '7 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/464081fb-e80b-4e6b-a8c4-6dc2caeebab1/download-by-version-name/1";
    }else if(index == 1){
      name = '15 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/c5ddbdea-0dc7-4e18-aaf7-3331006a51e7/download-by-version-name/1";
    }else if(index == 2){
      name = '30 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/4b806c0d-162e-4def-9b87-f591701564e1/download-by-version-name/1";
    }


      for ( int i = 0 ; i < medicationAwardsList.length ; i++ ) {

      if(medicationAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else{
        name = '7 days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(medicationAwardsList[i].badge!.name!.contains('15-Day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else {
        name = '15 days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(medicationAwardsList[i].badge!.name!.contains('30-Day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else {
        name = '30 days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

    }

    String lable = 'Earned '+count.toString()+' Medications badges for '+ name +' ';
    String hint = '';

    if(count > 0){
    } else {
      hint = 'Double click to explore how to earn this badge.';
    }


   return Semantics(
     label: lable,
     hint: hint,
     child: InkWell(
       excludeFromSemantics: true,
       onTap: (){
         /*if(count == 0)
           showDialog(
               barrierDismissible: false,
               context: context,
               builder: (_) {
                 return _badgesDialog(context, image,'Medications');
               });*/
       },
       child: ExcludeSemantics(
         child: Container(
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
                 if(count > 0)...[
                   badges.Badge(
                     badgeContent: Text(count.toString(),
                       style: TextStyle(color: Colors.white),),
                     position: badges.BadgePosition.topEnd(top: -5, end: 2),
                     child:Opacity(
                       opacity: opacity,
                       child: CachedNetworkImage(
                         imageUrl: image,
                         width: 68,
                         height: 68,
                         placeholder: (context, url) => CircularProgressIndicator(),
                         errorWidget: (context, url, error) => Icon(Icons.error),
                       ),
                     ),),
                 ],
                 if(count == 0)...[
                   Opacity(
                     opacity: opacity,
                     child: CachedNetworkImage(
                       imageUrl: image,
                       width: 68,
                       height: 68,
                       placeholder: (context, url) => CircularProgressIndicator(),
                       errorWidget: (context, url, error) => Icon(Icons.error),
                     ),
                   ),
                 ],
                 /*Image.asset(image,
              opacity: AlwaysStoppedAnimation(opacity),
              height: 68,
              width: 68,
            ),*/
                 SizedBox(height: 4,),
                 /*Text('Medication',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.0,
                  color: textColor,
                  fontWeight: FontWeight.w500),
            ),*/
               ],
             ),
           ),
         ),
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
    int count = 0;

    if(index == 0){
      name = '7 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/28858b77-e698-4b2e-b70e-0cb177de5a35/download-by-version-name/1";
    }else if(index == 1){
      name = '15 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/654de7ce-ed98-46a1-aba9-c27ff71c371f/download-by-version-name/1";
    }else if(index == 2){
      name = '30 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/ed6bf9c0-dd93-4099-ba66-341cca6cc5ad/download-by-version-name/1";
    }


    for ( int i = 0 ; i < nutritionAwardsList.length ; i++ ) {
      debugPrint('Award Name ==> ${nutritionAwardsList[i].badge!.name}');
      if(nutritionAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
        count++;
        debugPrint('7 days');
      }/*else{
        name = '7 days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(nutritionAwardsList[i].badge!.name!.contains('15-Day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
        debugPrint('15 days');
      }/*else {
        name = '15 days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(nutritionAwardsList[i].badge!.name!.contains('30-Day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
        debugPrint('30 days');
      }/*else {
        name = '30 days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

    }

    String lable = 'Earned '+count.toString()+' Nutrition badges for '+ name +' ';
    String hint = '';

    if(count > 0){
    } else {
      hint = 'Double click to explore how to earn this badge.';
    }



    return Semantics(
      label: lable,
      hint: hint,
      child: InkWell(
        excludeFromSemantics: true,
        onTap: (){
          /*if(count == 0)
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return _badgesDialog(context, image, name+' Nutrition Badge');
              });*/
        },
        child: Container(
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
                if(count > 0)...[
                  badges.Badge(
                    badgeContent: Text(count.toString(),
                      style: TextStyle(color: Colors.white),),
                    position: badges.BadgePosition.topEnd(top: -5, end: 2),
                    child:Opacity(
                      opacity: opacity,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        width: 68,
                        height: 68,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),),
                ],
                if(count == 0)...[
                  Opacity(
                    opacity: opacity,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      width: 68,
                      height: 68,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ],
                /*Image.asset(image,
                  opacity: AlwaysStoppedAnimation(opacity),
                  height: 68,
                  width: 68,
                ),*/
                SizedBox(height: 4,),
               /* Text('Nutrition',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: textColor,
                      fontWeight: FontWeight.w500),
                ),*/
              ],
            ),
          ),
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
    int count = 0;

    if(index == 0){
      name = '7 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/8ea911f4-4fe4-4d83-904f-b6de37f8d066/download-by-version-name/1";
    }else if(index == 1){
      name = '15 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/dcdc163b-6763-4ce9-8a5a-7a4895277531/download-by-version-name/1";
    }else if(index == 2){
      name = '30 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/342a7849-2513-45b3-acd1-b1cd4b6040cc/download-by-version-name/1";
    }


    for ( int i = 0 ; i < activityAwardsList.length ; i++ ) {

      if(activityAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else{
        name = '7 days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(activityAwardsList[i].badge!.name!.contains('15-Day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else {
        name = '15 days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(activityAwardsList[i].badge!.name!.contains('30-Day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else {
        name = '30 days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

    }

    String lable = 'Earned '+count.toString()+' Physical Activity badges for '+ name +' ';
    String hint = '';

    if(count > 0){
    } else {
      hint = 'Double click to explore how to earn this badge.';
    }


    return Semantics(
      label: lable,
      hint: hint,
      child: InkWell(
        excludeFromSemantics: true,
        onTap: (){
          /*if(count == 0)
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return _badgesDialog(context, image, name+' Physical Activity Badge');
              });*/
        },
        child: Container(
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
                if(count > 0)...[
                  badges.Badge(
                    badgeContent: Text(count.toString(),
                      style: TextStyle(color: Colors.white),),
                    position: badges.BadgePosition.topEnd(top: -5, end: 2),
                    child:Opacity(
                      opacity: opacity,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        width: 68,
                        height: 68,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),),
                ],
                if(count == 0)...[
                  Opacity(
                    opacity: opacity,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      width: 68,
                      height: 68,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ],
                /*Image.asset(image,
                  opacity: AlwaysStoppedAnimation(opacity),
                  height: 68,
                  width: 68,
                ),*/
                SizedBox(height: 4,),
                /*Text('Physical Activity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: textColor,
                      fontWeight: FontWeight.w500),
                ),*/
              ],
            ),
          ),
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
    int count = 0;

    if(index == 0){
      name = '7 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/f053bf04-e65d-47cc-bf38-33d88f112f58/download-by-version-name/1";
    }else if(index == 1){
      name = '15 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/115d6b2b-b8ca-43da-801e-622e05074986/download-by-version-name/1";
    }else if(index == 2){
      name = '30 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/f552ba2e-e561-4683-a97b-38f95aada8fe/download-by-version-name/1";
    }


    for ( int i = 0 ; i < mentalHealthAwardsList.length ; i++ ) {

      if(mentalHealthAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else{
        name = '7 days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(mentalHealthAwardsList[i].badge!.name!.contains('15-Day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else {
        name = '15 days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(mentalHealthAwardsList[i].badge!.name!.contains('30-Day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else {
        name = '30 days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

    }


    String lable = 'Earned '+count.toString()+' Mental Well-Being badges for '+ name +' ';
    String hint = '';

    if(count > 0){
    } else {
      hint = 'Double click to explore how to earn this badge.';
    }

    return Semantics(
      label: lable,
      hint: hint,
      child: InkWell(
        excludeFromSemantics: true,
        onTap: (){
         /* if(count == 0)
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return _badgesDialog(context, image, name+' Mental Well-Being Badge');
              });*/
        },
        child: Container(
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
                if(count > 0)...[
                  badges.Badge(
                    badgeContent: Text(count.toString(),
                      style: TextStyle(color: Colors.white),),
                    position: badges.BadgePosition.topEnd(top: -5, end: 2),
                    child:Opacity(
                      opacity: opacity,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        width: 68,
                        height: 68,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),),
                ],
                if(count == 0)...[
                  Opacity(
                    opacity: opacity,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      width: 68,
                      height: 68,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ],
                /*Image.asset(image,
                  opacity: AlwaysStoppedAnimation(opacity),
                  height: 68,
                  width: 68,
                ),*/
                SizedBox(height: 4,),
                /*Text('Mental Well-Being',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: textColor,
                      fontWeight: FontWeight.w500),
                ),*/
              ],
            ),
          ),
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
    int count = 0;

    if(index == 0){
      name = '7 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/e1ffbeb4-703b-445d-97ae-60e93bb75eef/download-by-version-name/1";
    }else if(index == 1){
      name = '15 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/43972de1-4e8d-4685-9161-5c9667042a14/download-by-version-name/1";
    }else if(index == 2){
      name = '30 days';
      image = "https://awards-dev.services.reanfoundation.org/api/v1/file-resources/ef576415-2c20-47cf-84e9-e7997a8fb0c6/download-by-version-name/1";
    }


    for ( int i = 0 ; i < vitalsAwardsList.length ; i++ ) {

      if(vitalsAwardsList[i].badge!.name!.contains('7-Day') && index == 0){
        //Data data = awardsList.elementAt(index);
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else{
        name = '7 days';
        image = 'res/images/awards/ic_bronze_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(vitalsAwardsList[i].badge!.name!.contains('15-Day') && index == 1){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else {
        name = '15 days';
        image = 'res/images/awards/ic_silver_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

      if(vitalsAwardsList[i].badge!.name!.contains('30-Day') && index == 2){
        opacity = 1.0;
        textColor = Colors.black;
        count++;
      }/*else {
        name = '30 days';
        image = 'res/images/awards/ic_gold_medicatio_medal.png';
        opacity = 0.2;
        textColor = Colors.grey;
      }*/

    }

    String lable = 'Earned '+count.toString()+' vitals badges for '+ name +' ';
    String hint = '';

    if(count > 0){
    } else {
      hint = 'Double click to explore how to earn this badge.';
    }


    return Semantics(
      label: lable,
      hint: hint,
      child: InkWell(
        excludeFromSemantics: true,
        onTap: (){
          /*if(count == 0)
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return _badgesDialog(context, image, name+' Vital Badge');
              });*/
        },
        child: Container(
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
                if(count > 0)...[
                  badges.Badge(
                    badgeContent: Text(count.toString(),
                      style: TextStyle(color: Colors.white),),
                    position: badges.BadgePosition.topEnd(top: -5, end: 2),
                    child:Opacity(
                      opacity: opacity,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        width: 68,
                        height: 68,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),),
                ],
                if(count == 0)...[
                  Opacity(
                    opacity: opacity,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      width: 68,
                      height: 68,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ],
                /*Image.asset(image,
                  opacity: AlwaysStoppedAnimation(opacity),
                  height: 68,
                  width: 68,
                ),*/
                SizedBox(height: 4,),
                /*Text('Vitals',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: textColor,
                      fontWeight: FontWeight.w500),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*Widget _badgesDialog(BuildContext context, String images, String tittle) {
    return Dialog(
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: double.infinity,
          height: 400,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        tittle,
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    icon: Icon(
                      Icons.close,
                      color: primaryColor,
                    ),
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: BadgesDetailsDialog(image: images,),
              )
            ],
          ),
        ));
  }*/

}