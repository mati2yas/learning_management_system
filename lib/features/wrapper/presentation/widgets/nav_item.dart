import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final WidgetRef ref;
  final Function onTap;
  final bool isCurr;
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isCurr,
    required this.onTap,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        height: 40,
        child: isCurr
            ? Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: isCurr ? 12 : 0),
                    decoration: BoxDecoration(
                      color: isCurr ? Colors.white : AppColors.mainBlue,
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.mainBlue,
                    ),
                  ),
                  Text(
                    label,
                    style: textTh.labelSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  Text(
                    label,
                    style: textTh.labelSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
