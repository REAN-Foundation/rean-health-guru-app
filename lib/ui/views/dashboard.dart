import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/ui/views/base_widget.dart';

class DashBoardView extends StatefulWidget {
  @override
  _DashBoardViewState createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  var model = BookAppoinmentViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List quotes = <String>[];

  @override
  void initState() {
    super.initState();
    quotes.add(
        'It is health that is the real wealth, and not pieces of gold and silver.\n- Mahatma Gandhi');
    quotes.add(
        'Physical fitness is the first requisite of happiness.\n– Joseph Pilates');
    quotes.add('Happiness is the highest form of health.\n- Dalai Lama');
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<BookAppoinmentViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _addCrousal(),
                //SizedBox(height: 16,),
                //reportWidgets(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Search Near Me',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ),
                //_buildTabDesign(),
                doctorWidget(),
                SizedBox(
                  height: 8,
                ),
                labWidget(),
                SizedBox(
                  height: 8,
                ),
                pharmacyWidget(),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: nurseWidget(),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: ambulanceWidget(),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//bg_gray_hexa.png
  Widget _addCrousal() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 100.0,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 8),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: [1, 2, 3].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('res/images/bg_gray_hexa.jpg'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: primaryLightColor, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    quotes.elementAt(i - 1),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget reportWidgets() {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: myReportWidget(),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: myPrescriptionsWidget(),
            )
          ],
        ));
  }

  Widget myReportWidget() {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.My_Reports,
              arguments: 'Reports');
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ImageIcon(
                      AssetImage('res/images/ic_my_reports.png'),
                      size: 24,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      'My Reports',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: primaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )),
        ));
  }

  Widget myPrescriptionsWidget() {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.My_Reports,
              arguments: 'Prescriptions');
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ImageIcon(
                      AssetImage('res/images/ic_pharmacy_report.png'),
                      size: 24,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      'My Prescriptions',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: primaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )),
        ));
  }

  Widget doctorWidget() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.Doctor_Appoinment);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primaryLightColor, colorF6F6FF]),
              border: Border.all(color: primaryLightColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ImageIcon(
                      AssetImage('res/images/ic_doctor_colored.png'),
                      size: 48,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Doctor',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: primaryColor),
                        ),
                        //SizedBox(height: 4,),
                        Text(
                          'Cardiologists, Dermatologists, Neurologists Obstetricians and Gynecologists',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Montserrat',
                              color: primaryColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget labWidget() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.Lab_Appoinment);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primaryLightColor, colorF6F6FF]),
              border: Border.all(color: primaryLightColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ImageIcon(
                      AssetImage('res/images/ic_lab_colored.png'),
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lab',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: primaryColor),
                        ),
                        //SizedBox(height: 4,),
                        Text(
                          'Lipid Panel, Blood Count, Basic Metabolic Panel, Haemoglobin A1C, many more…',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Montserrat',
                              color: primaryColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget pharmacyWidget() {
    return InkWell(
      onTap: () {
        //Navigator.pushNamed(context, RoutePaths.Doctor_Appoinment);
        showToast('Coming Soon...', context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primaryLightColor, colorF6F6FF]),
              border: Border.all(color: primaryLightColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ImageIcon(
                      AssetImage('res/images/ic_pharmacy_colored.png'),
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pharmacy',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: primaryColor),
                        ),
                        //SizedBox(height: 4,),
                        Text(
                          'Order Medicine, Syrup, Injections',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Montserrat',
                              color: primaryColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget nurseWidget() {
    return InkWell(
      onTap: () {
        //Navigator.pushNamed(context, RoutePaths.Doctor_Appoinment);
        showToast('Coming Soon...', context);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
        ),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primaryLightColor, colorF6F6FF]),
              border: Border.all(color: primaryLightColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      ImageIcon(
                        AssetImage('res/images/ic_nurse.png'),
                        size: 40,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Nurse',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: primaryColor),
                            ),
                            //SizedBox(height: 4,),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 16.0),
                    child: Text(
                      'Need home nursing services? Hire nurse',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Montserrat',
                          color: primaryColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget ambulanceWidget() {
    return InkWell(
      onTap: () {
        //Navigator.pushNamed(context, RoutePaths.Word_Of_The_Week_Care_Plan);
        showToast('Coming Soon...', context);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16.0,
        ),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primaryLightColor, colorF6F6FF]),
              border: Border.all(color: primaryLightColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      ImageIcon(
                        AssetImage('res/images/ic_ambulance.png'),
                        size: 40,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ambulance',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: primaryColor),
                            ),
                            //SizedBox(height: 4,),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 16.0),
                    child: Text(
                      'Emergency???\nCall an ambulance',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Montserrat',
                          color: primaryColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

}
