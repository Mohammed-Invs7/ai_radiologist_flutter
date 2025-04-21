import 'dart:io';
import 'package:ai_radiologist_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';
import 'package:ai_radiologist_flutter/business_logic/cubit/report_cubit.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class ReportDetailScreen extends StatefulWidget {
  final int reportId;
  const ReportDetailScreen({Key? key, required this.reportId}) : super(key: key);

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> with RouteAware {
  final TextEditingController _titleController = TextEditingController();
  // متغير لتخزين التفاصيل (الكاش)
  var _cachedReport;

  @override
  void initState() {
    super.initState();
    // جلب البيانات أول مرة
    context.read<ReportCubit>().fetchReportDetail(widget.reportId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    _titleController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // عند الرجوع من شاشة خارج التطبيق (مثلاً من ملف PDF)
  @override
  void didPopNext() {
    // يمكنك تحديث البيانات إذا رغبت؛ أو تركها كالكاش
    // إذا رغبت في تحديث الكاش كل مرة ترجع فيها الصفحة، استخدم:
    context.read<ReportCubit>().fetchReportDetail(widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyColors.whiteColor),
        title: const Text(
          'Report Details',
          style: TextStyle(color: MyColors.whiteColor),
        ),
        backgroundColor: MyColors.mainColor,
      ),
      body: BlocConsumer<ReportCubit, ReportState>(
        listener: (context, state) {
          if (state is ReportDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ReportDeleted) {
            // بعد الحذف، العودة إلى شاشة التقارير
            Navigator.pop(context);
          } else if (state is ReportDetailLoaded) {
            // حفظ البيانات في الكاش وتعبئة حقل العنوان
            _cachedReport = state.reportDetail;
            _titleController.text = state.reportDetail.title;
          }
          if (state is ReportPdfDownloaded) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text('PDF downloaded successfully at ${state.filePath}'),
            //   ),);
            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        size: 48,
                        color: MyColors.mainColor,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '!تم تحميل التقرير\nهل تريد فتحه؟',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    TextButton(
                      onPressed: () {
                        // إغلاق الحوار دون فتح الملف
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        'لا',
                        style: TextStyle(color: MyColors.mainColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // إغلاق الحوار ثم فتح الملف
                        Navigator.of(dialogContext).pop();
                        OpenFile.open(state.filePath);
                      },
                      child: Text(
                        'نعم',
                        style: TextStyle(color: MyColors.mainColor),
                      ),
                    ),
                  ],
                );
              },
            );

          } else if (state is ReportPdfDownloadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error downloading PDF: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          // إذا لم يكن الكاش موجودًا، نعتمد على الحالة الحالية
          if (state is ReportDetailLoading && _cachedReport == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (_cachedReport != null) {
            final report = _cachedReport;
            final formattedDate = DateFormat('yyyy-MM-dd').format(report.reportDate);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // الصورة في الأعلى
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(report.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // تفاصيل التقرير داخل Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: MyColors.mainColor, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // عنوان التقرير مع إمكانية التعديل
                          TextField(
                            controller: _titleController,
                            style: TextStyle(
                              fontSize: 18,
                              color: MyColors.mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Report Title',
                            ),
                            onSubmitted: (newTitle) {
                              context.read<ReportCubit>().updateReportTitle(report.id, newTitle);
                              // تحديث الكاش
                              setState(() {
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            report.radiologyModality,
                            style: TextStyle(fontSize: 16, color: MyColors.mainColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            report.bodyAnatomicalRegion,
                            style: TextStyle(fontSize: 16, color: MyColors.mainColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formattedDate,
                            style: TextStyle(fontSize: 12, color: MyColors.mainColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            report.reportDetails,
                            style: TextStyle(fontSize: 16, color: MyColors.mainColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Text(
                                  'تأكيد الحذف',
                                  style: TextStyle(color: MyColors.mainColor),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: MyColors.mainColor,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('هل أنت متأكد أنك تريد حذف التقرير؟'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: Text(
                                      'لا',
                                      style: TextStyle(color: MyColors.mainColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<ReportCubit>().deleteReport(report.id);
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: Text(
                                      'نعم',
                                      style: TextStyle(color: MyColors.mainColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete_outline, color: MyColors.whiteColor),
                        label: const Text('Delete', style: TextStyle(color: MyColors.whiteColor),),
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.mainColor,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await context.read<ReportCubit>().downloadPdf(report.id);
                          // الرسالة سيتم عرضها داخل listener في الـ Cubit
                        },
                        icon: Icon(Icons.download_outlined, color: MyColors.whiteColor),
                        label: const Text('Download', style: TextStyle(color: MyColors.whiteColor),),
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.mainColor,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          final newTitle = _titleController.text;
                          context.read<ReportCubit>().updateReportTitle(report.id, newTitle);
                          // تحديث الكاش بعد التعديل
                          setState(() {

                          });
                        },
                        icon: Icon(Icons.edit_outlined, color: MyColors.whiteColor),
                        label: const Text('Edit', style: TextStyle(color: MyColors.whiteColor),),
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ReportCubit, ReportState>(
                    builder: (context, state) {
                      if (state is ReportPdfDownloading) {
                        return Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation<Color>(MyColors.mainColor),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            );
          } else if (state is ReportDetailError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
