import 'package:ai_radiologist_flutter/business_logic/cubit/cubits.dart';
import 'package:ai_radiologist_flutter/business_logic/cubit/report_cubit.dart';
import 'package:ai_radiologist_flutter/business_logic/repositories/repositories.dart';
import 'package:ai_radiologist_flutter/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';
import 'package:ai_radiologist_flutter/business_logic/cubit/auth_cubit.dart';


// final reportCubit = ReportCubit(ReportRepository());

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
    BlocProvider<ProfileCubit>.value(
      value: ProfileCubit(UserRepository()),
      child: const ProfileScreen(),
    ),
    const ReportsScreen(),
    const CreateReportScreen(),
    // BlocProvider<ReportCubit>.value(
    //   value: reportCubit,
    //   child: const ReportsScreen(),
    // ),
    // BlocProvider<ReportCubit>.value(
    //   value: reportCubit,
    //   child: const CreateReportScreen(),
    // ),
    const HomeContentScreen(),
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
        height: 80,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: MyColors.mainColor,
              width: 1.4, // يمكنك تعديل السماكة حسب الحاجة
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
              icon: Icon(Icons.person_outline, color: MyColors.mainColor),
              activeIcon: Icon(Icons.person, color: MyColors.mainColor),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined, color: MyColors.mainColor),
              activeIcon: Icon(Icons.article, color: MyColors.mainColor),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, color: MyColors.mainColor),
              activeIcon: Icon(Icons.add_circle, color: MyColors.mainColor),
              label: 'Create Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, color: MyColors.mainColor),
              activeIcon: Icon(Icons.settings, color: MyColors.mainColor),
              label: 'settings',
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, color: MyColors.mainColor,size: 70,),
          Text(
            'Coming soon...',
            style: TextStyle(fontSize: 24, color: MyColors.mainColor),
          ),
        ],
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
class ProfileScreen1 extends StatelessWidget {
  const ProfileScreen1({Key? key}) : super(key: key);

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
