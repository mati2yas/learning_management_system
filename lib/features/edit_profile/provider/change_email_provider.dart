import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/edit_profile/repository/change_email_repository.dart';

// final changeEmailControllerProvider =
//     StateNotifierProvider<ChangeEmailController, ChangeEmailState>(
//   (ref) => ChangeEmailController(ref.watch(changeEmailRepositoryProvider)),
// );

// class ChangeEmailController extends StateNotifier<ChangeEmailState> {
//   final ChangeEmailRepository _repository;
//   ChangeEmailController(this._repository) : super(ChangeEmailState());

//   Future<ChangeEmailState> changeEmail() async {
//     Response? response;

//     state = state.copyWith(apiState: ApiState.busy);
//     try {
//       response = await _repository.changeEmail(email: state.email);

//       if (response?.statusCode == 200) {
//         state = state.copyWith(
//           apiState: ApiState.idle,
//           responseSuccess: true,
//         );
//       } else {
//         state = state.copyWith(
//           apiState: ApiState.error,
//           responseSuccess: false,
//         );
//       }
//     } catch (e) {
//       state = state.copyWith(
//         apiState: ApiState.error,
//         responseSuccess: false,
//       );
//       rethrow;
//     }
//     return state;
//   }

//   void updateEmail(String value) {
//     state = state.copyWith(email: value);
//   }
// }

// class ChangeEmailState {
//   final ApiState apiStatus;
//   final String email;
//   final bool responseSuccess;

//   ChangeEmailState({
//     this.apiStatus = ApiState.idle,
//     this.email = '',
//     this.responseSuccess = false,
//   });

//   ChangeEmailState copyWith({
//     ApiState? apiState,
//     String? email,
//     bool? responseSuccess,
//   }) {
//     return ChangeEmailState(
//       apiStatus: apiState ?? apiStatus,
//       email: email ?? this.email,
//       responseSuccess: responseSuccess ?? this.responseSuccess,
//     );
//   }
// }

// If Provider is not used, you can remove this line.
// make sure changeEmailRepositoryProvider is defined as well.
final changeEmailControllerProvider =
    StateNotifierProvider<ChangeEmailController, ChangeEmailState>(
  (ref) => ChangeEmailController(ref.watch(changeEmailRepositoryProvider)),
);

class ChangeEmailController extends StateNotifier<ChangeEmailState> {
  final ChangeEmailRepository _repository;
  ChangeEmailController(this._repository) : super(ChangeEmailState());

  Future<ChangeEmailState> changeEmail() async {
    Response? response;

    const int maxRetries =
        1; // 1 retry attempt after the initial failure (total 2 tries)
    int currentAttempt = 0;

    // Set initial state to busy
    state = state.copyWith(apiState: ApiState.busy);

    while (currentAttempt <= maxRetries) {
      try {
        response = await _repository.changeEmail(email: state.email);

        if (response?.statusCode == 200) {
          state = state.copyWith(
            apiState: ApiState.idle,
            responseSuccess: true,
          );
          return state; // Success! Exit the loop and return the state.
        } else {
          // If the status code is not 200 but the request completed,
          // re-throw it as a DioException so _shouldRetry can check it
          throw DioException(
            requestOptions:
                response!.requestOptions, // response won't be null here
            response: response,
            type: DioExceptionType.badResponse,
            error: "Received status code: ${response.statusCode}",
          );
        }
      } on DioException catch (e) {
        final bool isRetryable = _shouldRetry(e);

        if (isRetryable && currentAttempt < maxRetries) {
          currentAttempt++;
          // Optional: Add a log for the retry attempt
          print('Retrying changeEmail: (Attempt $currentAttempt)');
          await Future.delayed(
              const Duration(seconds: 2)); // Wait 2 seconds before retry
        } else {
          // If not retryable, or max retries reached, set error state and re-throw
          state = state.copyWith(
            apiState: ApiState.error,
            responseSuccess: false,
          );
          rethrow; // Re-throw the final DioException
        }
      } catch (e) {
        // Catch any other unexpected non-DioExceptions (like local token errors)
        // These are generally not retried.
        state = state.copyWith(
          apiState: ApiState.error,
          responseSuccess: false,
        );
        rethrow; // Re-throw the original exception
      }
    }
    // This line should technically not be reached if the loop handles
    // success or throws an error after all retries.
    // As a fallback, set error state if loop somehow exits without returning.
    state = state.copyWith(apiState: ApiState.error, responseSuccess: false);
    throw Exception(
        "Failed to change email after multiple attempts (loop exited unexpectedly).");
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  // Helper method to determine if a DioException should trigger a retry
  bool _shouldRetry(DioException err) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }
    if (err.response?.statusCode != null) {
      if ((err.response!.statusCode ?? 500) >= 500 &&
          (err.response!.statusCode ?? 500) < 600) {
        return true; // Server errors (5xx)
      }
    }

    return false;
  }
}

class ChangeEmailState {
  final ApiState apiStatus;
  final String email;
  final bool responseSuccess;

  ChangeEmailState({
    this.apiStatus = ApiState.idle,
    this.email = '',
    this.responseSuccess = false,
  });

  ChangeEmailState copyWith({
    ApiState? apiState,
    String? email,
    bool? responseSuccess,
  }) {
    return ChangeEmailState(
      apiStatus: apiState ?? apiStatus,
      email: email ?? this.email,
      responseSuccess: responseSuccess ?? this.responseSuccess,
    );
  }
}
