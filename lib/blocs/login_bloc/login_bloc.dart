import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_staff/repositories/google_signin_repo.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  final studentDB = StudentDatabase();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    switch (event.runtimeType) {
      case SignInEvent:
        GoogleSignInRepository _googleSignIn = GoogleSignInRepository();
        yield SigningState();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var login = await _googleSignIn.signIn();

        if (login != null) {
          int len = login.email.length - 14;
          if (login.email.substring(len) == 'st.utc2.edu.vn') {
            print(login.email.substring(len) == 'st.utc2.edu.vn');

            Map<String, String> dataStudent = {
              'id': login.email.substring(0, len - 1),
              'name': login.displayName,
              'email': login.email,
              'avatar': login.photoUrl,
              'token': prefs.getString('token'),
            };
            try {
              await studentDB.createStudent(
                  dataStudent, login.email.substring(0, len - 1));
            } catch (e) {
              print('Lỗi =====>' + e.toString());
            }
          }
          prefs.setString('userEmail', login.email);
          bool isRegister = await StudentDatabase.isRegister(login.email);
          if (isRegister) {
            print('update');
            var student = await StudentDatabase.getStudentData(login.email);

            Map<String, String> data = {
              'id': student.id,
              'name': login.displayName,
              'email': login.email,
              'avatar': login.photoUrl,
              'token': prefs.getString('token'),
            };
            StudentDatabase.updateStudentData(student.id, data);
          }
          yield SignedInState(login, isRegister);
        } else
          yield SignInErrorState();

        break;
      case EnterSIDEvent:
        yield UpdatingSIDState();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        GoogleSignInAccount ggLogin = event.props[0];
        Map<String, String> dataStudent = {
          'id': event.props[1],
          'name': ggLogin.displayName,
          'email': ggLogin.email,
          'avatar': ggLogin.photoUrl,
          'token': prefs.getString('token'),
        };
        try {
          await studentDB.createStudent(dataStudent, event.props[1]);
        } catch (e) {
          print('Lỗi =====>' + e.toString());
        }

        prefs.setString('userEmail', ggLogin.email);
        yield EnteredSIDState();
        break;
      default:
    }
  }
}
