import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  static const Color primaryColorLocal = Color(0XFF6541A5);

  Future<void> _initPackageInfo() async {
    if (getCurrentLocale() == '') {
      final Locale countryLocale = await Devicelocale.currentAsLocale;
      setCurrentLocale(countryLocale.countryCode.toUpperCase());
      debugPrint(
          'Country Local ==> ${countryLocale.countryCode.toUpperCase()}');
    }
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  void _onIntroEnd(context) {
    Navigator.popAndPushNamed(context, RoutePaths.Login);
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('res/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: primaryColorLocal);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
          color: primaryColorLocal),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: colorF6F6FF,
      /*globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('flutter.png', 100),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),*/
      pages: [
        PageViewModel(
          title: 'Medications',
          body: 'Include medication reminders in your daily tasks.',
          image: _buildImage('walkthrough_img_1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Vitals',
          body: 'Keep a close watch on your vitals.',
          image: _buildImage('walkthrough_img_2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Medical Records',
          body: 'Have all your documents safe in one place.',
          image: _buildImage('walkthrough_img_3.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text(
        'Skip',
        style: TextStyle(color: primaryColorLocal),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: primaryColorLocal,
      ),
      done: const Text('Done',
          style:
          TextStyle(fontWeight: FontWeight.w600, color: primaryColorLocal)),
      curve: Curves.fastLinearToSlowEaseIn,
      //controlsMargin: const EdgeInsets.all(16),
      /*controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),*/
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeColor: primaryColorLocal,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      /*dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),*/
    );
  }
}
