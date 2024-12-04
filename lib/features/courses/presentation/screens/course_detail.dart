import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/categories_sub_categories.dart';

class CourseDetailPage extends ConsumerWidget {
  final CourseCategory category;

  const CourseDetailPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final courseNotifier = ref.read(courseProvider.notifier);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: textTh.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.8,
              width: double.infinity,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (_, index) {
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
