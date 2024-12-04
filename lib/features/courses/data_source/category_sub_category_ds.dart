import '../model/categories_sub_categories.dart';

final categoriesData = [
  CourseCategory(
    id: 'lower_grades',
    name: 'Lower Grades',
    categoryType: CategoryType.lowerGrade,
    grades: [
      Grade(
        id: '1st',
        name: '1st Grade',
        courses: [
          Course(id: 'math101', name: 'Math Basics'),
        ],
      ),
    ],
  ),
  CourseCategory(
    id: 'high_school',
    name: 'High School',
    categoryType: CategoryType.highSchool,
    grades: [
      Grade(
        id: '9th',
        name: '9th',
        courses: [
          Course(id: 'bio', name: 'Biology'),
          Course(id: 'chem', name: 'Chemistry'),
          Course(id: 'phys', name: 'Physics'),
        ],
      ),
      Grade(
        id: '10th',
        name: '10th',
        courses: [
          Course(id: 'bio', name: 'Biology'),
          Course(id: 'chem', name: 'Chemistry'),
          Course(id: 'phys', name: 'Physics'),
        ],
      ),
      Grade(
        id: '11th',
        name: '9th',
        subCategories: [SubCategory(id: 'social', name: "Social")],
        courses: [
          Course(id: 'bus', name: 'Business'),
          Course(id: 'his', name: 'History'),
          Course(id: 'eco', name: 'Economics'),
        ],
      ),
      Grade(
        id: '11th',
        name: '9th',
        subCategories: [SubCategory(id: 'natural', name: "Natural")],
        courses: [
          Course(id: 'bio', name: 'Biology'),
          Course(id: 'chem', name: 'Chemistry'),
          Course(id: 'phys', name: 'Physics'),
        ],
      ),
      Grade(
        id: '12th',
        name: '12th',
        subCategories: [SubCategory(id: 'social', name: "Social")],
        courses: [
          Course(id: 'bus', name: 'Business'),
          Course(id: 'his', name: 'History'),
          Course(id: 'eco', name: 'Economics'),
        ],
      ),
      Grade(
        id: '12th',
        name: '12th',
        subCategories: [SubCategory(id: 'natural', name: "Natural")],
        courses: [
          Course(id: 'bio', name: 'Biology'),
          Course(id: 'chem', name: 'Chemistry'),
          Course(id: 'phys', name: 'Physics'),
        ],
      ),
    ],
  ),
  CourseCategory(
    id: 'university',
    name: 'University',
    categoryType: CategoryType.university,
    grades: [
      Grade(
        id: 'freshman',
        name: 'Freshman',
        courses: [
          Course(id: 'intro101', name: 'Introduction to University Life'),
        ],
      ),
      Grade(
        id: '2ndYear',
        name: '2nd Year',
        subCategories: [
          SubCategory(
            id: 'cs',
            name: 'Computer Science',
            courses: [
              Course(id: 'dm101', name: 'Discrete Math'),
              Course(id: 'ds101', name: 'Data Structures'),
            ],
          ),
        ],
      ),
    ],
  ),
  CourseCategory(
    id: 'university',
    name: 'University',
    categoryType: CategoryType.university,
    grades: [
      Grade(
        id: 'freshman',
        name: 'Freshman',
        courses: [
          Course(id: 'intro101', name: 'Introduction to University Life'),
        ],
      ),
      Grade(
        id: '2ndYear',
        name: '2nd Year',
        subCategories: [
          SubCategory(
            id: 'cs',
            name: 'Computer Science',
            courses: [
              Course(id: 'dm101', name: 'Discrete Math'),
              Course(id: 'ds101', name: 'Data Structures'),
            ],
          ),
        ],
      ),
    ],
  ),
];
