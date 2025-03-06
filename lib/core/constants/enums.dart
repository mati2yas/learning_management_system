enum ApiState { busy, error, idle }

enum AuthStatus {
  authed,
  pending,
  notAuthed,
}

enum CategoryType { lowerGrade, highSchool, university, random }

enum HighschoolClasses { lowerHs, prepHs }

enum IdType { filtered, all }

enum ProfileFetchType { backend, localDb }

enum SubscriptionType { oneMonth, threeMonths, sixMonths, yearly }
