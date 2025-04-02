import 'package:ai_radiologist_flutter/business_logic/cubit/report_cubit.dart';
import 'package:ai_radiologist_flutter/business_logic/repositories/report_repository.dart';
import 'package:ai_radiologist_flutter/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';
import 'package:ai_radiologist_flutter/business_logic/cubit/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  late Widget _currentScreen;

  // قائمة الشاشات للتنقل (لا يوجد شاشة خاصة للـ Logout، فالزر يقوم بتسجيل الخروج)
  final List<Widget> _screens = [
    const HomeContentScreen(),
    const SearchScreen(),
    BlocProvider(
      create: (context) => ReportCubit(ReportRepository()),
      child: const CreateReportScreen(),
    ),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentScreen = _screens[_selectedIndex];
  }

  void _onItemTapped(int index) {
    // إذا ضغط المستخدم على العنصر الأخير (Logout) وهو مؤشر 4
    if (index == 4) {
      context.read<AuthCubit>().logout();
      // التنقل إلى صفحة تسجيل الدخول يتم من خلال Global BlocListener
    } else {
      setState(() {
        _selectedIndex = index;
        _currentScreen = _screens[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: AppBar(
        backgroundColor: MyColors.mainColor,
        toolbarHeight: 0, // إخفاء شريط التطبيق العلوي
      ),
      body: _currentScreen,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: MyColors.mainColor,
              width: 0.7, // يمكنك تعديل السماكة حسب الحاجة
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: MyColors.secondColor,
          currentIndex: _selectedIndex,
          selectedItemColor: MyColors.mainColor,
          unselectedItemColor:  MyColors.mainColor,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: MyColors.mainColor),
              activeIcon: Icon(Icons.home, color: MyColors.mainColor),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined, color: MyColors.mainColor),
              activeIcon: Icon(Icons.search, color: MyColors.mainColor),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, color: MyColors.mainColor),
              activeIcon: Icon(Icons.add_circle, color: MyColors.mainColor),
              label: 'Create Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, color: MyColors.mainColor),
              activeIcon: Icon(Icons.person, color: MyColors.mainColor),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout, color: MyColors.mainColor),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}

// شاشة Home الأساسية
class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Screen',
        style: TextStyle(fontSize: 24, color: MyColors.mainColor),
      ),
    );
  }
}

// شاشة البحث
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Search Screen',
        style: TextStyle(fontSize: 24, color: MyColors.mainColor),
      ),
    );
  }
}

// شاشة إنشاء تقرير
// class CreateReportScreen extends StatelessWidget {
//   const CreateReportScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Create Report Screen',
//         style: TextStyle(fontSize: 24, color: MyColors.mainColor),
//       ),
//     );
//   }
// }

// شاشة الملف الشخصي
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Screen',
        style: TextStyle(fontSize: 24, color: MyColors.mainColor),
      ),
    );
  }
}
