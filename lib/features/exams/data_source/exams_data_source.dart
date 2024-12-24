import 'dart:math';

import 'package:lms_system/features/exams/model/exams_model.dart';

class ExamsDataSource {
  List<Exam> fetchExams() {
    return [
      Exam(
        title: "Matric Mathematics Exam",
        examType: ExamType.matric,
        courses: [
          ExamCourse(
            id: "1",
            title: "Number and Quantity",
            years: [
              ExamYear(
                title: "2024",
                grades: [
                  ExamGrade(
                    id: "10",
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Number and Quantity",
                        questions: [
                          Question(
                              sequenceOrder: 1,
                              question: "Evaluate 9^(150/300).",
                              options: ["18", "9", "3", "81"],
                              answer: "3",
                              explanation:
                                  "9^(150/300) = 9^(1/2) = \u221a9 = 3."),
                          Question(
                              sequenceOrder: 2,
                              question: "Rewrite x^(1/2) in radical form.",
                              options: [
                                "\u221ax",
                                "\u221ax^2",
                                "1/\u221ax",
                                "-\u221ax"
                              ],
                              answer: "\u221ax",
                              explanation: "x^(1/2) = \u221ax."),
                          Question(
                              sequenceOrder: 3,
                              question: "Simplify completely i(7−i).",
                              options: ["7i−i^2", "1+7i", "6i", "−1+7i"],
                              answer: "1+7i",
                              explanation: "i(7−i) = 7i + 1."),
                          Question(
                              sequenceOrder: 4,
                              question:
                                  "A vector in standard form has components <3, 10>. What is the initial point?",
                              options: [
                                "(0, 0)",
                                "(3, 10)",
                                "(6, 20)",
                                "Not enough information given"
                              ],
                              answer: "(0, 0)",
                              explanation:
                                  "The vector starts at the origin (0, 0)."),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ExamCourse(
            id: "2",
            title: "Algebra",
            years: [
              ExamYear(
                title: "2024",
                grades: [
                  ExamGrade(
                    id: "10",
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Algebra",
                        questions: [
                          Question(
                              sequenceOrder: 1,
                              question:
                                  "Which expression is equivalent to 9x^2 – 16y^2?",
                              options: [
                                "(3x – 4y) (3x – 4y)",
                                "(3x + 4y) (3x + 4y)",
                                "(3x + 4y) (3x – 4y)",
                                "(3x – 4y)^2"
                              ],
                              answer: "(3x + 4y) (3x – 4y)",
                              explanation: "This is a difference of squares."),
                          Question(
                              sequenceOrder: 2,
                              question:
                                  "Evaluate f(x) = −a^3 + 6a – 7 at a = –1 and state the remainder.",
                              options: ["-14", "-12", "14", "12"],
                              answer: "-12",
                              explanation:
                                  "Substituting –1 gives f(-1) = -12."),
                          Question(
                              sequenceOrder: 3,
                              question:
                                  "The ratio of staff to guests at the gala was 3 to 5. There were a total of 576 people in the ballroom. How many guests were at the gala?",
                              options: ["276", "300", "360", "216"],
                              answer: "360",
                              explanation: "Solve using proportions: 3:5."),
                          Question(
                              sequenceOrder: 4,
                              question: "Solve the quadratic x^2 + 10x = –25.",
                              options: ["-10", "10", "5", "-5"],
                              answer: "-5",
                              explanation: "Factoring gives (x+5)^2 = 0."),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ExamCourse(
            id: "3",
            title: "Functions",
            years: [
              ExamYear(
                title: "2024",
                grades: [
                  ExamGrade(
                    id: "10",
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Functions",
                        questions: [
                          Question(
                              sequenceOrder: 1,
                              question:
                                  "Describe how the graph of g(x)=x^3 – 5 can be obtained by shifting f(x) = x^3 + 2.",
                              options: [
                                "Shift right 7 units",
                                "Shift left 7 units",
                                "Shift up 7 units",
                                "Shift down 7 units"
                              ],
                              answer: "Shift down 7 units",
                              explanation:
                                  "The vertical shift changes from +2 to -5."),
                          Question(
                              sequenceOrder: 2,
                              question: "Solve 3^x=12 using logarithmic form.",
                              options: [
                                "x = ln12/ln3",
                                "x = ln(4)",
                                "x = ln(9)",
                                "None of these"
                              ],
                              answer: "x = ln12/ln3",
                              explanation:
                                  "Solve using logarithms: x = log(base 3)12 = ln12/ln3."),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ExamCourse(
            id: "4",
            title: "Geometry",
            years: [
              ExamYear(
                title: "2024",
                grades: [
                  ExamGrade(
                    id: "10",
                    title: "Grade 10",
                    chapters: [
                      ExamChapter(
                        id: 1,
                        title: "Geometry",
                        questions: [
                          Question(
                              sequenceOrder: 1,
                              question:
                                  "What value on the number line divides segment EF into two parts having a ratio of their lengths of 3:1?",
                              options: ["-5", "-3", "-2", "-1"],
                              answer: "-1",
                              explanation:
                                  "The point -1 divides segment EF in a 3:1 ratio."),
                        ],
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
