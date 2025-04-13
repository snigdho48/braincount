import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    NavController navController = Get.put(NavController());

    List<IconData> iconList = [
      Icons.home,
      Icons.list,
      FontAwesomeIcons.circleDollarToSlot,
      Icons.notifications,
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
        gapWidth: 0,
        icons: iconList,
        activeIndex: navController.selectedIndex.value, // The active index
        shadow: BoxShadow(
          color: Colors.transparent,
          blurRadius: 5,
          offset: Offset(0, 4),
        ),
        onTap: (index) {
          navController.changeIndex(index);
        },

        height: 80,
        backgroundColor: Colors.white,

        inactiveColor: Colors.grey.shade400,
        activeColor: Color.fromARGB(255, 9, 165, 128),
      ),
    );
  }
}
