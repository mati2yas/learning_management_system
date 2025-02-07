import 'package:lms_system/features/exams/model/exams_model.dart';

part 'questions_data_source.dart';

class ExamsDataSource {
  List<Exam> fetchExams() {
    return [
      Exam(
        title: "Matric",
        examType: ExamType.matric,
        courses: [
          ExamCourse(
            id: "1",
            title: "Mathematics",
            years: [
              ExamYear(
                id: 0,
                courseId: 1,
                title: "2012",
                questions: [
                  ...mathChapterOneGrade10,
                  ...mathChapterTwoGrade10,
                ],
                grades: [
                  ExamGrade(
                    id: 10,
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwoGrade10,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: 11,
                    title: "Grade 11",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwoGrade10,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: 12,
                    title: "Grade 12",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwoGrade10,
                      ),
                    ],
                  ),
                ],
              ),
              ExamYear(
                id: 1,
                courseId: 2,
                title: "2013",
                questions: [
                  ...mathChapterOneGrade10,
                  ...mathChapterTwoGrade10,
                ],
                grades: [
                  ExamGrade(
                    id: 10,
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwoGrade10,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: 11,
                    title: "Grade 11",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwoGrade10,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: 12,
                    title: "Grade 12",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwoGrade10,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ExamCourse(
            id: "2",
            title: "Chemistry",
            years: [
              ExamYear(
                id: 2,
                courseId: 3,
                title: "2012",
                questions: [
                  ...chemistryChapterOneGrade10,
                  ...chemistryChapterTwoGrade10,
                ],
                grades: [
                  ExamGrade(
                    id: 10,
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwoGrade10,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: 11,
                    title: "Grade 11",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwoGrade10,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: 12,
                    title: "Grade 12",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwoGrade10,
                      ),
                    ],
                  ),
                ],
              ),
              ExamYear(
                id: 3,
                courseId: 4,
                title: "2013",
                questions: [
                  ...chemistryChapterOneGrade10,
                  ...chemistryChapterTwoGrade10,
                ],
                grades: [
                  ExamGrade(
                    id: 10,
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwoGrade10,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: 11,
                    title: "Grade 11",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwoGrade10,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: 12,
                    title: "Grade 12",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOneGrade10,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwoGrade10,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
