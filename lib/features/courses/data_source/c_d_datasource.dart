part of 'course_detail_data_source.dart';

final highSchool = [
  CourseCategory(
    id: 'high_school',
    name: 'High School',
    categoryType: CategoryType.highSchool,
    grades: [
      Grade(
        id: '9th',
        name: '9th Grade',
        courses: [
          Course(
            title: "Biology",
            topics: 6,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            likes: 12,
            liked: false,
            saves: 15,
            image: 'applied_math.png',
            chapters: [
              Chapter(name: "Chapter 1 vid 1", title: "Vectors", videos: [
                Video(title: "oTxY2P5j32w", duration: ""),
                Video(title: "XZJdyPkCxuE", duration: ""),
                Video(title: "Tc2-B44oanQ", duration: ""),
                Video(title: "oTxY2P5j32w", duration: ""),
                Video(title: "oTxY2P5j32w", duration: ""),
              ]),
              Chapter(name: "Chapter 2", title: "Number sequences", videos: [
                Video(title: "XZJdyPkCxuE", duration: ""),
                Video(title: "XZJdyPkCxuE", duration: ""),
                Video(title: "XZJdyPkCxuE", duration: ""),
                Video(title: "oTxY2P5j32w", duration: ""),
              ]),
              Chapter(
                  name: "Chapter 3",
                  title: "Limits and continuity",
                  videos: [
                    Video(title: "Tc2-B44oanQ", duration: ""),
                    Video(title: "Tc2-B44oanQ", duration: ""),
                  ]),
              Chapter(name: "Chapter 4", title: "Derivatives", videos: [
                Video(title: "Tc2-B44oanQ", duration: ""),
                Video(title: "Tc2-B44oanQ", duration: ""),
                Video(title: "Tc2-B44oanQ", duration: ""),
              ]),
              Chapter(name: "Chapter 5", title: "Integrals", videos: [
                Video(title: "Tc2-B44oanQ", duration: ""),
                Video(title: "Tc2-B44oanQ", duration: ""),
                Video(title: "Tc2-B44oanQ", duration: ""),
              ]),
            ],
          ),
          Course(
            title: "Applied Mathematics",
            topics: 7,
            likes: 12,
            liked: false,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            saves: 13,
            //image: 'mathematics.png',
            image: 'applied_math.png',
            chapters: [
              Chapter(name: "Chapter 1", title: "Vectors", videos: [
                Video(title: "oTxY2P5j32w", duration: ""),
                Video(title: "oTxY2P5j32w", duration: ""),
                Video(title: "oTxY2P5j32w", duration: ""),
              ]),
              Chapter(name: "Chapter 2", title: "Number sequences", videos: [
                Video(title: "XZJdyPkCxuE", duration: ""),
                Video(title: "XZJdyPkCxuE", duration: ""),
                Video(title: "XZJdyPkCxuE", duration: ""),
              ]),
              Chapter(
                  name: "Chapter 3",
                  title: "Limits and continuity",
                  videos: [
                    Video(title: "Tc2-B44oanQ", duration: ""),
                    Video(title: "Tc2-B44oanQ", duration: ""),
                    Video(title: "Tc2-B44oanQ", duration: ""),
                  ]),
              Chapter(name: "Chapter 4", title: "Derivatives", videos: [
                Video(title: "Tc2-B44oanQ", duration: ""),
                Video(title: "Tc2-B44oanQ", duration: ""),
                Video(title: "Tc2-B44oanQ", duration: ""),
              ]),
              Chapter(name: "Chapter 5", title: "Integrals", videos: [
                Video(title: "Tc2-B44oanQ", duration: ""),
                Video(title: "Tc2-B44oanQ", duration: ""),
                Video(title: "Tc2-B44oanQ", duration: ""),
              ]),
            ],
          ),
        ],
      ),
      Grade(
        id: '10th',
        name: '10th Grade',
        courses: [
          Course(
            title: "Chemistry",
            topics: 8,
            saves: 16,
            likes: 12,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            liked: false,
            //image: 'chemistry.png',
            image: 'applied_math.png',
            chapters: [
              Chapter(
                  name: "Chapter 1",
                  title: "Introduction to Computers",
                  videos: [
                    Video(title: "Rd4a1X3B61w", duration: ""),
                  ]),
              Chapter(
                name: "Chapter 2",
                title: "",
                videos: [
                  Video(title: "5iTOphGnCtg", duration: ""),
                  Video(title: "5iTOphGnCtg", duration: ""),
                  Video(title: "5iTOphGnCtg", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 3",
                title: "",
                videos: [
                  Video(title: "5iTOphGnCtg", duration: ""),
                  Video(title: "5iTOphGnCtg", duration: ""),
                  Video(title: "5iTOphGnCtg", duration: ""),
                ],
              ),
            ],
          ),
          Course(
            title: "Biology",
            topics: 8,
            saves: 16,
            likes: 12,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            liked: false,
            //image: 'chemistry.png',
            image: 'applied_math.png',
            chapters: [
              Chapter(
                name: "Chapter 1",
                title: "Intro to biology",
                videos: [
                  Video(title: "3tisOnOkwzo", duration: ""),
                  Video(title: "3tisOnOkwzo", duration: ""),
                  Video(title: "3tisOnOkwzo", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 1",
                title: "Intro to biology",
                videos: [
                  Video(title: "3tisOnOkwzo", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 1",
                title: "Intro to biology",
                videos: [
                  Video(title: "3tisOnOkwzo", duration: ""),
                  Video(title: "3tisOnOkwzo", duration: ""),
                  Video(title: "3tisOnOkwzo", duration: ""),
                ],
              ),
            ],
          ),
          Course(
            title: "Physics",
            topics: 8,
            saves: 16,
            likes: 12,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            liked: false,
            //image: 'chemistry.png',
            image: 'applied_math.png',
            chapters: [
              Chapter(
                name: "Chapter 1",
                title: "Vectors",
                videos: [
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 1",
                title: "Vectors",
                videos: [
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 1",
                title: "Vectors",
                videos: [
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                ],
              ),
            ],
          ),
          Course(
            title: "History",
            topics: 5,
            saves: 12,
            likes: 12,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            liked: false,
            //image: 'history.png',
            image: 'applied_math.png',
            chapters: [
              Chapter(
                name: "Chapter 1",
                title: "Introduction",
                videos: [
                  Video(title: "ajRdOHmYw74", duration: ""),
                  Video(title: "ajRdOHmYw74", duration: ""),
                  Video(title: "ajRdOHmYw74", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 2",
                title: "Introduction",
                videos: [
                  Video(title: "ajRdOHmYw74", duration: ""),
                  Video(title: "ajRdOHmYw74", duration: ""),
                  Video(title: "ajRdOHmYw74", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 3",
                title: "Introduction",
                videos: [
                  Video(title: "ajRdOHmYw74", duration: ""),
                  Video(title: "ajRdOHmYw74", duration: ""),
                  Video(title: "ajRdOHmYw74", duration: ""),
                ],
              ),
            ],
          ),
        ],
      ),
      Grade(
        id: '11th',
        name: '11th Grade',
        courses: [
          Course(
            title: "Physics",
            topics: 7,
            saves: 18,
            likes: 12,
            liked: true,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            //image: 'physics.png',
            image: 'applied_math.png',
            chapters: [
              Chapter(
                name: "Chapter 1",
                title: "Vectors",
                videos: [
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 1",
                title: "Vectors",
                videos: [
                  Video(title: "b1t41Q3xRM8", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 1",
                title: "Vectors",
                videos: [
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                ],
              ),
            ],
            streamOrDepartment: "Natural",
          ),
          Course(
            title: "Economics",
            topics: 5,
            saves: 11,
            likes: 12,
            liked: false,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            //image: 'economics.png',
            image: 'applied_math.png',
            chapters: [
              Chapter(
                name: "Chapter 1",
                title: "Vectors",
                videos: [
                  Video(title: "b1t41Q3xRM8", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 1",
                title: "Vectors",
                videos: [
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                ],
              ),
              Chapter(
                name: "Chapter 1",
                title: "Vectors",
                videos: [
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                  Video(title: "b1t41Q3xRM8", duration: ""),
                ],
              ),
            ],
            streamOrDepartment: "Social",
          ),
        ],
      ),
      Grade(
        id: '12th',
        name: '12th Grade',
        courses: [
          Course(
            title: "Calculus",
            topics: 9,
            saves: 20,
            likes: 12,
            liked: false,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            //image: 'calculus.png',
            image: 'applied_math.png',
            chapters: [],
            streamOrDepartment: "Natural",
          ),
          Course(
            title: "Political Science",
            likes: 12,
            liked: false,
            topics: 6,
            saves: 14,
            //image: 'political_science.png',
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            image: 'applied_math.png',
            chapters: [],
            streamOrDepartment: "Social",
          ),
        ],
      ),
    ],
  ),
];
final lowerGrades = [
  CourseCategory(
    id: 'lower_grades',
    name: 'Lower Grades',
    categoryType: CategoryType.lowerGrade,
    grades: [
      Grade(
        id: '1st',
        name: '1st Grade',
        courses: [
          Course(
            title: "Math Basics",
            topics: 5,
            saves: 10,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            likes: 12,
            liked: false,
            //image: 'math_basics.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Reading",
            topics: 6,
            likes: 12,
            liked: false,
            saves: 8,
            //image: 'reading_course.png',
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            image: 'applied_math.png',
            chapters: [],
          ),
        ],
      ),
      Grade(
        id: '2nd',
        name: '2nd Grade',
        courses: [
          Course(
            title: "Advanced Math",
            topics: 5,
            likes: 12,
            liked: false,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            saves: 12,
            //image: 'advanced_math.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Writing",
            likes: 12,
            liked: false,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            topics: 6,
            saves: 7,
            //image: 'writing_course.png',
            image: 'applied_math.png',
            chapters: [],
          ),
        ],
      ),
      Grade(
        id: '3rd',
        name: '3rd Grade',
        courses: [
          Course(
            title: "Multiplication and Division",
            topics: 4,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            likes: 12,
            liked: false,
            saves: 9,
            //image: 'multiplication.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Grammar",
            topics: 5,
            likes: 12,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            liked: false,
            saves: 6,
            //image: 'grammar_course.png',
            image: 'applied_math.png',
            chapters: [],
          ),
        ],
      ),
      Grade(
        id: '4th',
        name: '4th Grade',
        courses: [
          Course(
            title: "Fractions and Decimals",
            likes: 12,
            liked: false,
            topics: 6,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            saves: 11,
            //image: 'fractions_decimals.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Creative Writing",
            topics: 4,
            saves: 10,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            likes: 12,
            liked: false,
            //image: 'creative_writing.png',
            image: 'applied_math.png',
            chapters: [],
          ),
        ],
      ),
      Grade(
        id: '5th',
        name: '5th Grade',
        courses: [
          Course(
            title: "Geometry Basics",
            topics: 7,
            likes: 12,
            liked: false,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            saves: 15,
            //image: 'geometry_basics.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Science Experiments",
            likes: 12,
            liked: false,
            topics: 5,
            saves: 14,
            //image: 'science_experiments.png',
            image: 'applied_math.png',
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            chapters: [],
          ),
        ],
      ),
      Grade(
        id: '6th',
        name: '6th Grade',
        courses: [
          Course(
            title: "Algebra Basics",
            topics: 5,
            likes: 12,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            liked: false,
            saves: 13,
            //image: 'algebra_basics.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Earth Science",
            topics: 6,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            saves: 12,
            likes: 12,
            liked: false,
            //image: 'earth_science.png',
            image: 'applied_math.png',
            chapters: [],
          ),
        ],
      ),
      Grade(
        id: '7th',
        name: '7th Grade',
        courses: [
          Course(
            title: "Pre-Algebra",
            topics: 6,
            saves: 14,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            likes: 12,
            liked: false,
            //image: 'pre_algebra.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "History Basics",
            topics: 5,
            saves: 11,
            likes: 12,
            liked: false,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            //image: 'history_basics.png',
            image: 'applied_math.png',
            chapters: [],
          ),
        ],
      ),
      Grade(
        id: '8th',
        name: '8th Grade',
        courses: [
          Course(
            title: "Algebra 1",
            topics: 8,
            saves: 18,
            likes: 12,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            liked: false,
            //image: 'algebra_1.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Physical Science",
            topics: 7,
            saves: 17,
            likes: 12,
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            liked: false,
            //image: 'physical_science.png',
            image: 'applied_math.png',
            chapters: [],
          ),
        ],
      ),
    ],
  ),
];

final university = [
  CourseCategory(
    id: 'university',
    name: 'University',
    categoryType: CategoryType.university,
    grades: [
      Grade(
        id: 'freshman',
        name: 'Freshman',
        courses: [
          Course(
            title: "Introduction to Computer Science",
            price: {
              SubscriptionType.oneMonth: 72.0,
              SubscriptionType.threeMonths: 216.0,
              SubscriptionType.sixMonths: 432.0,
              SubscriptionType.yearly: 864.0,
            },
            topics: 8,
            saves: 22,
            likes: 12,
            liked: false,
            //image: 'cs_intro.png',
            image: 'applied_math.png',
            chapters: [
              Chapter(name: "intro to cs", title: "intro to cs", videos: [
                Video(duration: "", title: "-uleG_Vecis"),
                Video(duration: "", title: "-uleG_Vecis"),
              ]),
              Chapter(
                name: "intro to cs",
                title: "intro to cs",
                videos: [
                  Video(duration: "", title: "-uleG_Vecis"),
                  Video(duration: "", title: "-uleG_Vecis"),
                ],
              ),
            ],
          ),
        ],
      ),
      Grade(
        id: '2ndYear',
        name: '2nd Year',
        courses: [],
        subCategories: [
          SubCategory(
            id: 'cs',
            name: 'Computer Science',
            courses: [
              Course(
                title: "Data Structures",
                topics: 10,
                saves: 25,
                price: {
                  SubscriptionType.oneMonth: 72.0,
                  SubscriptionType.threeMonths: 216.0,
                  SubscriptionType.sixMonths: 432.0,
                  SubscriptionType.yearly: 864.0,
                },
                likes: 12,
                liked: false,
                //    image: 'data_structures.png',
                image: 'applied_math.png',
                chapters: [
                  Chapter(
                    name: "intro to dsa",
                    title: "intro to dsa",
                    videos: [
                      Video(title: "oz9cEqFynHU", duration: ""),
                      Video(title: "oz9cEqFynHU", duration: ""),
                    ],
                  ),
                ],
                streamOrDepartment: "Computer Science",
              ),
            ],
          ),
        ],
      ),
      Grade(
        id: '3rdYear',
        name: '3rd Year',
        subCategories: [
          SubCategory(
            id: 'engineering',
            name: 'Engineering',
            courses: [
              Course(
                title: "Thermodynamics",
                topics: 12,
                price: {
                  SubscriptionType.oneMonth: 72.0,
                  SubscriptionType.threeMonths: 216.0,
                  SubscriptionType.sixMonths: 432.0,
                  SubscriptionType.yearly: 864.0,
                },
                saves: 18,
                likes: 12,
                liked: false,
                //image: 'thermodynamics.png',
                image: 'applied_math.png',
                chapters: [
                  Chapter(
                    name: "intro to thermo",
                    title: "intro to thermo",
                    videos: [
                      Video(title: "4i1MUWJoI0U", duration: ""),
                      Video(title: "4i1MUWJoI0U", duration: ""),
                      Video(title: "4i1MUWJoI0U", duration: ""),
                    ],
                  ),
                ],
                streamOrDepartment: "Mechanical Engineering",
              ),
            ],
          ),
        ],
      ),
      Grade(
        id: '4thYear',
        name: '4th Year',
        subCategories: [
          SubCategory(
            id: 'business',
            name: 'Business Administration',
            courses: [
              Course(
                price: {
                  SubscriptionType.oneMonth: 72.0,
                  SubscriptionType.threeMonths: 216.0,
                  SubscriptionType.sixMonths: 432.0,
                  SubscriptionType.yearly: 864.0,
                },
                title: "Strategic Management",
                topics: 10,
                saves: 20,
                likes: 12,
                liked: false,
                //    image: 'strategic_management.png',
                image: 'applied_math.png',
                chapters: [],
                streamOrDepartment: "Business Administration",
              ),
            ],
          ),
        ],
      ),
      Grade(
        id: '5thYear',
        name: '5th Year',
        subCategories: [
          SubCategory(
            id: 'medicine',
            name: 'Medicine',
            courses: [
              Course(
                title: "Clinical Medicine",
                topics: 15,
                price: {
                  SubscriptionType.oneMonth: 72.0,
                  SubscriptionType.threeMonths: 216.0,
                  SubscriptionType.sixMonths: 432.0,
                  SubscriptionType.yearly: 864.0,
                },
                saves: 30,
                likes: 12,
                liked: false,
                //    image: 'clinical_medicine.png',
                image: 'applied_math.png',
                chapters: [],
                streamOrDepartment: "Medicine",
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
