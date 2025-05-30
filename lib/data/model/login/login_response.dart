import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// LoginResponse model.
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    /// The token to be used for authentication.
    required String token,

    /// The user id.
    required String username,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, Object?> json) =>
      _$LoginResponseFromJson(json);
}
