import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ExamGradeFilter extends ConsumerStatefulWidget {
  const ExamGradeFilter({super.key});

  @override
  ConsumerState<ExamGradeFilter> createState() => _ExamGradeFilterState();
}

class _ExamGradeFilterState extends ConsumerState<ExamGradeFilter>
    with TickerProviderStateMixin {
  bool initializingPage = false;
  late TabController tabController;
  ExamYear year = ExamYear(title: "", grades: []);
  Map<String, dynamic> examData = {};
  List<String> tabsList = [], gradesDropDown = [];
  String currentTab = "", gradeDropDownValue = "";

  @override
  Widget build(BuildContext context) {
    print("Current Tab: $currentTab");
    print("exam titleee: ${examData["exam title"]}");
    final pageController = ref.read(pageNavigationProvider.notifier);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pageController.navigatePage(3);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(examData["exam title"] ?? "title"),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(size.width, 36),
          child: Container(
            width: size.width,
            color: Colors.white,
            height: 36,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
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
      ),
      body: initializingPage
          ? const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: AppColors.mainBlue,
                  strokeWidth: 5,
                ),
              ),
            )
          : TabBarView(
              controller: tabController,
              children: tabsList.map((tabTitle) {
                // Filter the grades by the current tab
                final selectedGrade = year.grades.firstWhere(
                  (grade) => grade.title == currentTab,
                  orElse: () => ExamGrade(id: "", title: "", chapters: []),
                );

                final chapters = selectedGrade.chapters;

                return ListView.builder(
                  itemCount: chapters.length,
                  itemBuilder: (_, index) {
                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(chapters[index].title),
                        subtitle: Text(
                          "${chapters[index].questions.length} questions",
                        ),
                        trailing: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.mainBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            Map<String, dynamic> examDataNext = {
                              "exam title": examData["exam title"],
                              "exam year": year.title,
                              "questions": chapters[index].questions,
                            };
                            pageController.navigatePage(6,
                                arguments: examDataNext);
                          },
                          child: const Text("Take"),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializingPage = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pageController = ref.read(pageNavigationProvider.notifier);
      examData = pageController.getArgumentsForPage(8) as Map<String, dynamic>;

      setState(() {
        var yearVal = examData["exam year"]! as ExamYear;
        year = yearVal;
        var tabsSet = yearVal.grades.map((yr) => yr.title).toSet();
        tabsList = List.from(tabsSet);

        gradesDropDown = yearVal.grades.map((grade) => grade.title).toList();
        gradeDropDownValue = gradesDropDown.first;

        tabController = TabController(
          length: tabsList.length,
          vsync: this,
        );

        currentTab = tabsList[0];

        tabController.addListener(() {
          setState(() {
            currentTab = tabsList[tabController.index];
          });
        });
        initializingPage = false;
      });
    });
  }
}
