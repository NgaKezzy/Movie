import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/core/routers/app_router.dart';
import 'package:movie/features/auth/cubit/auth_cubit.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final LiquidController _liquidController = LiquidController();

  int _currentPage = 0;
  final AuthCubit authCubit = getIt.get();

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildPage(
        color: Colors.deepPurple,
        title: "Chào mừng!",
        subtitle: "Khám phá ứng dụng tuyệt vời của chúng tôi.",
      ),
      buildPage(
        color: Colors.teal,
        title: "Nhanh chóng",
        subtitle: "Dễ sử dụng và cực kỳ nhanh.",
      ),
      buildPage(
        color: Colors.orange,
        title: "Bắt đầu ngay",
        subtitle: "Trải nghiệm ngay hôm nay!",
        isLast: true,
        onTap: () {
          if (authCubit.state.isLogin) {
            context.go(AppRouteConstant.myHomePage);
          } else {
            context.go(AppRouteConstant.loginScreen);
          }
          print("Đi tới màn hình chính");
        },
      ),
    ];
    return Scaffold(
      body: LiquidSwipe(
        liquidController: _liquidController,
        pages: pages,
        fullTransitionValue: 300,
        positionSlideIcon: 0.8,
        // slideIconWidget: const Icon(Icons.arrow_back_ios),
        enableLoop: false,
        onPageChangeCallback: (activePageIndex) {
          setState(() {
            _currentPage = activePageIndex;
          });
        },
      ),
    );
  }

  Widget buildPage({
    required Color color,
    required String title,
    required String subtitle,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return SizedBox.expand(
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: ScreenUtil().screenHeight * 0.3),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              if (isLast)
                ElevatedButton(onPressed: onTap, child: const Text("Bắt đầu")),
              Spacer(),
              AnimatedSmoothIndicator(
                activeIndex: _currentPage,
                count: 3,
                duration: Duration(milliseconds: 300),
                effect: const WormEffect(
                  dotColor: Colors.white54,
                  activeDotColor: Colors.white,
                ),
                onDotClicked: (index) {
                  _liquidController.animateToPage(page: index);
                },
              ),
              SizedBox(height: ScreenUtil().screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
