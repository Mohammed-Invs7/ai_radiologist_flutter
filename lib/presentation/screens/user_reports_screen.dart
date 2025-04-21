import 'package:ai_radiologist_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_radiologist_flutter/constants/my_colors.dart';
import 'package:ai_radiologist_flutter/business_logic/cubit/report_cubit.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().fetchReports();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }


  @override
  void didPopNext() {
    context.read<ReportCubit>().fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: AppBar(
        title: const Text('Reports', style: TextStyle(color: MyColors.whiteColor)),
        backgroundColor: MyColors.mainColor,
        iconTheme: IconThemeData(color: MyColors.mainColor),
        elevation: 0,
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportLoaded) {
            final reports = state.reports;
            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                final formattedDate =
                DateFormat('yyyy-MM-dd').format(report.reportDate);
                return InkWell(
                  onTap: () {
                    // التنقل إلى شاشة تفاصيل التقرير
                    Navigator.pushNamed(
                      context,
                      '/report_detail',
                      arguments: report.id,
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0.5,
                    color: MyColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: MyColors.mainColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // النص على اليسار
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.mainColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  report.radiologyModality,
                                  style: TextStyle(fontSize: 16, color: MyColors.blackColor),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  report.bodyAnatomicalRegion,
                                  style: TextStyle(fontSize: 16, color: MyColors.blackColor),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: TextStyle(fontSize: 12, color: MyColors.blackColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // الصورة على اليمين
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(report.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is ReportError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
