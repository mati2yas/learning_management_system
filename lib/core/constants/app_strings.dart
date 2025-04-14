class AppStrings {
  static const String matric = "ESSLCE";
  static const String ministry6th = "6th Grade Ministry";
  static const String ministry8th = "8th Grade Ministry";
  static const String exit = "EXIT";
  static const String uat = "UAT";
  static const String sat = "SAT";
  static const String ngat = "NGAT";
  static const String exam = "EXAM";

  static const String lowerGradesCategory = "lower_grades";
  static const String highSchoolCategory = "high_school";
  static const String universityCategory = "university";
  static const String otherCoursesCategory = "random_courses";
  static const List<String> courseCategories = [
    lowerGradesCategory,
    highSchoolCategory,
    universityCategory,
    otherCoursesCategory,
  ];
  static const String grade9 = "Grade 9";

  static const String grade10 = "Grade 10";
  static const String grade11 = "Grade 11";
  static const String grade12 = "Grade 12";

  static const String naturalStream = "Natural";
  static const String socialStream = "Social";
  static const String commonStream = "Common";

  static const List<String> highSchoolGrades = [
    grade9,
    grade10,
    grade11,
    grade12,
  ];

  static const List<String> lowerGrades = [
    "Grade 1",
    "Grade 2",
    "Grade 3",
    "Grade 4",
    "Grade 5",
    "Grade 6",
    "Grade 7",
    "Grade 8"
  ];

  static const List<String> universityGrades = [
    "Freshman",
    "2nd Year",
    "3rd Year",
    "4th Year",
    "5th Year",
    "6th Year",
    "7th Year",
  ];

  static const List<String> universityDepartments = [
    "All",
    "Accounting and Finance",
    "Afan Oromo, Literature and Communication",
    "Anesthesia",
    "Applied Chemistry",
    "Applied Mathematics",
    "Applied Physics",
    "Architecture",
    "Biology",
    "Biomedical Engineering",
    "Business Administration and information systems",
    "Chemical Engineering",
    "Chemistry",
    "Civil Engineering",
    "Computer Science",
    "Data Science",
    "Dentistry",
    "Doctor of Veterinary Medicine",
    "Economics",
    "Electrical Engineering",
    "Electromechanical Engineering",
    "English Language and Literature",
    "Environmental Engineering",
    "Exercise and Sport Science",
    "Food Science and Nutrition",
    "Freshman",
    "Geography and Environmental Studies",
    "Geology",
    "History and Heritage Management",
    "Industrial Engineering",
    "Information System",
    "Information Technology",
    "International Relations",
    "Journalism and Communication",
    "Law",
    "Logistics and Supply Chain Management",
    "Management",
    "Management Information Systems",
    "Marketing Management",
    "Mathematics",
    "Mechanical Engineering",
    "Medical Laboratory Science",
    "Medical Radiologic Technology",
    "Medicine",
    "Midwifery",
    "Mining Engineering",
    "Nursing",
    "Pharmacy",
    "Physics",
    "Political Science and International Relations",
    "Pre-Engineering",
    "Psychology",
    "Public Health",
    "Public Relations",
    "Social Work",
    "Sociology",
    "Software Engineering",
    "Statistics",
    "Urban Planning and Design",
    "Veterinary Science",
  ];

  // storage keys
  static const String userStorageKey = "user";
  static const String authStatusKey = "auth_status";
  static const String forgotPassStorageKey = "forgotPassword";
  static const String onboardingStatusStorageKey = "onboarding_status";
  static const String subbedCoursesStorageKey = "subbed_courses";

  static const String stubIdType = "idType";
  static const String stubId = "id";
  static const String stubCourseId = "courseId";
  static const String stubGradeId = "stubGradeId";

  static const List<String> fourYearDepts = [
    "Accounting and Finance",
    "Afan Oromo, Literature and Communication",
    "Applied Chemistry",
    "Applied Mathematics",
    "Applied Physics",
    "Biology",
    "Business Administration and information systems",
    "Chemistry",
    "Computer Science",
    "Data Science",
    "Economics",
    "English Language and Literature",
    "Exercise and Sport Science",
    "Food Science and Nutrition",
    "Geography and Environmental Studies",
    "Geology",
    "History and Heritage Management",
    "Information System",
    "Information Technology",
    "International Relations",
    "Journalism and Communication",
    "Law",
    "Logistics and Supply Chain Management",
    "Management",
    "Management Information Systems",
    "Marketing Management",
    "Mathematics",
    "Medical Laboratory Science",
    "Medical Radiologic Technology",
    "Midwifery",
    "Nursing",
    "Physics",
    "Political Science and International Relations",
    "Psychology",
    "Public Health",
    "Public Relations",
    "Social Work",
    "Sociology",
    "Statistics",
  ];

  static const List<String> fiveYearDepts = [
    "Anesthesia",
    "Architecture",
    "Biomedical Engineering",
    "Chemical Engineering",
    "Civil Engineering",
    "Electrical Engineering",
    "Electromechanical Engineering",
    "Environmental Engineering",
    "Industrial Engineering",
    "Mechanical Engineering",
    "Mining Engineering",
    "Pharmacy",
    "Software Engineering",
    "Urban Planning and Design",
    "Veterinary Science",
  ];

  static const List<String> sixYearDepts = [
    "Doctor of Veterinary Medicine",
    "Medicine",
  ];

  static const List<String> sevenYearDepts = [
    "All",
    "Dentistry",
  ];
  static const List<String> oneYearDepts = [
    "Freshman",
    "Pre-Engineering",
  ];

  // examData map keys
  static const String examCourseKey = "exam course";
  static const String examYearKey = "exam year";
  static const String examCourseIdKey = "courseId";
  static const String previousScreenKey = "previous screen";
  static const String hasTimerOptionKey = "hasTimerOption";
  static const String timerDurationKey = "timer duration";
  static const String questionsKey = "questions";

  static String categoryFormatted(String input) {
    return switch (input) {
      lowerGradesCategory => "Lower Grades",
      highSchoolCategory => "High School",
      universityCategory => "University",
      otherCoursesCategory => "Courses",
      _ => "Courses",
    };
  }
}
