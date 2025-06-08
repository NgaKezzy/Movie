import 'package:app/config/di.dart';
import 'package:app/feature/login/cubit/auth_cubit.dart';
import 'package:app/feature/login/cubit/auth_state.dart';
import 'package:app/feature/setting/models/premium_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = di.get();
    final Size size = MediaQuery.of(context).size;
    final app = AppLocalizations.of(context);

    final benefits = [
      app?.watchHighQualityMovies,
      app?.noAds,
      app?.watchNewMovies,
      app?.downloadMovies,
      app?.watchOnMultipleDevices,
      app?.exclusiveContent,
    ];

    final List<PremiumPackage> premiumPackages = [
      PremiumPackage(name: '1', price: 100, duration: 30),
      PremiumPackage(name: '3', price: 300, duration: 90),
      PremiumPackage(name: '6', price: 500, duration: 180),
      PremiumPackage(name: '12', price: 1000, duration: 365),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(app!.premiumMember),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Benefits Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${app.currentlyAvailable}: ${state.userInfo?.diamond ?? 0} ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SvgPicture.asset(
                      'assets/icons/diamond.svg',
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Icon(Icons.lock_open, color: Colors.amber),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        app.unlockExclusiveBenefits,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Benefits List
                ...benefits.map(
                  (b) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(b ?? '')),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Premium Packages
                Text(
                  app.premiumPackage,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '${app.premiumPackageExpirationDate} ${state.userInfo?.premiumTerm != null ? DateFormat('dd/MM/yyyy').format(state.userInfo!.premiumTerm!) : app.notRegistered}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: premiumPackages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final package = premiumPackages[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${app.premiumPackage} ${package.name}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                '${app.duration}: ${package.duration} ${app.days}'),
                            Row(
                              children: [
                                Text('${app.price}: ${package.price}'),
                                SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/diamond.svg',
                                  width: 20,
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (state.userInfo!.diamond < package.price) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(app.notEnoughDiamond)),
                                    );
                                  } else {
                                    authCubit.registerPremium(
                                        package.duration, package.price);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(app
                                              .youHaveSuccessfullyRegistered)),
                                    );
                                  }
                                },
                                child: Text(app.selectPackage),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
