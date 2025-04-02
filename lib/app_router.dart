import 'package:ai_radiologist_flutter/business_logic/cubit/auth_cubit.dart';
import 'package:ai_radiologist_flutter/business_logic/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:ai_radiologist_flutter/presentation/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/settings.dart';


class AppRouter {
  late AuthCubit authCubit;
  AppRouter(){
    authCubit = AuthCubit(AuthRepository());
  }

   Route? generateRoute(RouteSettings settings ) {
    switch(settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => SplashScreen());
        //   builder: (_) => BlocProvider<AuthCubit>.value(
        //     value: authCubit,
        //     child: LoginScreen(),
        //   ),
        //  );
      case '/login':
        return MaterialPageRoute(
            builder: (context) => LoginScreen());

      case '/signup_screen':
        return MaterialPageRoute(
          builder: (context) => SignupScreen());
        //   builder: (_) => BlocProvider<AuthCubit>.value(
        //     value: authCubit,
        //     child: SignupScreen(),
        //   ),
        // );

      case '/home_screen':
        return MaterialPageRoute(
            builder: (context) => HomeScreen());
        //   builder: (_) => BlocProvider<AuthCubit>.value(
        //     value: authCubit,
        //     child: HomeScreen(),
        //   ),
        // );




    }
  }
}