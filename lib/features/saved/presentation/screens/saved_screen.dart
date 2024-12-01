import 'package:flutter/material.dart';
import 'package:lms_system/features/shared_course/model/shared_course_model.dart';

import '../../../shared_course/model/chapter.dart';
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
          title: const Text("Saved"),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              100,
            ),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SearchBar(
                    //shape: WidgetStatePropertyAll<OutlinedBorder>(OutlineInputBorder()),
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    constraints: BoxConstraints.tightFor(
                      width: size.width * 0.8,
                      height: 40,
                    ),
                    leading: const Icon(Icons.search),
                    hintText: "Search Course",
                  ),
                  const SizedBox(height: 10),
                  TabBar(
                    tabs: categories.map((e) => Tab(text: e)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: List.generate(
            4,
            (index) => CoursesListWidget(
              courses: courses,
              textTh: textTh,
            ),
          ),
        ),
      ),
    );
  }
}
