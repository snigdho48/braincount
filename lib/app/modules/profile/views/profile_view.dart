import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/bottomnav.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: backgroundColorLinear(
        child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: Get.height * .02,
                  left: context.width * .05,
                  right: context.width * .05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: Get.height * .04,
                children: [
                  Container(
                    width: Get.width * 0.4,
                    height: Get.width * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 4,
                      ),
                      image: DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/300'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Name
                  Text(
                    'Md. Atiquzzaman Snigdho',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  // Bio/Description
                  Text(
                    'Supervisor at Braincount',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),

                  // Contact Info Section (email, phone)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('snigdho@gmail.com', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('+8801775350203', style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  // Edit Profile Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the edit profile screen
                    },
                    child: Text('Edit Profile'),
                  ),
                  SizedBox(
                    height: Get.height * .03,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
