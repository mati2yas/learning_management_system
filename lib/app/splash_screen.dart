// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lms_system/app/app.dart';
// import 'package:lms_system/core/app_router.dart';
// import 'package:lms_system/features/shared/model/start_routes.dart';

// class SplashScreen extends ConsumerWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Watch the provider's state
//     final initialRoutesAsyncValue = ref.watch(initialRouteProvider);

//     // Use ref.listen to react to state changes and perform navigation
//     ref.listen<AsyncValue<StartRoutes>>(
//       initialRouteProvider,
//       (previous, next) {
//         next.whenOrNull(data: (routesData) {
//           // Ensure navigation happens after the build cycle is complete
//           // This prevents calling Navigator methods during the build method
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (routesData.firstRoute == Routes.wrapper) {
//               // If the initial route is wrapper, it requires an apiToken
//               Navigator.of(context).pushReplacementNamed(
//                 routesData.firstRoute,
//                 arguments: routesData.apiToken, // Pass the token as argument
//               );
//             } else {
//               // Navigate to other routes that don't require arguments
//               Navigator.of(context).pushReplacementNamed(routesData.firstRoute);
//             }
//           });
//         }, error: (error, stackTrace) {
//           // Handle error state (e.g., show error message or navigate to an error screen)
//           debugPrint(
//               'Splash Screen Error: Error determining initial route: $error');
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             // Navigate to a login/signup screen or a dedicated error screen on error
//             Navigator.of(context)
//                 .pushReplacementNamed(Routes.signup); // Example fallback
//           });
//         },
//             // Optional: Add a loading case if you want to react immediately
//             // when loading starts, though the initial build handles this.
//             loading: () {
//           // You can add logic here if needed when the provider starts loading
//         });
//       },
//     );

//     // While the provider is loading, show a simple splash screen UI
//     return Scaffold(
//       backgroundColor: Colors.white, // Or your splash color
//       body: Center(
//         // Show a loading indicator or your app logo
//         child: initialRoutesAsyncValue.when(
//           loading: () => const CircularProgressIndicator(),
//           data: (_) =>
//               const SizedBox.shrink(), // Hide indicator once data is ready
//           error: (_, __) => const Text('Error loading app'), // Basic error text
//         ),
//       ),
//     );
//   }
// }
