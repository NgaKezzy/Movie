import 'package:app/config/di.dart';
import 'package:app/feature/login/cubit/auth_cubit.dart';
import 'package:app/feature/login/cubit/auth_state.dart';
import 'package:app/feature/setting/models/premium_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PremiumScreen extends StatelessWidget {
  PremiumScreen({super.key});

  final benefits = [
    'Xem phim chất lượng cao (Full HD / 4K)',
    'Không quảng cáo – Không bị gián đoạn khi xem',
    'Xem trước các phim mới – Truy cập sớm nội dung hot',
    'Tải phim về xem offline',
    'Xem cùng lúc trên nhiều thiết bị',
    'Phim độc quyền chỉ có ở Premium',
  ];

  final List<PremiumPackage> premiumPackages = [
    PremiumPackage(name: 'Gói 1 tháng', price: 100, duration: 30),
    PremiumPackage(name: 'Gói 3 tháng', price: 300, duration: 90),
    PremiumPackage(name: 'Gói 6 tháng', price: 500, duration: 180),
    PremiumPackage(name: 'Gói 12 tháng', price: 1000, duration: 365),
  ];

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = di.get();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Member'),
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
                      'Hiện có: ${state.userInfo?.diamond ?? 0} ',
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
                  children: const [
                    Icon(Icons.lock_open, color: Colors.amber),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mở khóa những quyền lợi đặc biệt chỉ dành cho thành viên Premium:',
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
                        Expanded(child: Text(b)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Premium Packages
                const Text(
                  'Chọn gói Premium:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Hạn sử dụng gói premium: ${state.userInfo?.premiumTerm != null ? DateFormat('dd/MM/yyyy').format(state.userInfo!.premiumTerm!) : 'Chưa đăng ký'}',
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
                              package.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Thời hạn: ${package.duration} ngày'),
                            Row(
                              children: [
                                Text('Giá: ${package.price}'),
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
                                          content:
                                              Text('Bạn không đủ diamond')),
                                    );
                                  } else {
                                    authCubit.registerPremium(
                                        package.duration, package.price);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Chúc mừng bạn đã thành công đăng ký gói premium')),
                                    );
                                  }
                                },
                                child: const Text('Chọn gói này'),
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
