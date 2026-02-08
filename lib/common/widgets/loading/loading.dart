import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:movie/core/colors/app_colors.dart';

class Loading {
  static final Loading _singleton = Loading._internal();

  factory Loading() {
    return _singleton;
  }

  Loading._internal();

  static OverlaySupportEntry? _overlaySupportEntry;

  static void hideLoading() {
    _overlaySupportEntry?.dismiss();
    _overlaySupportEntry = null;
  }

  static void showLoading({double opacityColor = 0.6}) {
    // _overlaySupportEntry?.dismiss(); // Xóa overlay cũ nếu có
    _overlaySupportEntry = showOverlay((context, opacity) {
      final screenSize = MediaQuery.of(context).size;
      final screenWidth = screenSize.width;
      final screenHeight = screenSize.height;

      return Opacity(
        opacity: opacity, // Giữ hiệu ứng overlay
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.black.withOpacity(
            opacityColor,
          ), // Áp dụng opacityColor cho nền
          child: Center(
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.orange5,
                size: screenWidth * 0.08,
              ),
            ),
          ),
        ),
      );
    }, duration: const Duration(minutes: 20));
  }
}
