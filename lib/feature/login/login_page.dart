import 'package:app/config/di.dart';
import 'package:app/feature/login/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {

  LoginPage({super.key});
final AuthCubit authCubit = di.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/icon_app.svg',
                height: 100,
              ),
              const SizedBox(height: 48),
              const Text(
                'Chào mừng bạn đến với ứng dụng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.grey),
                ),
                onPressed: () => authCubit.login(context),
                icon: SvgPicture.asset(
                  'assets/icons/google.svg',
                  width: 30,
                ),
                label: const Text('Đăng nhập với Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
