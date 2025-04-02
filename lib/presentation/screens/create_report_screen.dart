// lib/presentation/screens/report_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';
import 'package:ai_radiologist_flutter/business_logic/cubit/report_cubit.dart';


class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({Key? key}) : super(key: key);

  @override
  State<CreateReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<CreateReportScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImageWithCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: AppBar(
        backgroundColor: MyColors.mainColor,
        toolbarHeight: 0, // Hide the app bar toolbar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Preview image container
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.mainColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : Center(
                  child: Text(
                    "No image selected",
                    style: TextStyle(fontSize: 18, color: MyColors.mainColor),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Buttons for gallery and camera
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.photo_library, color: MyColors.mainColor),
                    label: const Text("Gallery", style: TextStyle(color: MyColors.mainColor),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.whiteColor,
                      side: BorderSide(
                        color: MyColors.mainColor,
                        width: 2, // يمكنك تعديل السماكة حسب الحاجة
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _captureImageWithCamera,
                    icon: const Icon(Icons.camera_alt, color: MyColors.whiteColor),
                    label: const Text("Camera", style: TextStyle(color: MyColors.whiteColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.mainColor,
                      side: BorderSide(
                        color: MyColors.whiteColor,
                        width: 2, // يمكنك تعديل السماكة حسب الحاجة
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Send button
              ElevatedButton(
                onPressed: _selectedImage != null
                    ? () {
                  context.read<ReportCubit>().createReport(_selectedImage!);
                }
                    : null,
                child: const Text("Send"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.mainColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
              // Bloc to show progress indicator or report text
              BlocBuilder<ReportCubit, ReportState>(
                builder: (context, state) {
                  if (state is ReportUploading) {
                    return const CircularProgressIndicator();
                  } else if (state is ReportSuccess) {
                    return Text(
                      state.report,
                      style: TextStyle(fontSize: 18, color: MyColors.mainColor),
                      textAlign: TextAlign.center,
                    );
                  } else if (state is ReportError) {
                    return Text(
                      state.message,
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                      textAlign: TextAlign.center,
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
