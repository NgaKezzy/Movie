import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie/core/colors/app_colors.dart';

class LoadingComponent extends StatelessWidget {
  const LoadingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: AppColors.orange5,
        size: screenWidth * 0.08,
      ),
    );
  }
}
