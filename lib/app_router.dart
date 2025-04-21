import 'package:ai_radiologist_flutter/business_logic/cubit/cubits.dart';
import 'package:ai_radiologist_flutter/business_logic/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:ai_radiologist_flutter/presentation/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppRouter {
  late AuthCubit authCubit;
  late ReportCubit reportCubit;
  AppRouter(){
    authCubit = AuthCubit(AuthRepository());
    reportCubit = ReportCubit(ReportRepository());
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
            // builder: (context) => HomeScreen());
          builder: (_) => BlocProvider<ReportCubit>.value(
            value: reportCubit,
            child: HomeScreen(),
          ),
        );

      case '/report_detail':
      // تأكد من تمرير reportId من خلال arguments.
        final reportId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => BlocProvider<ReportCubit>.value(
            value: reportCubit,
            child: ReportDetailScreen(reportId: reportId),
          ),
        );



    }
  }
}