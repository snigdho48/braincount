import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _bottomNavIndex = 0; // Active index for the bottom navigation

  @override
  Widget build(BuildContext context) {
    List<IconData> iconList = [
    Icons.home,
      Icons.notifications,
      Icons.list,
      Icons.person,
    ];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/bgbottom.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: AnimatedBottomNavigationBar(
        splashColor: Colors.transparent,
        icons: iconList,
        activeIndex: _bottomNavIndex, // The active index
        gapLocation: GapLocation.center, // The position of the gap
        notchSmoothness: NotchSmoothness.softEdge, // The notch smoothness
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index; // Update the active index on tap
          });
        },
        
        height: 80,
        notchMargin: 5,
        leftCornerRadius: 22,
        rightCornerRadius: 22,
        backgroundColor: Colors.white,
      
        inactiveColor: Colors.grey.shade400,
        activeColor: Color.fromARGB(255, 9, 165, 128),
        scaleFactor: 1.5,
      
      ),
    );
  }
}


