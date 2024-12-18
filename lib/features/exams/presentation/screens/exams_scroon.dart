// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lms_system/core/constants/colors.dart';
// import 'package:lms_system/features/exams/presentation/widgets/exam_courses_list.dart';
// import 'package:lms_system/features/exams/provider/exams_provider.dart';
// import 'package:lms_system/features/shared_course/presentation/widgets/custom_search_bar.dart';
// import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

// class ExamsScreen extends ConsumerStatefulWidget {
//   const ExamsScreen({
//     super.key,
//   });

//   @override
//   ConsumerState<ExamsScreen> createState() => _ExamsScreenState();
// }

// class _ExamsScreenState extends ConsumerState<ExamsScreen>
//     with TickerProviderStateMixin {
//   String yearDropDownValue = "", courseDropDownValue = "";
//   late TabController tabController;

//   List<String> tabsList = ["Matric", "COC", "NGAT"];
//   String currentTab = "Matric";
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     var textTh = Theme.of(context).textTheme;
//     final pageNavController = ref.read(pageNavigationProvider.notifier);
//     final examsController = ref.watch(examsProvider.notifier);
//     final exams = ref.watch(examsProvider);

//     // Determine dropdown items dynamically

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Exam Simulator"),
//         centerTitle: true,
//         elevation: 5,
//         shadowColor: Colors.black87,
//         surfaceTintColor: Colors.transparent,
//         backgroundColor: Colors.white,
//         bottom: PreferredSize(
//           preferredSize: Size(size.width, 116),
//           child: Container(
//             width: size.width,
//             color: Colors.white,
//             height: 116,
//             child: Column(
//               children: [
//                 CustomSearchBar(hintText: "Search Courses", size: size),
//                 const SizedBox(height: 5),
//                 const SizedBox(height: 5),
//                 if (tabController.length != 0)
//                   TabBar(
//                     tabAlignment: TabAlignment.start,
//                     isScrollable: true,
//                     tabs: tabsList
//                         .map((ex) => Text(
//                               ex,
//                               style: textTh.titleMedium,
//                             ))
//                         .toList(),
//                     controller: tabController,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: (tabController.length == 0 || tabsList.isEmpty)
//             ? const Center(
//                 child: SizedBox(
//                   height: 40,
//                   width: 40,
//                   child: CircularProgressIndicator(
//                     color: AppColors.mainBlue,
//                   ),
//                 ),
//               )
//             : TabBarView(
//                 controller: tabController,
//                 children: const [
//                   //ExamCoursesList(courses: , parentSize: parentSize, examType: examType)
//                 ],
//               ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     tabController.dispose(); // Dispose of TabController
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();

//     // the logic is inside this cause ref cannot be called
//     // in initstate since initState runs before the widgets
//     // injected into the riverpod scope, and that causes
//     // an error
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final exams = ref.read(examsProvider);

//       // Extract unique years and tabs
//       final Set uniqueYears = <String>{};
//       final Set uniqueCourses = <String>{};
//       for (var exam in exams) {
//         uniqueCourses.add(exam.course.title);
//         for (var year in exam.course.years) {
//           uniqueYears.add(year.title);
//         }
//       }

//       setState(() {
//         var tabsSet = exams.map((e) => e.examType.name).toSet();
//         print(tabsSet.join(","));
//         //tabsList = List.from(tabsSet);
//         // Initialize the TabController
//         tabController = TabController(
//           length: tabsList.length,
//           vsync: this,
//         );

//         currentTab = tabsList[0];

//         // Add listener to TabController
//         tabController.addListener(() {
//           setState(() {
//             currentTab = tabsList[tabController.index];
//             yearDropDownValue = "";
//             courseDropDownValue = "";
//           });
//         });
//       });
//     });
//   }
// }
