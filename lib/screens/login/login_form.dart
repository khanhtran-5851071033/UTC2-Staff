import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:utc2_staff/blocs/login_bloc/login_bloc.dart';
import 'package:utc2_staff/screens/home_screen.dart';
import 'package:utc2_staff/screens/login/enter_student_id_screen.dart';
import 'package:utc2_staff/utils/utils.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginBloc loginBloc;
  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is SigningState)
          showSnackBar(context, 'Đang đăng nhập...', true);
        else if (state is SignInErrorState)
          showSnackBar(context, 'Đăng nhập thất bại', false);
        else if (state is SignedInState) {
          state.isRegister
              ? Get.offAll(() => HomeScreen())
              : Get.to(() => EnterSIDScreen(
                    ggLogin: state.ggLogin,
                  ));
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 50),
        width: size.width * 0.9,
        child: RawMaterialButton(
          padding: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          fillColor: ColorApp.black,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
                // margin: EdgeInsets.only(right: 10),
                width: 30,
                child: Image.asset('assets/icons/google.png')),
            Text(
              'Đăng nhập bằng tài khoản Giảng Viên',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ]),
          onPressed: () async {
            print('Đăng nhập.....');
            loginBloc.add(SignInEvent());
          },
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String text, bool show) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              show
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Container(
                      height: 5,
                    )
            ],
          ),
          backgroundColor: Colors.blue,
        ),
      );
  }

  void removeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}
