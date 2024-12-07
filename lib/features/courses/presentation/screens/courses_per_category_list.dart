import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/course_card.dart';

import '../../model/categories_sub_categories.dart';

class CoursesPerCategoryListPage extends ConsumerStatefulWidget {
  final CourseCategory category;

  const CoursesPerCategoryListPage({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<CoursesPerCategoryListPage> createState() =>
      _CourseDetailPageState();
}

class _CourseDetailPageState extends ConsumerState<CoursesPerCategoryListPage>
    with TickerProviderStateMixin {
  String? dropDownValue;
  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    var category = widget.category;
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

    // Determine dropdown items dynamically
    List<String> dropdownItems = [];

    if (category.categoryType == CategoryType.highSchool &&
        [2, 3].contains(tabController.index)) {
      dropdownItems = ["Natural", "Social"];
    } else if (category.categoryType == CategoryType.university) {
      dropdownItems = category.grades
          .where((grade) => grade.subCategories?.isNotEmpty ?? false)
          .expand((grade) => grade.subCategories!.map((sub) => sub.name))
          .toList();
    }

    return Scaffold(
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
                      if (dropdownItems.isNotEmpty)
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: dropDownValue,
                          items: dropdownItems
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              dropDownValue = value!;
                            });
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  tabs: category.grades.map((grd) => Text(grd.name)).toList(),
                  controller: tabController,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TabBarView(
          controller: tabController,
          children: category.grades.map((grade) {
            final selectedCourses = (category.categoryType ==
                        CategoryType.university ||
                    (category.categoryType == CategoryType.highSchool &&
                        ["11th Grade", "12th Grade"].contains(grade.name)))
                ? grade.courses
                    .where(
                      (course) => course.streamOrDepartment == dropDownValue,
                    )
                    .toList()
                : grade.courses;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: selectedCourses.length,
              itemBuilder: (_, index) {
                return CourseCard(course: selectedCourses[index]);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose(); // Dispose of TabController
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Initialize TabController
    tabController =
        TabController(length: widget.category.grades.length, vsync: this);

    // Add listener to detect tab changes
    tabController.addListener(() {
      setState(() {
        // Ensure dropDownValue is valid when tab index changes
        updateDropdownValue();
      });
    });

    // Initialize dropDownValue with the first valid item
    updateDropdownValue();
  }

  /// Updates the dropDownValue based on the current tab index and category type
  void updateDropdownValue() {
    final category = widget.category;

    // Determine dropdown items
    List<String> dropdownItems = [];

    if (category.categoryType == CategoryType.highSchool &&
        [2, 3].contains(tabController.index)) {
      dropdownItems = ["Natural", "Social"];
    } else if (category.categoryType == CategoryType.university) {
      dropdownItems = category.grades
          .where((grade) => grade.subCategories?.isNotEmpty ?? false)
          .expand((grade) => grade.subCategories!.map((sub) => sub.name))
          .toList();
    }

    // Update dropDownValue
    if (dropDownValue == null || !dropdownItems.contains(dropDownValue)) {
      dropDownValue = dropdownItems.isNotEmpty ? dropdownItems.first : null;
    }
  }
}
