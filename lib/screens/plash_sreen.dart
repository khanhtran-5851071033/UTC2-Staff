import 'package:flutter/material.dart';
import 'package:utc2_staff/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/images/plash.jpg',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                stops: [
                  0.11,
                  0.4,
                  0.6,
                  .9,
                ],
                colors: [
                  Colors.white.withOpacity(.99),
                  Colors.white10..withOpacity(.1),
                  Colors.white12.withOpacity(.1),
                  Colors.white.withOpacity(.1),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp,
              )),
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  Text(
                    'Trường đại học giao thông vận tải\nphân hiệu tại TP.Hồ Chí Minh',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorApp.black, fontSize: size.width * 0.05),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/logoUTC.png",
                        height: size.width * 0.28,
                        width: size.width * 0.28,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    "assets/images/path@2x.png",
                    width: size.width,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
