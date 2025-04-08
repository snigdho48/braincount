import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

PreferredSize appBarWidget(BuildContext context,
    {bool threedot = true, bool back = false}) {
  var isSubroute = Get.currentRoute.split('/').length > 2;
  print(back);
  return PreferredSize(
    preferredSize:
        Size(Get.width, kToolbarHeight + MediaQuery.of(context).padding.top),
    child: Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/bgtop.png'),
          fit: BoxFit.cover,
        ),
      ),
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
          Text(
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
                  return IconButton(
                    icon: FaIcon(FontAwesomeIcons.ellipsisVertical),
                    onPressed: () {
                      // Open end drawer for notifications
                    },
                  );
                })
              : SizedBox.shrink(),
        ],
      ),
    ),
  );
}
