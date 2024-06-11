import 'package:evital_flutter/cubit/splash/splash_cubit.dart';
import 'package:evital_flutter/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  // final api = Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: Scaffold(
        body: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            // TODO: implement listener
            if(state is SplashProcess){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginForm(),), (route) => false);
            }
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/lotties/splashlottie.json"),
                const Text(
                  "ToDo Task",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
