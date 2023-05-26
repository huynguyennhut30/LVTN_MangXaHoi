import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';
import 'package:lvtn_mangxahoi/utils/global_variables.dart';

import '../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: HomeScreenItems,
        controller: pageController,
        // physics: const NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: mobileBackgroundColor,
        animationDuration: Duration(milliseconds: 300),
        height: 60,
        items: [
          Icon(
              Icons.home,
              color: _page == 0 ? blackColor : secondaryColor,
            ),
            Icon(
              Icons.search,
              color: _page == 1 ? blackColor : secondaryColor,
            ),
            Icon(
              Icons.add_circle,
              color: _page == 2 ? blackColor : secondaryColor,
            ),
            Icon(
              Icons.notifications,
              color: _page == 3 ? blackColor : secondaryColor,
            ),
            Icon(
              Icons.person,
              color: _page == 4 ? blackColor : secondaryColor,
            ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.home,
          //     color: _page == 0 ? primaryColor : secondaryColor,
          //   ),
          //   backgroundColor: primaryColor,
          //   label: '',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.search,
          //     color: _page == 1 ? primaryColor : secondaryColor,
          //   ),
          //   backgroundColor: primaryColor,
          //   label: '',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.add_circle,
          //     color: _page == 2 ? primaryColor : secondaryColor,
          //   ),
          //   backgroundColor: primaryColor,
          //   label: '',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.notifications,
          //     color: _page == 3 ? primaryColor : secondaryColor,
          //   ),
          //   backgroundColor: primaryColor,
          //   label: '',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.person,
          //     color: _page == 4 ? primaryColor : secondaryColor,
          //   ),
          //   backgroundColor: primaryColor,
          //   label: '',
          // ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
