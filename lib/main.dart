import 'package:ai_radiologist_flutter/business_logic/cubit/auth_cubit.dart';
import 'package:ai_radiologist_flutter/business_logic/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_router.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(AuthRepository()),
      child: AiRadiologistApp(appRouter: AppRouter()),
    ),
  );
}

class AiRadiologistApp extends StatelessWidget {
  const AiRadiologistApp({super.key, required this.appRouter});

  final AppRouter appRouter;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
      if (state is AuthUnauthenticated) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    },
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      onGenerateRoute: appRouter.generateRoute,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      )
    );
  }
}

