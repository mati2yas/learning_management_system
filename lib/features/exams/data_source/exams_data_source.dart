import 'dart:math';

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
                title: "2012",
                questions: [
                  ...mathChapterOne,
                  ...mathChapterTwo,
                ],
                grades: [
                  ExamGrade(
                    id: "10",
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwo,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: "11",
                    title: "Grade 11",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwo,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: "12",
                    title: "Grade 12",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwo,
                      ),
                    ],
                  ),
                ],
              ),
              ExamYear(
                title: "2013",
                questions: [
                  ...mathChapterOne,
                  ...mathChapterTwo,
                ],
                grades: [
                  ExamGrade(
                    id: "10",
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwo,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: "11",
                    title: "Grade 11",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwo,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: "12",
                    title: "Grade 12",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Relations And Functions",
                        questions: mathChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: mathChapterTwo,
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
                title: "2012",
                questions: [
                  ...chemistryChapterOne,
                  ...chemistryChapterTwo,
                ],
                grades: [
                  ExamGrade(
                    id: "10",
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwo,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: "11",
                    title: "Grade 11",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwo,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: "12",
                    title: "Grade 12",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwo,
                      ),
                    ],
                  ),
                ],
              ),
              ExamYear(
                title: "2013",
                questions: [
                  ...chemistryChapterOne,
                  ...chemistryChapterTwo,
                ],
                grades: [
                  ExamGrade(
                    id: "10",
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwo,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: "11",
                    title: "Grade 11",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwo,
                      ),
                    ],
                  ),
                  ExamGrade(
                    id: "12",
                    title: "Grade 12",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Chemical Reactions and Stochiometry",
                        questions: chemistryChapterOne,
                      ),
                      ExamChapter(
                        id: 2,
                        title: "Polynomial Functions",
                        questions: chemistryChapterTwo,
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

  // List<Exam> fetchExams() {
  //   return [
  //     Exam(
  //       title: "Mathematics Matric Exam",
  //       examType: ExamType.matric,
  //       courses: [
  //         ExamCourse(
  //           id: "1",
  //           title: "Mathematics",
  //           years: [
  //             ExamYear(
  //               title: "2012",
  //               questions: [
  //                 Question(
  //                   sequenceOrder: 1,
  //                   question: "If 3x+5=20, what is the value of x?",
  //                   options: ["3", "5", "6", "7"],
  //                   answer: "5",
  //                   explanation: "simple substition",
  //                   image: "web_design.png",
  //                 ),
  //                 Question(
  //                   sequenceOrder: 1,
  //                   question:
  //                       "In a triangle, the sum of two angles is 90∘, and the third angle is 60∘. What type of triangle is this?",
  //                   options: [
  //                     "Acute-Agled Triangle",
  //                     "Righ-Angled Triangle",
  //                     "Obtuse-Angled Triangle",
  //                     "Isosceles Triangle"
  //                   ],
  //                   answer: "Acute Angled Triangle",
  //                   explanation: "Acute Agled triangle",
  //                 ),
  //                 Question(
  //                   sequenceOrder: 3,
  //                   question: "If 3x+5=20, what is the value of x?",
  //                   options: ["3", "5", "6", "7"],
  //                   answer: "5",
  //                   explanation: "simple substition",
  //                   image: "web_design.png",
  //                 ),
  //                 Question(
  //                   sequenceOrder: 2,
  //                   question: "If 3x+5=20, what is the value of x?",
  //                   options: ["3", "5", "6", "7"],
  //                   answer: "5",
  //                   explanation: "simple substition",
  //                 ),
  //               ],
  //               grades: [
  //                 ExamGrade(
  //                   id: "0",
  //                   title: "Grade 9",
  //                   chapters: generateChapters(3),
  //                 ),
  //                 ExamGrade(
  //                   id: "1",
  //                   title: "Grade 10",
  //                   chapters: [
  //                     ExamChapter(
  //                       id: 1,
  //                       title: "Chapter 1",
  //                       questions: [
  //                         Question(
  //                           sequenceOrder: 1,
  //                           question: "If 3x+5=20, what is the value of x?",
  //                           options: ["3", "5", "6", "7"],
  //                           answer: "5",
  //                           explanation: "simple substition",
  //                           image: "web_design.png",
  //                         ),
  //                         Question(
  //                           sequenceOrder: 1,
  //                           question:
  //                               "In a triangle, the sum of two angles is 90∘, and the third angle is 60∘. What type of triangle is this?",
  //                           options: [
  //                             "Acute-Agled Triangle",
  //                             "Righ-Angled Triangle",
  //                             "Obtuse-Angled Triangle",
  //                             "Isosceles Triangle"
  //                           ],
  //                           answer: "Acute Angled Triangle",
  //                           explanation: "Acute Agled triangle",
  //                         ),
  //                         Question(
  //                           sequenceOrder: 2,
  //                           question: "If 3x+5=20, what is the value of x?",
  //                           options: ["3", "5", "6", "7"],
  //                           answer: "5",
  //                           explanation: "simple substition",
  //                           image: "web_design.png",
  //                         ),
  //                         Question(
  //                           sequenceOrder: 3,
  //                           question: "If 3x+5=20, what is the value of x?",
  //                           options: ["3", "5", "6", "7"],
  //                           answer: "5",
  //                           explanation: "simple substition",
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 ExamGrade(
  //                   id: "2",
  //                   title: "Grade 11",
  //                   chapters: [
  //                     ExamChapter(
  //                       id: 1,
  //                       title: "Chapter 1",
  //                       questions: [
  //                         Question(
  //                           sequenceOrder: 1,
  //                           question: "If 3x+5=20, what is the value of x?",
  //                           options: ["3", "5", "6", "7"],
  //                           answer: "5",
  //                           explanation: "simple substition",
  //                           image: "web_design.png",
  //                         ),
  //                         Question(
  //                           sequenceOrder: 1,
  //                           question:
  //                               "In a triangle, the sum of two angles is 90∘, and the third angle is 60∘. What type of triangle is this?",
  //                           options: [
  //                             "Acute-Agled Triangle",
  //                             "Righ-Angled Triangle",
  //                             "Obtuse-Angled Triangle",
  //                             "Isosceles Triangle"
  //                           ],
  //                           answer: "Acute Angled Triangle",
  //                           explanation: "Acute Agled triangle",
  //                         ),
  //                         Question(
  //                           sequenceOrder: 2,
  //                           question: "If 3x+5=20, what is the value of x?",
  //                           options: ["3", "5", "6", "7"],
  //                           answer: "5",
  //                           explanation: "simple substition",
  //                           image: "web_design.png",
  //                         ),
  //                         Question(
  //                           sequenceOrder: 3,
  //                           question: "If 3x+5=20, what is the value of x?",
  //                           options: ["3", "5", "6", "7"],
  //                           answer: "5",
  //                           explanation: "simple substition",
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 ExamGrade(
  //                   id: "3",
  //                   title: "Grade 12",
  //                   chapters: [
  //                     ExamChapter(
  //                       id: 1,
  //                       title: "Chapter 1",
  //                       questions: [
  //                         Question(
  //                           sequenceOrder: 1,
  //                           question: "If 3x+5=20, what is the value of x?",
  //                           options: ["3", "5", "6", "7"],
  //                           answer: "5",
  //                           explanation: "simple substition",
  //                           image: "web_design.png",
  //                         ),
  //                         Question(
  //                           sequenceOrder: 1,
  //                           question:
  //                               "In a triangle, the sum of two angles is 90∘, and the third angle is 60∘. What type of triangle is this?",
  //                           options: [
  //                             "Acute-Agled Triangle",
  //                             "Righ-Angled Triangle",
  //                             "Obtuse-Angled Triangle",
  //                             "Isosceles Triangle"
  //                           ],
  //                           answer: "Acute Angled Triangle",
  //                           explanation: "Acute Agled triangle",
  //                         ),
  //                         Question(
  //                           sequenceOrder: 2,
  //                           question: "If 3x+5=20, what is the value of x?",
  //                           options: ["3", "5", "6", "7"],
  //                           answer: "5",
  //                           explanation: "simple substition",
  //                           image: "web_design.png",
  //                         ),
  //                         Question(
  //                           sequenceOrder: 3,
  //                           question: "If 3x+5=20, what is the value of x?",
  //                           options: ["3", "5", "6", "7"],
  //                           answer: "5",
  //                           explanation: "simple substition",
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),

  //     // CoC Exams
  //     Exam(
  //       title: "Accounting CoC Exam",
  //       examType: ExamType.coc,
  //       courses: [
  //         ExamCourse(
  //           id: "3",
  //           title: "Accounting",
  //           years: [
  //             ExamYear(
  //               title: "2012",
  //               questions: generateQuestions(5),
  //               grades: [],
  //             ),
  //             ExamYear(
  //               title: "2013",
  //               questions: generateQuestions(5),
  //               grades: [],
  //             ),
  //             ExamYear(
  //               title: "2014",
  //               questions: generateQuestions(5),
  //               grades: [],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //     Exam(
  //       title: "Nursing CoC Exam",
  //       examType: ExamType.coc,
  //       courses: [
  //         ExamCourse(
  //           id: "4",
  //           title: "Nursing",
  //           years: [
  //             ExamYear(
  //               title: "2012",
  //               questions: generateQuestions(5),
  //               grades: [],
  //             ),
  //             ExamYear(
  //               title: "2013",
  //               questions: generateQuestions(5),
  //               grades: [],
  //             ),
  //             ExamYear(
  //               title: "2014",
  //               questions: generateQuestions(5),
  //               grades: [],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //     Exam(
  //       title: "NGAT",
  //       examType: ExamType.coc,
  //       courses: [
  //         ExamCourse(
  //           id: "5",
  //           title: "Computer Science",
  //           years: [
  //             ExamYear(
  //               title: "2012",
  //               questions: generateQuestions(5),
  //               grades: [],
  //             ),
  //             ExamYear(
  //               title: "2013",
  //               questions: generateQuestions(5),
  //               grades: [],
  //             ),
  //             ExamYear(
  //               title: "2014",
  //               questions: generateQuestions(5),
  //               grades: [],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   ];
  // }

  List<ExamChapter> generateChapters(int count) {
    return List.generate(count, (index) {
      return ExamChapter(
        id: index + 1,
        title: "Chapter ${index + 1}",
        questions: generateQuestions(5),
      );
    });
  }

  List<ExamGrade> generateMatricGrades() {
    return [
      ExamGrade(
        id: Random().nextInt(100).toString(),
        title: "Grade 9",
        chapters: generateChapters(3),
      ),
      ExamGrade(
        id: Random().nextInt(100).toString(),
        title: "Grade 10",
        chapters: generateChapters(3),
      ),
      ExamGrade(
        id: Random().nextInt(100).toString(),
        title: "Grade 11",
        chapters: generateChapters(3),
      ),
      ExamGrade(
        id: Random().nextInt(100).toString(),
        title: "Grade 12",
        chapters: generateChapters(3),
      ),
    ];
  }

  List<Question> generateQuestions(int count) {
    return List.generate(count, (index) {
      return Question(
        sequenceOrder: index + 1,
        question: "Question ${index + 1}?",
        options: ["Option A", "Option B", "Option C", "Option D"],
        answer: "Option A",
        explanation:
            "Explanation for question ${index + 1}. the reason this is so long is case we need to make sure that we make it as long as possible so that we can test the limits.",
      );
    });
  }
}
