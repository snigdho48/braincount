import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingButton extends StatefulWidget {
  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  double _scale = 1.0; // Initial scale factor

  void _onTapDown() {
    setState(() {
      _scale = 0.9; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale, // Apply scale
      duration: Duration(milliseconds: 200), // Animation duration
      onEnd: () => setState(() {
        _scale = 1.0; // Return to the initial scale
      }),
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
          onPressed: () {
            // Navigate to the home route when pressed
            _onTapDown();
            Get.toNamed(Routes.HOME);

         
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Colors.black,
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}
