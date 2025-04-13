import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';

PreferredSize appBarWidget(BuildContext context,
    {bool threedot = true, bool back = false}) {
  var isSubroute = Get.currentRoute.split('/').length > 2;
  final storage = GetStorage();
  return PreferredSize(
    preferredSize:
        Size(Get.width, kToolbarHeight + MediaQuery.of(context).padding.top),
    child: Container(
      padding: Get.currentRoute == '/login' || Get.currentRoute == '/signup'
          ? EdgeInsets.zero
          : EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/bgtop.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              blurRadius: 1, // How blurry the shadow is
              offset: Offset(0, 2), // Horizontal and vertical displacement
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(builder: (context) {
            if (back) {
              return IconButton(
                icon: Icon(Icons.arrow_back_ios),
                padding: EdgeInsets.only(left: Get.width * .05),
                onPressed: () {
                  Get.back();
                },
              );
            }
            if (!isSubroute)
              return SizedBox(
                width: Get.width * .1,
              );

            return IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              },
            );
          }),
          // Displaying the current route with first letter capitalized for each word

          Get.currentRoute == '/login' || Get.currentRoute == '/signup'
              ? SizedBox.shrink()
              : Text(
                  Get.currentRoute
                      .substring(1)
                      .split('/')
                      .map((word) => word.isNotEmpty
                          ? (word[0].toUpperCase() +
                              word.substring(1).replaceAllMapped(
                                    RegExp(r'([A-Z])'),
                                    (match) => ' ${match.group(0)}',
                                  ))
                          : '')
                      .join(' - '),
                  style: TextStyle(fontSize: 20),
                ),

          // Notifications IconButton
          threedot
              ? Builder(builder: (context) {
                  if (Get.currentRoute == '/login' ||
                      Get.currentRoute == '/signup')
                    return SizedBox(
                      width: Get.width * .1,
                    );
                  return PopupMenuButton<String>(
                    elevation: 2,
                    surfaceTintColor: Colors.white,
                    icon: FaIcon(FontAwesomeIcons.ellipsisVertical),
                    onSelected: (value) {
                      if (value == 'logout') {
                        // Perform logout action
                        Get.defaultDialog(
                          title: 'Logout',
                          middleText: 'Are you sure you want to logout?',
                          cancel: InkWell(
                            onTap: () async {
                              await storage.erase();
                              Get.offAllNamed('/login');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.width * .05,
                                vertical: Get.height * .01,
                              ),
                              child: Text('Yes'),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2), // Shadow color
                                    blurRadius: 2, // How blurry the shadow is
                                    offset: Offset(0,
                                        2), // Horizontal and vertical displacement
                                  ),
                                ],
                              ),
                            ),
                          ),
                          confirm: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.width * .05,
                                vertical: Get.height * .01,
                              ),
                              child: Text('No'),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2), // Shadow color
                                    blurRadius: 2, // How blurry the shadow is
                                    offset: Offset(0,
                                        2), // Horizontal and vertical displacement
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    color: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        padding: EdgeInsets.zero,
                        value: 'logout',
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: Get.width * .02),
                              Text('Logout'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                })
              : SizedBox.shrink(),
        ],
      ),
    ),
  );
}
