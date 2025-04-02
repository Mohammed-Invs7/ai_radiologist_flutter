// lib/presentation/screens/login_screen.dart
import 'package:ai_radiologist_flutter/business_logic/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variables to manage password visibility
  bool inVisiblePass = true;
  Icon eyeIcon = const Icon(Icons.visibility_off, color: Color.fromRGBO(64, 164, 150, 1.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: AppBar(
        backgroundColor: MyColors.mainColor,
        toolbarHeight: 0, // Hide the app bar toolbar
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            // Display error message when login fails
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthSuccess) {
            // Display success message (or navigate to another screen)
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Login success! Welcome, ${state.user.firstName}")));
            Navigator.pushReplacementNamed(context, '/home_screen');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Display login form when state is initial or error
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                          fontSize: 30,
                          color: MyColors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: "sans-serif"),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      color: MyColors.mainColor,
                      height: 1,
                      margin: const EdgeInsets.only(top: 10, bottom: 5, left: 50, right: 50),
                    ),
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 112,
                      backgroundColor: MyColors.mainColor,
                      child: const CircleAvatar(
                        radius: 110,
                        backgroundColor: MyColors.whiteColor,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "الإيميل",
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: MyColors.mainColor,
                        ),
                        hintText: "أدخل الإيميل",
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: MyColors.mainColor,
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: MyColors.mainColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: MyColors.mainColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: MyColors.thirdColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: inVisiblePass,
                      decoration: InputDecoration(
                        labelText: "كلمة المرور",
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: MyColors.mainColor,
                        ),
                        hintText: "أدخل كلمة المرور",
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: MyColors.mainColor,
                        ),
                        prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              inVisiblePass = !inVisiblePass;
                              eyeIcon = inVisiblePass
                                  ?  Icon(Icons.visibility_off, color: MyColors.mainColor)
                                  : const Icon(Icons.visibility, color: MyColors.thirdColor);
                            });
                          },
                          icon: eyeIcon,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: MyColors.mainColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: MyColors.thirdColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Call the login function in AuthCubit with the provided email and password
                        context.read<AuthCubit>().login(
                          emailController.text,
                          passwordController.text,
                        );
                      },
                      child: const Text(
                        "تسجيل الدخول",
                        style: TextStyle(fontSize: 20, color: MyColors.whiteColor),
                      ),
                    ),

                    const SizedBox(height: 10), // مسافة بين الزر والنص

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup_screen'); // الانتقال إلى صفحة التسجيل
                      },
                      child: Text(
                        "لا تملك حساب؟ سجل معنا",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.mainColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline, // لإضافة خط تحت النص
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
