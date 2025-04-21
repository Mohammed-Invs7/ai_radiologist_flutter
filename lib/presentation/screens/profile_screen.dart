import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';
import 'package:ai_radiologist_flutter/business_logic/cubit/profile_cubit.dart';
import 'package:intl/intl.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserProfile();
  }

  void _showEditDialog({
    required String title,
    required Widget content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title, style: TextStyle(color: MyColors.mainColor)),
          content: content,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel', style: TextStyle(color: MyColors.mainColor)),
            ),
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.of(dialogContext).pop();
              },
              child: Text('Confirm', style: TextStyle(color: MyColors.mainColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: MyColors.whiteColor)),
        backgroundColor: MyColors.mainColor,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.user;
            // تجاهل user_type
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // صورة الملف الشخصي في الأعلى
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(user.profileImage),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // عرض معلومات المستخدم بشكل أنيق
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: MyColors.mainColor, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${user.firstName} ${user.lastName}',
                            style: TextStyle(
                              fontSize: 18,
                              color: MyColors.mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Email: ${user.email}',
                            style: TextStyle(
                              fontSize: 16,
                              color: MyColors.mainColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Age: ${user.age}',
                            style: TextStyle(
                              fontSize: 16,
                              color: MyColors.mainColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date of Birth: ${user.dateOfBirth}',
                            style: TextStyle(
                              fontSize: 14,
                              color: MyColors.mainColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gender: ${user.gender}',
                            style: TextStyle(
                              fontSize: 16,
                              color: MyColors.mainColor,
                            ),
                          ),
                          // const SizedBox(height: 8),
                          // Text(
                          //   'Join Date: ${DateFormat('yyyy-MM-dd').format(user.joinDate)}',
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: MyColors.mainColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // مجموعة بطاقات الخيارات للتعديل
                  // 1. تعديل الاسم
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: MyColors.mainColor, width: 1),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.person, color: MyColors.mainColor),
                      title: const Text('Edit Name'),
                      onTap: () {
                        final firstNameController = TextEditingController(text: user.firstName);
                        final lastNameController = TextEditingController(text: user.lastName);
                        _showEditDialog(
                          title: 'Edit Name',
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: firstNameController,
                                decoration: InputDecoration(labelText: 'First Name'),
                              ),
                              TextField(
                                controller: lastNameController,
                                decoration: InputDecoration(labelText: 'Last Name'),
                              ),
                            ],
                          ),
                          onConfirm: () {
                            context.read<ProfileCubit>().updateUserName(
                              firstNameController.text,
                              lastNameController.text,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 2. تعديل الجنس
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: MyColors.mainColor, width: 1),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.transgender_outlined, color: MyColors.mainColor),
                      title: const Text('Edit Gender'),
                      onTap: () {
                        // عرض Dialog لتحديد الجنس
                        _showEditDialog(
                          title: 'Edit Gender',
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile<String>(
                                title: const Text('Male'),
                                value: 'M',
                                groupValue: user.gender,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<ProfileCubit>().updateUserGender(value);
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                              RadioListTile<String>(
                                title: const Text('Female'),
                                value: 'F',
                                groupValue: user.gender,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<ProfileCubit>().updateUserGender(value);
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ],
                          ),
                          onConfirm: () {},
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 3. تعديل صورة الملف الشخصي
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: MyColors.mainColor, width: 1),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.image_outlined, color: MyColors.mainColor),
                      title: const Text('Edit Profile Image'),
                      onTap: () {
                        // هنا يمكن استخدام ImagePicker لتحديد صورة جديدة
                        // ثم تحديثها باستخدام ProfileCubit
                        _showEditDialog(
                          title: 'Edit Profile Image',
                          content: const Text('Implement image picker to choose new profile image.'),
                          onConfirm: () {
                            // مثال: إرسال رابط جديد للصورة
                            context.read<ProfileCubit>().updateUserProfileImage('new_profile_image_url');
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return Container();
        },
      ),
    );
  }
}
