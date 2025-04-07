import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await initall();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'Raleway',
        
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          
          elevation: 0,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation:5,
        ),
      ),
      
    ),
  );
}
Future<void> initall() async {
    await GetStorage.init();
    oneRequest.loadingconfig();
      Get.put(NavController());


  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

}
