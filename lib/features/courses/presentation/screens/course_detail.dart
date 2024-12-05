import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/course_card.dart';
import 'package:lms_system/core/constants/colors.dart';

import '../../model/categories_sub_categories.dart';

class CourseDetailPage extends ConsumerStatefulWidget {
  final CourseCategory category;

  const CourseDetailPage({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends ConsumerState<CourseDetailPage> {
  String? dropDownValue; // Move dropDownValue to the state class

  @override
  Widget build(BuildContext context) {
    var category = widget.category;
    print("{name: ${category.name}, type: ${category.categoryType.name}}");
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

    return DefaultTabController(
      length: category.grades.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.name),
          centerTitle: true,
          elevation: 3,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size(size.width, 120),
            child: SizedBox(
              width: size.width,
              height: 140,
              child: Column(
                children: [
                  SearchBar(
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    constraints: BoxConstraints.tightFor(
                      width: size.width * 0.8,
                      height: 40,
                    ),
                    leading: const Icon(Icons.search),
                    hintText: "Search Course",
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: size.width * 0.85,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Categories",
                          style: textTh.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // remember university and lower grade
                        // categories have logic associated with
                        // the drop down, but also high-school
                        // for 11th and 12th also has logic for dropdown
                        // and all categories except lower grade have
                        // logic associated with tab-bar view.

                        if (category.categoryType == CategoryType.highSchool &&
                            ["11th", "12th"].contains(category.name))
                          DropdownButton<String>(
                            dropdownColor: AppColors.mainBlue,
                            value: dropDownValue,
                            items: ["Natural", "Social"]
                                .map(
                                  (stream) => DropdownMenuItem(
                                    value: stream,
                                    child: Text(stream),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                dropDownValue = value!;
                              });
                            },
                          )
                        else if (category.categoryType ==
                            CategoryType.university)
                          DropdownButton<String>(
                            dropdownColor: AppColors.mainBlue,
                            value: dropDownValue,
                            items: [
                              "Computer Science",
                              "Software Engineering",
                              "Electrical Engineering"
                            ]
                                .map(
                                  (field) => DropdownMenuItem(
                                    value: field,
                                    child: Text(field),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                dropDownValue = value!;
                              });
                            },
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  TabBar(
                    tabs: category.grades.map((ct) => Text(ct.name)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            // remember university and lower grade
            // categories have logic associated with
            // the drop down, but also high-school
            // for 11th and 12th also has logic for dropdown
            // and all categories except lower grade have
            // logic associated with tab-bar view.
            // for the university the drop down is the option of
            // its departments, whereas for lower grades the
            // dropdown is the option of its grades.
            child: TabBarView(
              children: category.grades.map((grade) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: category.categoryType == CategoryType.university ||
                          (category.categoryType == CategoryType.highSchool &&
                              ["11th", "12th"].contains(grade.name))
                      ? category.grades
                          .firstWhere((grade) => grade.name == dropDownValue)
                          .courses
                          .length
                      : grade.courses.length,
                  itemBuilder: (_, index) {
                    if (category.categoryType == CategoryType.university) {
                      final selectedGrade = category.grades.firstWhere(
                        (grade) => grade.name == dropDownValue,
                      );
                      return CourseCard(
                        course: selectedGrade.courses[index],
                      );
                    }

                    return CourseCard(
                      course: grade.courses[index],
                    );
                  },
                );
              }).toList(),
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize dropDownValue with the first grade name if grades are available
    if (widget.category.grades.isNotEmpty) {
      dropDownValue = widget.category.grades[0].name;
    }
  }
}
