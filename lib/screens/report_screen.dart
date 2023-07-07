// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';

import 'package:lvtn_mangxahoi/screens/report_detail_screen.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';

class ReportScreen extends StatefulWidget {
  final String postId;
  final String postUrl;

  const ReportScreen({
    Key? key,
    required this.postId,
    required this.postUrl,
  }) : super(key: key);
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final List<String> reportCategories = [
    'Đây là spam',
    'Tôi không thích nội dung này',
    'Lừa đảo hoặc gian lận',
    'Thông tin sai sự thật',
    'Ảnh khỏa thân hoặc hoạt động gợi dục',
    'Vi phạm quyền sở hữu trí tuệ',
    'Bạo lực hoặc tổ chức nguy hiểm',
    'Nội dung khác',
    // Thêm các danh mục báo cáo khác ở đây
  ];
  bool isLoading = false;
  bool isSuccess = false;

  Future<void> _submitReport(String reportCategory) async {
    setState(() {
      isLoading = true;
    });

    await FireStoreMethods.addReport(
        widget.postId, reportCategory, widget.postUrl);

    setState(() {
      isLoading = false;
      isSuccess = true;
    });

    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kWhite,
          title: const Text(
            'Báo cáo thành công!',
            style: TextStyle(color: kBlack),
          ),
          content: const Text(
            'Cảm ơn bạn đã cho chúng tôi biết!',
            style: TextStyle(color: kBlack),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nội dung báo cáo',
          style: TextStyle(color: kBlack),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black, // Đặt màu cho nút quay về
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: reportCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  reportCategories[index],
                  style: const TextStyle(color: kBlack),
                ),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ReportDetailScreen(
                  //       reportCategory: reportCategories[index],
                  //     ),
                  //   ),
                  // );
                  // setState(() {
                  //   isLoading = true;
                  // });
                  // FireStoreMethods.addReport(
                  //     widget.postId, reportCategories[index], widget.postUrl);
                  // setState(() {
                  //   isLoading = false;
                  //   isSuccess = true;
                  // });
                  _submitReport(reportCategories[index]);
                },
              );
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
