import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  String phoneNumber = "9033006262";
  String password = "eVital@12";

  void login(String enteredMobile, String enteredPassword) {
    if (enteredMobile == phoneNumber && enteredPassword == password) {
      emit(LoginSuccess());
    } else {
      emit(LoginError(error: "Invalid mobile or password"));
    }
  }
}
