import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class RequestTile extends ConsumerWidget {
  final Course course;

  final TextTheme textTh;
  final double selectedPriceType;
  final Function onTap;
  const RequestTile({
    super.key,
    required this.course,
    required this.textTh,
    required this.selectedPriceType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          child: Image.asset(
            "assets/images/${course.image}",
            fit: BoxFit.cover,
          ),
        ),
        title: Text(course.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              width: 220,
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    "$selectedPriceType ETB",
                    style: textTh.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: () {
            onTap();
          },
          child: const CircleAvatar(
            radius: 12,
            backgroundColor: Colors.red,
            child: Center(
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
