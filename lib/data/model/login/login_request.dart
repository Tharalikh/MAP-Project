import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';

part 'login_request.g.dart';

/// Simple data class to hold login request data.
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    /// Email address.
    required String username,

    /// Plain text password.
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, Object?> json) =>
      _$LoginRequestFromJson(json);
}
