import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/responsive/mobile_screen_layout.dart';
import 'package:lvtn_mangxahoi/responsive/responsive_layout_screen.dart';
import 'package:lvtn_mangxahoi/responsive/web_screen_layout.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';
import 'package:lvtn_mangxahoi/widgets/background_title.dart';

class ChoiceTitle extends StatefulWidget {
  const ChoiceTitle({super.key});

  @override
  State<ChoiceTitle> createState() => _ChoiceTitleState();
}

class _ChoiceTitleState extends State<ChoiceTitle> {
  List<String> topics = [
    'Thiên nhiên',
    'Đô thị',
    'Con người',
    'Động vật',
    'Thể thao',
    'Ẩm thực',
    'Văn hóa và lễ hội',
    'Khoa học và công nghệ',
    'Nghệ thuật',
    'Du lịch',
    'Gia đình',
    'Truyện tranh và hoạt hình'
  ];
  bool canConfirm = false;
  List<String> selectedTopics = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  const Text(
                    'Hãy chọn chủ đề yêu thích của bạn:',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    children: topics.map((topic) {
                      final isSelected = selectedTopics.contains(topic);

                      return ChoiceChip(
                        label: Text(
                          topic,
                          style: const TextStyle(color: kBlack),
                        ),
                        selected: isSelected,
                        backgroundColor: isSelected
                            ? const Color.fromARGB(255, 152, 203, 245)
                            : const Color.fromARGB(255, 182, 179, 179),
                        selectedColor: const Color.fromARGB(255, 158, 203, 240),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedTopics.add(topic);
                            } else {
                              selectedTopics.remove(topic);
                            }
                            canConfirm = selectedTopics.isNotEmpty;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                            mobileScreenLayout: MobileScreenLayout(),
                            webScreenLayout: WebScreenLayout(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Bỏ qua'),
                  ),
                  ElevatedButton(
                    onPressed: canConfirm
                        ? () {
                            // Thực hiện các hành động sau khi xác nhận
                            FireStoreMethods.uploadTitle(selectedTopics);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const ResponsiveLayout(
                                  mobileScreenLayout: MobileScreenLayout(),
                                  webScreenLayout: WebScreenLayout(),
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Xác nhận'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
