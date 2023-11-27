import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:finalfrontproject/childProfile.dart';
import 'package:finalfrontproject/childScreen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//to fetch photo&name
Future<Map<String, dynamic>> fetchUserData(String email) async {
  final response = await http
      .get(Uri.parse('http://192.168.1.106:3000/showchildprofile/$email'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

class GlowingButton extends StatefulWidget {
  final Color color1;
  final Color color2;
  final String label;
  final IconData icon;

  GlowingButton(
      {Key? key,
      this.color1 = Colors.cyan,
      this.color2 = Colors.greenAccent,
      this.label = "",
      this.icon = Icons.lightbulb})
      : super(key: key);

  @override
  _GlowingButtonState createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
  var glowing = true;
  var scale = 1.0;

  Map<String, dynamic> userData = {};
  @override
  void initState() {
    super.initState();
    fetchUserData("tassiyad@gmail.com").then((data) {
      setState(() {
        userData = data;
        userData = data;
        String baseUrl = "http://192.168.1.106:3000";
        String imagePath = "uploads";
        String imageUrl =
            baseUrl + "/" + imagePath + "/" + userData['profilePicture'];
        profilePictureController.text =
            userData.containsKey('profilePicture') ? imageUrl : '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (val) {
        setState(() {
          glowing = false;
          scale = 1.0;
        });
      },
      onTapDown: (val) {
        setState(() {
          glowing = true;
          scale = 1.1;
        });
      },
      child: AnimatedContainer(
        transform: Matrix4.identity()..scale(scale),
        duration: Duration(milliseconds: 200),
        height: 48,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            colors: [widget.color1, widget.color2],
          ),
          boxShadow: glowing
              ? [
                  BoxShadow(
                    color: widget.color1.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 16,
                    offset: Offset(-8, 0),
                  ),
                  BoxShadow(
                    color: widget.color2.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 16,
                    offset: Offset(8, 0),
                  ),
                  BoxShadow(
                    color: widget.color1.withOpacity(0.2),
                    spreadRadius: 16,
                    blurRadius: 32,
                    offset: Offset(-8, 0),
                  ),
                  BoxShadow(
                    color: widget.color2.withOpacity(0.2),
                    spreadRadius: 16,
                    blurRadius: 32,
                    offset: Offset(8, 0),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              glowing ? widget.icon : widget.icon,
              color: Colors.white,
            ),
            SizedBox(height: 1),
            Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class mainPageChild extends StatefulWidget {
  @override
  _mainPageChildState createState() => _mainPageChildState();
}

class _mainPageChildState extends State<mainPageChild> {
  File? myfile;

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 243, 192, 218),
                Color.fromRGBO(205, 245, 250, 0.898),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: myfile != null
              ? FileImage(myfile!)
              : profilePictureController.text.isNotEmpty
                  ? NetworkImage(profilePictureController.text) as ImageProvider
                  : AssetImage('images/background.gif') as ImageProvider,
          radius: 20,
          backgroundColor: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => childProfile()),
              );
            },
          ),
        ),
        title: Text(
          "BrainyBaddies",
          style: GoogleFonts.oswald(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 55, 164, 241),
              fontSize: 25,
            ),
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        index: selectedIndex,
        color: Color.fromARGB(255, 55, 164, 241),
        backgroundColor: Color.fromRGBO(205, 245, 250, 0.898),
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.message,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications,
            size: 30,
            color: Colors.white,
          )
        ],
        onTap: (value) {
          if (value == 0) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: childScreen(),
              ),
            );
          } else if (value == 1) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: childProfile(),
              ),
            );
          } else if (value == 2) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: childProfile(),
              ),
            );
          } else if (value == 3) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: childProfile(),
              ),
            );
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              child: SizedBox(
                width: double.infinity,
                child: GlowingButton(
                  color1: Color.fromARGB(255, 162, 222, 247),
                  color2: Color.fromARGB(255, 229, 168, 222),
                  label: "Stories",
                  icon: Icons.book,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: SizedBox(
                width: double.infinity,
                child: GlowingButton(
                  color1: Color.fromARGB(255, 162, 222, 247),
                  color2: Color.fromARGB(255, 229, 168, 222),
                  label: "Games",
                  icon: Icons.gamepad,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: SizedBox(
                width: double.infinity,
                child: GlowingButton(
                  color1: Color.fromARGB(255, 162, 222, 247),
                  color2: Color.fromARGB(255, 229, 168, 222),
                  label: "Videos",
                  icon: Icons.videocam,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
