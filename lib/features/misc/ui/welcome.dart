import 'package:flutter/material.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("res/images/bg_doodle.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 3, child: Container()),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getAppType() == 'AHA'
                      ? Image.asset(
                          'res/images/aha_logo.png',
                          semanticLabel: 'American Heart Association Logo',
                          height: 160,
                        )
                      : Image.asset(
                          'res/images/app_logo_transparent.png',
                          semanticLabel: 'REAN HealthGuru',
                          color: primaryColor,
                          height: 160,
                        ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Welcome to",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff000000),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(getAppName(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff000000),
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                      "LH supports individuals to better manage \nyour health by providing education, healthy \nhabits, tracking your symptoms and \nmedications, and sharing health \ninformation with your doctor - \nall in one place.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff636466),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: 180,
                    height: 48,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return HomeView(0);
                          }), (Route<dynamic> route) => false);
                        },
                        child: Text(
                          "I’m’ in",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
