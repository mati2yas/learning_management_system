// class CoursePage extends StatefulWidget {
//   const CoursePage({super.key});

//   @override
//   State<CoursePage> createState() => _CoursePageState();
// }

// class _CoursePageState extends State<CoursePage> {
//   List<Course> courses = [
//     Course(
//       title: "Web Design",
//       desc: "web design",
//       topics: 21,
//       saves: 7,
//       image: "web_design.png",
//       saved: false,
//       subscribed: true,
//     ),
//     Course(
//       title: "Marketing",
//       desc: "web design",
//       topics: 21,
//       saves: 7,
//       image: "marketing_course.png",
//       saved: true,
//       subscribed: false,
//     ),
//     Course(
//       title: "Applied Mathematics",
//       desc: "web design",
//       topics: 21,
//       saves: 7,
//       image: "applied_math.png",
//       saved: true,
//       subscribed: true,
//     ),
//     Course(
//       title: "Accounting",
//       desc: "web design",
//       topics: 21,
//       saves: 7,
//       image: "accounting_course.png",
//       saved: false,
//       subscribed: true,
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     var textTh = Theme.of(context).textTheme;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Courses"),
//         centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: Size(
//             MediaQuery.of(context).size.width,
//             70,
//           ),
//           child: Container(
//             color: Colors.white,
//             child: SearchBar(
//               //shape: WidgetStatePropertyAll<OutlinedBorder>(OutlineInputBorder()),
//               backgroundColor: const WidgetStatePropertyAll(Colors.white),
//               constraints: BoxConstraints.tightFor(
//                 width: size.width * 0.8,
//                 height: 40,
//               ),
//               leading: const Icon(Icons.search),
//               hintText: "Search Course",
//             ),
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(12),
//         children: [
//           Text(
//             "Categories",
//             style: textTh.bodyLarge!.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 15),
//           SizedBox(
//             height: 266,
//             width: double.infinity,
//             child: GridView(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 mainAxisExtent: 125,
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 15,
//               ),
//               children: const [
//                 CategoryShow(
//                   label: "For High School",
//                   image: "high_school.png",
//                 ),
//                 CategoryShow(
//                   label: "For University",
//                   image: "university.png",
//                 ),
//                 CategoryShow(
//                   label: "For Lower Grades",
//                   image: "lower_grades.png",
//                 ),
//                 CategoryShow(
//                   label: "For High School",
//                   image: "high_school.png",
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 25),
//           Text(
//             "Categories",
//             style: textTh.bodyLarge!.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 15),
//           SizedBox(
//             height: size.height * 0.5,
//             width: double.infinity,
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 10,
//                 crossAxisSpacing: 10,
//               ),
//               itemBuilder: (_, index) {
//                 return CourseCard(course: courses[index]);
//               },
//               itemCount: courses.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/course_card.dart';

import '../../../../core/app_router.dart';
import '../../provider/courses_provider.dart';
import '../widgets/category_show.dart';

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(courseProvider);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Courses"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            70,
          ),
          child: Container(
            color: Colors.white,
            child: SearchBar(
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              constraints: BoxConstraints.tightFor(
                width: size.width * 0.8,
                height: 40,
              ),
              leading: const Icon(Icons.search),
              hintText: "Search Course",
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            "Categories",
            style: textTh.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 266,
            width: double.infinity,
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 125,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 15,
              ),
              children: const [
                CategoryShow(
                  label: "For High School",
                  image: "high_school.png",
                ),
                CategoryShow(
                  label: "For University",
                  image: "university.png",
                ),
                CategoryShow(
                  label: "For Lower Grades",
                  image: "lower_grades.png",
                ),
                CategoryShow(
                  label: "For High School",
                  image: "high_school.png",
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Categories",
            style: textTh.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: size.height * 0.5,
            width: double.infinity,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Routes.courseDetails,
                      arguments: courses[index],
                    );
                  },
                  child: CourseCard(
                    course: courses[index],
                    onBookmark: () {
                      ref
                          .read(courseProvider.notifier)
                          .toggleSaved(courses[index]);
                    },
                  ),
                );
              },
              itemCount: courses.length,
            ),
          ),
        ],
      ),
    );
  }
}
