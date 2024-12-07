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
            desc: "Introduction to biology concepts",
            topics: 6,
            saves: 15,
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Mathematics",
            desc: "Advanced arithmetic and algebra",
            topics: 7,
            saves: 13,
            //image: 'mathematics.png',
            image: 'applied_math.png',
            chapters: [],
          ),
        ],
      ),
      Grade(
        id: '10th',
        name: '10th Grade',
        courses: [
          Course(
            title: "Chemistry",
            desc: "Understanding chemical reactions and compounds",
            topics: 8,
            saves: 16,
            //image: 'chemistry.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "History",
            desc: "Exploring historical events and their impact",
            topics: 5,
            saves: 12,
            //image: 'history.png',
            image: 'applied_math.png',
            chapters: [],
          ),
        ],
      ),
      Grade(
        id: '11th',
        name: '11th Grade',
        courses: [
          Course(
            title: "Physics",
            desc: "Understanding basic physics principles",
            topics: 7,
            saves: 18,
            //image: 'physics.png',
            image: 'applied_math.png',
            chapters: [],
            streamOrDepartment: "Natural",
          ),
          Course(
            title: "Economics",
            desc: "Introduction to economics and finance",
            topics: 5,
            saves: 11,
            //image: 'economics.png',
            image: 'applied_math.png',
            chapters: [],
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
            desc: "Introduction to derivatives and integrals",
            topics: 9,
            saves: 20,
            //image: 'calculus.png',
            image: 'applied_math.png',
            chapters: [],
            streamOrDepartment: "Natural",
          ),
          Course(
            title: "Political Science",
            desc: "Learning about political systems and governance",
            topics: 6,
            saves: 14,
            //image: 'political_science.png',
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
            desc: "Introduction to basic math concepts",
            topics: 5,
            saves: 10,
            //image: 'math_basics.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Reading",
            desc: "Learning to read simple texts",
            topics: 6,
            saves: 8,
            //image: 'reading_course.png',
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
            desc: "Building on basic math skills",
            topics: 5,
            saves: 12,
            //image: 'advanced_math.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Writing",
            desc: "Learning basic writing skills",
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
            desc: "Introduction to multiplication and division",
            topics: 4,
            saves: 9,
            //image: 'multiplication.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Grammar",
            desc: "Learning basic grammar rules",
            topics: 5,
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
            desc: "Understanding fractions and decimals",
            topics: 6,
            saves: 11,
            //image: 'fractions_decimals.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Creative Writing",
            desc: "Developing writing creativity",
            topics: 4,
            saves: 10,
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
            desc: "Introduction to basic geometry",
            topics: 7,
            saves: 15,
            //image: 'geometry_basics.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Science Experiments",
            desc: "Basic hands-on science experiments",
            topics: 5,
            saves: 14,
            //image: 'science_experiments.png',
            image: 'applied_math.png',
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
            desc: "Introduction to algebra concepts",
            topics: 5,
            saves: 13,
            //image: 'algebra_basics.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Earth Science",
            desc: "Learning about the Earth and its structure",
            topics: 6,
            saves: 12,
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
            desc: "Preparation for advanced algebra topics",
            topics: 6,
            saves: 14,
            //image: 'pre_algebra.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "History Basics",
            desc: "Understanding historical events and figures",
            topics: 5,
            saves: 11,
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
            desc: "Detailed introduction to algebra",
            topics: 8,
            saves: 18,
            //image: 'algebra_1.png',
            image: 'applied_math.png',
            chapters: [],
          ),
          Course(
            title: "Physical Science",
            desc: "Basic physics and chemistry concepts",
            topics: 7,
            saves: 17,
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
            desc: "Basics of programming and algorithms",
            topics: 8,
            saves: 22,
            //image: 'cs_intro.png',
            image: 'applied_math.png',
            chapters: [],
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
                desc: "Exploring different types of data structures",
                topics: 10,
                saves: 25,
                //    image: 'data_structures.png',
                image: 'applied_math.png',
                chapters: [],
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
                desc: "Study of heat and energy transfer",
                topics: 12,
                saves: 18,
                //image: 'thermodynamics.png',
                image: 'applied_math.png',
                chapters: [],
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
                title: "Strategic Management",
                desc: "Overview of corporate strategies",
                topics: 10,
                saves: 20,
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
                desc: "Introduction to clinical practices",
                topics: 15,
                saves: 30,
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
