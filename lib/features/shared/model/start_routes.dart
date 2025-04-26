class StartRoutes {
  final String firstRoute;
  final String secondRoute;

  StartRoutes({
    required this.firstRoute,
    required this.secondRoute,
  });

  StartRoutes copyWith({
    String? firstRoute,
    String? apiToken,
    String? secondRoute,
  }) {
    return StartRoutes(
      firstRoute: firstRoute ?? this.firstRoute,
      secondRoute: secondRoute ?? this.secondRoute,
    );
  }

  static StartRoutes initial() {
    return StartRoutes(firstRoute: "", secondRoute: "");
  }
}
