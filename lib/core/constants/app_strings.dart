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
    "Applied Chemistry",
    "Applied Mathematics",
    "Applied Physics",
    "Architecture",
    "Biology",
    "Biomedical Engineering",
    "Business Administration",
    "Chemical Engineering",
    "Chemistry",
    "Civil Engineering",
    "Computer Science",
    "Data Science",
    "Dentistry",
    "Economics",
    "Electrical Engineering",
    "Geography and Environmental Studies",
    "Geology",
    "History and Heritage Management",
    "Industrial Engineering",
    "Information System",
    "Information Technology",
    "International Relations",
    "Journalism and Communication",
    "Law",
    "Management Information Systems",
    "Marketing Management",
    "Mathematics",
    "Mechanical Engineering",
    "Medical Laboratory Science",
    "Medicine",
    "Nursing",
    "Pharmacy",
    "Physics",
    "Political Science",
    "Pre-Engineering",
    "Psychology",
    "Public Health",
    "Public Relations",
    "Sociology",
    "Software Engineering",
    "Statistics",
    "Urban Planning and Development",
  ];

  // storage keys
  static const String userStorageKey = "user";
  static const String authStatusKey = "auth_status";
  static const String forgotPassStorageKey = "forgotPassword";
  static const String onboardingStatusStorageKey = "onboarding_status";
  static const String subbedCoursesStorageKey = "subbed_courses";


  static const List<String> fourYearDepts = [
    "Accounting and Finance",
    "Applied Chemistry",
    "Applied Mathematics",
    "Applied Physics",
    "Biology",
    "Business Administration",
    "Chemistry",
    "Computer Science",
    "Data Science",
    "Economics",
    "Geography and Environmental Studies",
    "Geology",
    "History and Heritage Management",
    "Information System",
    "Information Technology",
    "International Relations",
    "Journalism and Communication",
    "Law",
    "Management Information Systems",
    "Marketing Management",
    "Mathematics",
    "Medical Laboratory Science",
    "Nursing",
    "Physics",
    "Political Science",
    "Psychology",
    "Public Health",
    "Public Relations",
    "Sociology",
    "Statistics",
  ];

  static const List<String> fiveYearDepts = [
    "Architecture",
    "Biomedical Engineering",
    "Chemical Engineering",
    "Civil Engineering",
    "Electrical Engineering",
    "Industrial Engineering",
    "Mechanical Engineering",
    "Pharmacy",
    "Software Engineering",
    "Urban Planning and Development",
  ];

  static const List<String> sixYearDepts = [
    "Medicine",
  ];

  static const List<String> sevenYearDepts = [
    "All",
    "Dentistry",
  ];
  static const List<String> oneYearDepts = [
    "Pre-Engineering",
  ];
  static String categoryFormatted(String input) {
    return switch (input) {
      lowerGradesCategory => "Lower Grades",
      highSchoolCategory => "High School",
      universityCategory => "University",
      otherCoursesCategory => "Courses",
      _ => "Courses",
    };
  }
  //static const String Key = "user";
}
