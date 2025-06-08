import 'package:app/config/di.dart';
import 'package:app/feature/login/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthCubit authCubit = di.get();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final app = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/icon_app.svg',
                    height: 80,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  app!.welcomeToTheApp,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.tertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  app.loginToExperienceAllFeatures,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.tertiary.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiaryContainer,
                    foregroundColor: theme.colorScheme.tertiary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () => authCubit.login(
                    context,
                    app.loginSuccessfully,
                    app.cancelLogin,
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/google.svg',
                    width: 24,
                  ),
                  label: Text(
                    app.loginWithGoogle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
