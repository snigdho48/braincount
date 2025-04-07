import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  
  NavController navController = Get.put(NavController());
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
      child:AnimatedBottomNavigationBar(
      
      icons: iconList,
      activeIndex: navController.selectedIndex.value, // The active index
      gapLocation: GapLocation.center, // The position of the gap
      notchSmoothness: NotchSmoothness.softEdge, // The notch smoothness
      shadow: BoxShadow(
        color: Colors.transparent,
        blurRadius: 5,
        offset: Offset(0, 4),
      ),
      onTap: (index) {
          navController.changeIndex(index);
           if (index == 0) {
          // Navigate to the home route when the first icon is tapped
          Get.toNamed(Routes.HOME);
        } else if (index == 1) {
          Get.toNamed(Routes.NOTIFICATIONS);
          
        } else if (index == 2) {
         Get.toNamed(Routes.TASKLIST);
        } else if (index == 3) {
          Get.toNamed(Routes.PROFILE);
       
        }
 
       
      },
      
      height: 80,
      notchMargin: 3,
      leftCornerRadius: 5,
      rightCornerRadius: 5,
      backgroundColor: Colors.white,
    
      inactiveColor: Colors.grey.shade400,
      activeColor: Color.fromARGB(255, 9, 165, 128),
      scaleFactor: 1.5,
    
    ),
    );
  }
}


