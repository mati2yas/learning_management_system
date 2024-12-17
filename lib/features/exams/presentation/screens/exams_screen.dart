import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/exams/provider/exams_provider.dart';
import 'package:lms_system/features/shared_course/presentation/widgets/custom_search_bar.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ExamsScreen extends ConsumerStatefulWidget {
  const ExamsScreen({
    super.key,
  });

  @override
  ConsumerState<ExamsScreen> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends ConsumerState<ExamsScreen>
    with TickerProviderStateMixin {
  String yearDropDownValue = "", courseDropDownValue = "";
  late TabController tabController;

  List<String> yearDropdowns = [], courseDropdowns = [];
  List<String> tabsList = ["Matric", "COC", "NGAT"];
  String currentTab = "Matric";
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageNavController = ref.read(pageNavigationProvider.notifier);
    final examsController = ref.watch(examsProvider.notifier);
    final exams = ref.watch(examsProvider);

    // Determine dropdown items dynamically

    print("course dropdowns: ${courseDropdowns.join(",")}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam Simulator"),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(size.width, 116),
          child: Container(
            width: size.width,
            color: Colors.white,
            height: 116,
            child: Column(
              children: [
                CustomSearchBar(hintText: "Search Courses", size: size),
                const SizedBox(height: 5),
                SizedBox(
                  width: size.width * 0.9,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: yearDropDownValue == ""
                            ? yearDropdowns[0]
                            : yearDropDownValue,
                        items: yearDropdowns
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            yearDropDownValue = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                if (tabController.length != 0)
                  TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    tabs: tabsList
                        .map((ex) => Text(
                              ex,
                              style: textTh.titleMedium,
                            ))
                        .toList(),
                    controller: tabController,
                  ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: (tabController.length == 0 ||
                tabsList.isEmpty ||
                yearDropdowns.isEmpty)
            ? const Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: AppColors.mainBlue,
                  ),
                ),
              )
            : TabBarView(
                controller: tabController,
                children: exams.map((exam) {
                  final selectedCourses = exams.where((exam) {
                    return exam.examType.name == currentTab.toLowerCase() &&
                        (yearDropDownValue.isEmpty ||
                            exam.course.years.any(
                                (year) => year.title == yearDropDownValue)) &&
                        (courseDropDownValue.isEmpty ||
                            exam.course.title == courseDropDownValue);
                  }).toList();

                  print("selected courses len: ${selectedCourses.length}");

                  return ListView.separated(
                    itemCount: selectedCourses.length,
                    itemBuilder: (_, index) {
                      final currentExam = selectedCourses[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        child: ListTile(
                          onTap: () {},
                          title: Text(currentExam.title),
                          subtitle: Text(currentExam.course.title),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              fixedSize: const Size(90, 27),
                            ),
                            onPressed: () {
                              var examData = {
                                "exam year": exam.course.years[0].title,
                                "exam title": exam.course.title,
                                "questions": exam.course.years[0].questions,
                              };

                              pageNavController.navigatePage(
                                6,
                                arguments: examData,
                              );
                            },
                            child: const Text(
                              "Retake",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) => const SizedBox(height: 15),
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

    // the logic is inside this cause ref cannot be called
    // in initstate since initState runs before the widgets
    // injected into the riverpod scope, and that causes
    // an error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final exams = ref.read(examsProvider);

      // Extract unique years and tabs
      final uniqueYears = <String>{};
      final uniqueCourses = <String>{};
      for (var exam in exams) {
        uniqueCourses.add(exam.course.title);
        for (var year in exam.course.years) {
          uniqueYears.add(year.title);
        }
      }

      setState(() {
        yearDropdowns = uniqueYears.toList();
        courseDropdowns = uniqueCourses.toList();
        var tabsSet = exams.map((e) => e.examType.name).toSet();
        print(tabsSet.join(","));
        //tabsList = List.from(tabsSet);

        // Initialize the TabController
        tabController = TabController(
          length: tabsList.length,
          vsync: this,
        );

        currentTab = tabsList[0];

        // Add listener to TabController
        tabController.addListener(() {
          setState(() {
            currentTab = tabsList[tabController.index];
            yearDropDownValue = "";
            courseDropDownValue = "";
          });
        });
      });
    });
  }
}
