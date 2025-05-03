import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';
import 'package:ai_radiologist_flutter/business_logic/cubit/profile_cubit.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage(ImageSource src) async {
    final picked = await _picker.pickImage(source: src, imageQuality: 85);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

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
            final currentImageUrl = user.profileImage;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(user.profileImage),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Name: ',
                                  style: TextStyle(fontSize: 20, color: MyColors.mainColor, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '${user.firstName} ${user.lastName}',
                                  style: TextStyle(fontSize: 20, color: MyColors.blackColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Email: ',
                                  style: TextStyle(fontSize: 18, color: MyColors.mainColor),
                                ),
                                TextSpan(
                                  text: user.email!,
                                  style: TextStyle(fontSize: 18, color: MyColors.blackColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Age: ',
                                  style: TextStyle(fontSize: 18, color: MyColors.mainColor),
                                ),
                                TextSpan(
                                  text: "${user.age.toString()} years old",
                                  style: TextStyle(fontSize: 18, color: MyColors.blackColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Date of Birth: ',
                                  style: TextStyle(fontSize: 18, color: MyColors.mainColor),
                                ),
                                TextSpan(
                                  text: user.dateOfBirth!,
                                  style: TextStyle(fontSize: 18, color: MyColors.blackColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Gender: ',
                                  style: TextStyle(fontSize: 18, color: MyColors.mainColor),
                                ),
                                TextSpan(
                                  text: user.gender == 'M'? 'Male': 'Female',
                                  style: TextStyle(fontSize: 18, color: MyColors.blackColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // edit name:
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
                  // edit gender
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: MyColors.mainColor, width: 1),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.transgender_outlined, color: MyColors.mainColor),
                      title: const Text('Edit Gender'),
                      onTap: () {
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
                  // edit profile image
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: MyColors.mainColor, width: 1),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.image_outlined, color: MyColors.mainColor),
                      title: const Text('Edit Profile Image'),
                      onTap: () {
                        final picker = ImagePicker();
                        File? dialogImage = _selectedImage;
                        // خزن السياق الأصلي بعيداً عن الدايلوگ
                        final parentContext = context;

                        showDialog(
                          context: parentContext,
                          builder: (_) => BlocProvider.value(
                            value: parentContext.read<ProfileCubit>(),
                            child: StatefulBuilder(
                              builder: (dialogContext, setStateDialog) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text('Edit Profile Image', style: TextStyle(color: MyColors.mainColor)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: dialogImage != null
                                            ? FileImage(dialogImage!)
                                            : NetworkImage(
                                            currentImageUrl
                                        ) as ImageProvider,
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          final picked = await picker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 85,
                                          );
                                          if (picked != null) {
                                            setStateDialog(() => dialogImage = File(picked.path));
                                            setState(() => _selectedImage = File(picked.path));
                                          }
                                        },
                                        icon: Icon(Icons.photo_library, color: MyColors.whiteColor),
                                        label: const Text('Gallery', style: TextStyle(color: MyColors.whiteColor)),
                                        style: ElevatedButton.styleFrom(backgroundColor: MyColors.mainColor),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          final picked = await picker.pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 85,
                                          );
                                          if (picked != null) {
                                            setStateDialog(() => dialogImage = File(picked.path));
                                            setState(() => _selectedImage = File(picked.path));
                                          }
                                        },
                                        icon: Icon(Icons.camera_alt, color: MyColors.whiteColor),
                                        label: const Text('Camera', style: TextStyle(color: MyColors.whiteColor)),
                                        style: ElevatedButton.styleFrom(backgroundColor: MyColors.mainColor),
                                      ),
                                    ],
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(dialogContext).pop(),
                                      child: Text('Cancel', style: TextStyle(color: MyColors.mainColor)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_selectedImage != null) {
                                          dialogContext.read<ProfileCubit>().updateUserProfileImage(_selectedImage!);
                                          Navigator.of(dialogContext).pop();
                                        } else {
                                          ScaffoldMessenger.of(parentContext).showSnackBar(
                                            const SnackBar(content: Text('Please pick an image first')),
                                          );
                                        }
                                      },
                                      child: Text('Confirm', style: TextStyle(color: MyColors.mainColor)),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
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
