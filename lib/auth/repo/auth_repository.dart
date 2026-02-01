import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/app/token_service.dart';

class AuthRepository {
  final NetworkClient _client;

  AuthRepository(this._client);

  Future<NetworkResponse> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _client.postRequest(
      ApiUrls.register,
      body: {
        "name": name,
        "email": email,
        "password": password,
      },
    );
  }

  Future<NetworkResponse> login({
    required String email,
    required String password,
  }) {
    return _client.postRequest(
      ApiUrls.login,
      body: {
        "email": email,
        "password": password,
      },
    );
  }

  Future<NetworkResponse> verifyOtp({
    required String email,
    required String otp,
  }) {
    return _client.postRequest(
      ApiUrls.otpVerify,
      body: {
        "email": email,
        "otp": otp,
      },
    );
  }

  /// 🔄 REFRESH TOKEN
  Future<NetworkResponse> refreshToken({
    required String refreshToken,
  }) {
    return _client.postRequest(
      ApiUrls.refreshToken,
      body: {
        "refreshToken": refreshToken,
      },
    );
  }

}
