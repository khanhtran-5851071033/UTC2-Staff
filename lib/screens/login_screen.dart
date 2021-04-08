import 'package:UTC2_Staff/screens/home_screen.dart';

import 'package:UTC2_Staff/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPass = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _validateEmail = false;
  bool _validatePass = false;
  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: [0.2, 0.9],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, ColorApp.lightGrey])),
          child: Stack(
            // alignment: Alignment.topCenter,
            // overflow: Overflow.clip,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(top: 10),
                        height: size.height * 0.32,
                        width: size.width,
                        child: CustomPaint(
                          painter: CurvePainter1(),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        height: size.height * 0.32,
                        width: size.width,
                        child: CustomPaint(
                          painter: CurvePainter(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                              color: ColorApp.black,
                              fontSize: size.width * 0.04),
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_rounded),
                              border: UnderlineInputBorder(),
                              hintText: 'email@utc2.edu.vn',
                              errorText: (!isValidEmail(emailController.text) &&
                                      emailController.text.isNotEmpty)
                                  ? 'Email chưa đúng'
                                  : _validateEmail
                                      ? 'Vui lòng nhập Email'
                                      : null),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Text(
                          'Mật Khẩu',
                          style: TextStyle(
                              color: ColorApp.black,
                              fontSize: size.width * 0.04),
                        ),
                        TextFormField(
                          controller: passController,
                          obscureText: isPass,
                          obscuringCharacter: '.',
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isPass ? isPass = false : isPass = true;
                                    });
                                  },
                                  child: Icon(
                                      isPass
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 18)),
                              prefixIcon: Icon(Icons.lock_rounded),
                              border: UnderlineInputBorder(),
                              errorText: _validatePass
                                  ? 'Vui lòng nhập mật khẩu'
                                  : null,
                              hintText: '............'),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Center(
                          child: ElevatedButton(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.2, vertical: 10),
                                child: Text("Đăng nhập",
                                    style: TextStyle(
                                        fontSize: size.width * 0.045,
                                        letterSpacing: 1,
                                        wordSpacing: 1,
                                        fontWeight: FontWeight.normal)),
                              ),
                              style: ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorApp.blue),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side:
                                              BorderSide(color: Colors.red)))),
                              onPressed: () {
                                setState(() {
                                  emailController.text.isEmpty
                                      ? _validateEmail = true
                                      : _validateEmail = false;
                                  passController.text.isEmpty
                                      ? _validatePass = true
                                      : _validatePass = false;
                                });
                                if (isValidEmail(emailController.text) &&
                                    !_validateEmail &&
                                    !_validatePass) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                } else {}
                              }),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Developed by KhanhTran',
                    style: TextStyle(
                      color: ColorApp.black,
                    ),
                  )
                ],
              ),
              Positioned(
                top: 50,
                child: Container(
                  width: size.width,
                  child: Column(
                    children: [
                      Text(
                        'Trường đại học giao thông vận tải\nphân hiệu tại TP.Hồ Chí Minh',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorApp.black, fontSize: size.width * 0.05),
                      ),
                      SizedBox(
                        height: 7,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.9);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.98, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorApp.lightGrey;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.86);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.86);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
