import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/resources/auth_method.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/screens/login_screen.dart';
import 'package:lvtn_mangxahoi/screens/profile_edit_screen.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';
import 'package:lvtn_mangxahoi/utils/utils.dart';
import 'package:lvtn_mangxahoi/widgets/follow_button.dart';
 
 
import 'dart:math' as math;

import 'package:lvtn_mangxahoi/widgets/profile_background.dart';
import 'package:lvtn_mangxahoi/widgets/stat.dart';

 

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedTab = 'photos';

  _changeTab(String tab) {
    setState(() => _selectedTab = tab);
  }
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = await userSnap.data()!;
      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      
      followers = await userSnap.data()!['followers'].length;
      following = await userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        :Scaffold(
      backgroundColor: FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                       ?Colors.transparent:Colors.white,
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 30,),
            Container(
              width: double.infinity,
              child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return profileEditScreen( userData: userData,);
                                            },));
                        },
                        child: FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                       ? Container(
                          height:30,
                          margin: EdgeInsets.only(right: 10),
                          
                          child: Icon(Icons.pending,color: Color.fromARGB(255, 181, 176, 176),),
                        ):SizedBox(),
                      ),
                    ),
                    Transform.rotate(
                      angle: math.pi / 4,
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: kBlack),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                    ClipPath(
                      clipper: ProfileImageClipper(),
                      child: Image.network(
                        userData['photoUrl'],
                        width: 180.0,
                        height: 180.0,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
            ),
              Text(
                userData['username'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25
                )
              ),
              SizedBox(height: 4.0),
              Text(
                userData['email'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15
                )
              ),
               FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? SizedBox():isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )  ,    
                                               
                                             
                                        
              SizedBox(height: 30.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stat(title: 'Posts', value: postLen),
                    Stat(title: 'Followers', value: followers),
                    Stat(title: 'Follows', value: following),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => _changeTab('photos'),
                    child: SvgPicture.asset(
                      
                      'assets/icons/Button-photos.svg',
                      height: 20,
                      color: _selectedTab == 'photos' ? k2AccentStroke : null,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _changeTab('saved'),
                    child: SvgPicture.asset(
                      'assets/icons/Button-saved.svg',
                      height: 20,
                      color: _selectedTab == 'saved' ? k2AccentStroke : null,
                    ),
                  ),
                ],
              ),
         
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
              
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                                
                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
          ],
        ),

      ),
    );
  }
}

class ProfileImageClipper extends CustomClipper<Path> {
  double radius = 35;

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(size.width / 2 - radius, radius)
      ..quadraticBezierTo(size.width / 2, 0, size.width / 2 + radius, radius)
      ..lineTo(size.width - radius, size.height / 2 - radius)
      ..quadraticBezierTo(size.width, size.height / 2, size.width - radius,
          size.height / 2 + radius)
      ..lineTo(size.width / 2 + radius, size.height - radius)
      ..quadraticBezierTo(size.width / 2, size.height, size.width / 2 - radius,
          size.height - radius)
      ..lineTo(radius, size.height / 2 + radius)
      ..quadraticBezierTo(0, size.height / 2, radius, size.height / 2 - radius)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}




                                    