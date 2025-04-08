import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingButton extends StatelessWidget {
  


     final navController = Get.put(NavController());

  @override
  Widget build(BuildContext context) {
    navController.startScaling();

    return Obx(()=>
       AnimatedScale(
        scale: navController.scale.value, // Apply scale
        duration: Duration(milliseconds: 200), // Animation duration
        onEnd: () => navController.scale.value = 1.0, // Reset scale after animation
        
        curve: Curves.easeInOut, // Smooth transition
        child: SizedBox(
          height: Get.width * 0.15, // Increased size
          width: Get.width * 0.15, // Increased size
          child: FloatingActionButton(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightElevation: 0,
            isExtended: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: navController.opencamera,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                 width: 65, // Set width
                height: 65,
                color: Colors.black,
                child: Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Get.currentRoute == "/dataCollect"
                      ? Obx(()=>
                         AnimatedScale(
                          scale: navController.btnScale.value, // Apply scale
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          
                          child: Icon(
                              Icons.camera_alt,
                              size: 32,
                              color: Colors.black,
                            ),
                        ),
                      )
                      : SizedBox.shrink()
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
