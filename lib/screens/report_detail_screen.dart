import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  final String reportCategory;

  const ReportDetailScreen({Key? key, required this.reportCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reportCategory),
      ),
      body: Center(
        child: Text('Đây là màn hình chi tiết cho báo cáo $reportCategory'),
      ),
    );
  }
}