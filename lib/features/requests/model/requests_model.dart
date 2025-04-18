
// class SubscriptionRequest {
//   final List<Course> courses;
//   final SubscriptionType subscriptionType;
//   final XFile screenshot; // Accept XFile instead of path
//   final String transactionId;

//   SubscriptionRequest({
//     required this.courses,
//     required this.subscriptionType,
//     required this.screenshot,
//     required this.transactionId,
//   });

//   Future<FormData> toFormData() async {
//     return FormData.fromMap({
//       "courses": courses
//           .map((c) => c.getPriceBySubscriptionType(subscriptionType))
//           .toList(), // Only send IDs
//       "subscription_type": subscriptionType.name,
//       "screenshot": await MultipartFile.fromFile(screenshot.path,
//           filename: "screenshot.jpg"),
//       "transaction_id": transactionId,
//     });
//   }
// }
