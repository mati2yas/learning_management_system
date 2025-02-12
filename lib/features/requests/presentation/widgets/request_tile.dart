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
          child: Image.network(
            height: 60,
            width: double.infinity,
            "${course.image}.jpg", //?? "",
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Image.asset(
                fit: BoxFit.cover,
                "assets/images/applied_math.png",
                height: 60,
                width: double.infinity,
              );
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              // Show an error widget if the image failed to load

              return Image.asset(
                  height: 60,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  "assets/images/applied_math.png");
            },
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
