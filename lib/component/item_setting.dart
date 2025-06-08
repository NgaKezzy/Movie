import 'package:app/config/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemSetting extends StatelessWidget {
  const ItemSetting(
      {super.key, this.text = '', required this.onTap, required this.path});
  final String text;
  final VoidCallback onTap;
  final String path;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10),
          height: 60,
          width: width,
          child: Row(
            children: [
              SvgPicture.asset(path,
                  width: 24, color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(
                width: AppSize.size10,
              ),
              Text(text),
            ],
          )),
    );
  }
}
