// lib/presentation/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_radiologist_flutter/business_logic/cubit/auth_cubit.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';
import 'package:ai_radiologist_flutter/data/models/models.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String gender = 'M';
  DateTime selectedDateOfBirth = DateTime.now();
  bool inVisiblePass = true;


  // Function to open date picker for selecting date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.whiteColor,      // لون الخلفية للـ AppBar الخاص بالـ DatePicker
              onPrimary: MyColors.mainColor,     // لون نص العنوان في الـ AppBar
              onSurface: MyColors.mainColor,      // لون النص العام داخل الـ DatePicker
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: MyColors.secondColor,      // لون نص الأزرار داخل الـ DatePicker
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDateOfBirth) {
      setState(() {
        selectedDateOfBirth = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: AppBar(
        backgroundColor: MyColors.mainColor,
        title: const Text("إنشاء حساب"),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)));
          } else if (state is AuthRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$state.message :تم التسجيل بنجاح!:")));
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First Name field
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: "الاسم الأول",
                      labelStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      hintText: "أدخل الاسم الأول",
                      hintStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      prefixIcon: Icon(Icons.person, color: MyColors.mainColor),
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
                  // Last Name field
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: "الاسم الأخير",
                      labelStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      hintText: "أدخل الاسم الأخير",
                      hintStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      prefixIcon: Icon(Icons.person_outline, color: MyColors.mainColor),
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
                  // Email field
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "الإيميل",
                      labelStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      hintText: "أدخل الإيميل",
                      hintStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      prefixIcon: Icon(Icons.email, color: MyColors.mainColor),
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
                  // Password field
                  TextField(
                    controller: passwordController,
                    obscureText: inVisiblePass,
                    decoration: InputDecoration(
                      labelText: "كلمة المرور",
                      labelStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      hintText: "أدخل كلمة المرور",
                      hintStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      prefixIcon: IconButton(
                        icon: Icon(inVisiblePass ? Icons.visibility_off : Icons.visibility, color: MyColors.mainColor),
                        onPressed: () {
                          setState(() {
                            inVisiblePass = !inVisiblePass;
                          });
                        },
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
                  // Confirm Password field
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "تأكيد كلمة المرور",
                      labelStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      hintText: "أدخل تأكيد كلمة المرور",
                      hintStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      prefixIcon: Icon(Icons.lock_outline, color: MyColors.mainColor),
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

                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: InputDecoration(
                      labelText: "الجنس",
                      labelStyle: TextStyle(fontSize: 20, color: MyColors.mainColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: MyColors.mainColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: MyColors.thirdColor, width: 2),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: "M", child: Text("ذكر")),
                      DropdownMenuItem(value: "F", child: Text("أنثى")),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue!;
                      });
                    },
                  ),

                  const SizedBox(height: 10),
                  // Date of Birth field
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.mainColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'تاريخ الميلاد: ${selectedDateOfBirth.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(fontSize: 20, color: MyColors.mainColor),
                          ),
                          Icon(Icons.calendar_today, color: MyColors.mainColor),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Sign Up button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // تجهيز بيانات التسجيل
                      final userRegister = UserRegister(
                        email: emailController.text,
                        password: passwordController.text,
                        passwordConfirm: confirmPasswordController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        gender: gender,
                        dateOfBirth: selectedDateOfBirth.toLocal().toString().split(' ')[0],
                      );
                      context.read<AuthCubit>().signup(userRegister);
                    },
                    child: const Text(
                      "تسجيل",
                      style: TextStyle(fontSize: 20, color: MyColors.whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
