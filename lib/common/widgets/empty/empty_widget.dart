import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie/core/gen/assets.gen.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.content = 'Không có dữ liệu!'});
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [SvgPicture.asset(Assets.svg.empty), Text(content)],
    );
  }
}
