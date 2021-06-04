import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:utc2_staff/blocs/login_bloc/login_bloc.dart';
import 'package:utc2_staff/repositories/google_signin_repo.dart';
import 'package:utc2_staff/screens/home_screen.dart';
import 'package:utc2_staff/utils/utils.dart';

class EnterSIDScreen extends StatefulWidget {
  final GoogleSignInAccount ggLogin;

  EnterSIDScreen({Key key, this.ggLogin}) : super(key: key);

  @override
  _EnterSIDScreenState createState() => _EnterSIDScreenState();
}

class _EnterSIDScreenState extends State<EnterSIDScreen> {
  GoogleSignInRepository ggSignIn = GoogleSignInRepository();
  TextEditingController sIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LoginBloc loginBloc;
  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
            ggSignIn.signOut();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              '    Vì bạn đang sử dụng tài khoản cá nhân để đăng nhập ngoài phạm vi truy cập của UTC2.',
              style: TextStyle(fontSize: 17, color: ColorApp.black),
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              '    Vui lòng nhập mã giảng viên để xác nhận !',
              style: TextStyle(fontSize: 17, color: ColorApp.black),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: sIdController,
                validator: (val) =>
                    val.isEmpty ? 'Vui lòng nhập mã giảng viên' : null,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Nhập mã Giảng Viên',
                  hintStyle: TextStyle(
                      color: ColorApp.black.withOpacity(.5),
                      fontWeight: FontWeight.normal,
                      fontSize: 15),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 1.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Colors.blue, width: 1.3),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Colors.red, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Colors.red, width: 1.5),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is EnteredSIDState) {
                  Get.offAll(() => HomeScreen());
                }
              },
              builder: (context, state) {
                if (state is UpdatingSIDState)
                  return SpinKitThreeBounce(
                    color: ColorApp.lightBlue,
                    size: 30,
                  );
                else
                  return Container();
              },
            ),
            Spacer(),
            buttonSubmit(),
          ],
        ),
      ),
    );
  }

  Widget buttonSubmit() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              color: Colors.blue,
              onPressed: () {
                if (_formKey.currentState.validate())
                  loginBloc.add(
                      EnterSIDEvent(widget.ggLogin, sIdController.text.trim()));
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}
