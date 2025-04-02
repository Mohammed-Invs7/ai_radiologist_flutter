import 'package:ai_radiologist_flutter/data/datasources/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد AnimationController لتأثير Fade In
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    // بعد انتهاء التأثير، نتحقق من التوكن ونوجه المستخدم
    Future.delayed(const Duration(seconds: 4), () async {
      final token = await AuthStorage.getAccessToken();
      if (token != null) {
        // توجيه المستخدم إلى الصفحة الرئيسية إذا كان التوكن موجودًا
        Navigator.pushReplacementNamed(context, '/home_screen');
      } else {
        // توجيه المستخدم إلى شاشة تسجيل الدخول إذا لم يكن التوكن موجودًا
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.whiteColor,
        appBar: AppBar(
          backgroundColor: MyColors.mainColor,
          toolbarHeight: 0, // إخفاء شريط التطبيق العلوي
        ),
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 112,
                  backgroundColor: MyColors.mainColor,
                  child: const CircleAvatar(
                    radius: 110,
                    backgroundColor: MyColors.whiteColor,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                ),
                Text(
                  "Ai Radiologist",
                  style: TextStyle(
                      fontSize: 30,
                      color: MyColors.mainColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: "sans-serif"),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        )
    );
  }
}