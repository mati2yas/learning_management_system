import 'package:flutter/material.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_search_bar.dart';
import 'package:lms_system/requests/presentation/screens/requests_screen.dart';

import '../../../shared/model/chapter.dart';
import '../widgets/courses_list.dart';

class SavedCoursesPage extends StatefulWidget {
  const SavedCoursesPage({super.key});

  @override
  State<SavedCoursesPage> createState() => _SavedCoursesPageState();
}

class _SavedCoursesPageState extends State<SavedCoursesPage> {
  List<String> categories = ["All", "University", "High School", "Lower Grade"];
  List<Course> courses = [
    Course(
      title: "Marketing Course",
      desc: "Marketing Course",
      topics: 12,
      saves: 15,
      likes: 12,
      price: {
        SubscriptionType.oneMonth: 30.0,
        SubscriptionType.threeMonths: 90.0,
        SubscriptionType.sixMonths: 120.0,
        SubscriptionType.yearly: 3600.0,
      },
      liked: false,
      image: "marketing_course.png",
      progress: 13,
      chapters: [
        Chapter(
          name: "Chapter 2",
          title: "Introduction to Web Design",
          videos: [
            Video(title: "What is Web Design?", duration: "10:23"),
            Video(title: "Tools for Web Design", duration: "15:45"),
          ],
        ),
        Chapter(
          name: "Chapter 2",
          title: "HTML Basics",
          videos: [
            Video(title: "HTML Structure", duration: "12:34"),
            Video(title: "HTML Tags", duration: "18:50"),
          ],
        ),
      ],
    ),
    Course(
      title: "Web Design",
      desc: "Marketing Course",
      topics: 12,
      saves: 15,
      likes: 8,
      price: {
        SubscriptionType.oneMonth: 82.0,
        SubscriptionType.threeMonths: 246.0,
        SubscriptionType.sixMonths: 492.0,
        SubscriptionType.yearly: 984.0,
      },
      liked: false,
      image: "web_design.png",
      progress: 28,
      chapters: [
        Chapter(
          name: "Chapter 2",
          title: "Introduction to Web Design",
          videos: [
            Video(title: "What is Web Design?", duration: "10:23"),
            Video(title: "Tools for Web Design", duration: "15:45"),
          ],
        ),
        Chapter(
          name: "Chapter 2",
          title: "HTML Basics",
          videos: [
            Video(title: "HTML Structure", duration: "12:34"),
            Video(title: "HTML Tags", duration: "18:50"),
          ],
        ),
      ],
    ),
    Course(
      title: "Marketing Course",
      desc: "Marketing Course",
      topics: 12,
      saves: 15,
      likes: 4,
      price: {
        SubscriptionType.oneMonth: 72.0,
        SubscriptionType.threeMonths: 216.0,
        SubscriptionType.sixMonths: 432.0,
        SubscriptionType.yearly: 864.0,
      },
      liked: true,
      image: "marketing_course.png",
      progress: 13,
      chapters: [
        Chapter(
          name: "Chapter 2",
          title: "Introduction to Web Design",
          videos: [
            Video(title: "What is Web Design?", duration: "10:23"),
            Video(title: "Tools for Web Design", duration: "15:45"),
          ],
        ),
        Chapter(
          name: "Chapter 2",
          title: "HTML Basics",
          videos: [
            Video(title: "HTML Structure", duration: "12:34"),
            Video(title: "HTML Tags", duration: "18:50"),
          ],
        ),
      ],
    ),
    Course(
      title: "Marketing Course",
      desc: "Marketing Course",
      topics: 12,
      saves: 15,
      likes: 2,
      liked: false,
      price: {
        SubscriptionType.oneMonth: 49.0,
        SubscriptionType.threeMonths: 147.0,
        SubscriptionType.sixMonths: 294.0,
        SubscriptionType.yearly: 588.0,
      },
      image: "marketing_course.png",
      progress: 13,
      chapters: [
        Chapter(
          name: "Chapter 2",
          title: "Introduction to Web Design",
          videos: [
            Video(title: "What is Web Design?", duration: "10:23"),
            Video(title: "Tools for Web Design", duration: "15:45"),
          ],
        ),
        Chapter(
          name: "Chapter 2",
          title: "HTML Basics",
          videos: [
            Video(title: "HTML Structure", duration: "12:34"),
            Video(title: "HTML Tags", duration: "18:50"),
          ],
        ),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Saved Courses"),
          centerTitle: true,
          shadowColor: Colors.black87,
          surfaceTintColor: Colors.transparent,
          elevation: 4,
          bottom: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              56,
            ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 5),
              color: Colors.white,
              child: CustomSearchBar(hintText: "Search Courses", size: size),
            ),
          ),
        ),
        body: CoursesListWidget(
          courses: courses,
          textTh: textTh,
        ),
      ),
    );
  }
}
