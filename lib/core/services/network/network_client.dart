import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

part 'network_response.dart';

class NetworkClient {
  final Logger _logger = Logger();
  final String _defaultErrorMassage = 'Something went massage';

  final VoidCallback onUnAuthorize;
  final Map<String, String> Function() commonHeaders;

  NetworkClient({required this.onUnAuthorize, required this.commonHeaders});

  Future<NetworkResponse> getRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders());
      final Response response = await get(uri, headers: commonHeaders());
      _logResponse(response);

      dynamic responseBody;
      try {
        if (response.body.isNotEmpty) {
          responseBody = jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint('❌ JSON Decode Error: $e');
        debugPrint('❌ Response Body: ${response.body}');
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage: "Server error (${response.statusCode}). Response format is invalid.",
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: responseBody);
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: "Un-authorize");
      } else {
        String? msg;
        if (responseBody is Map) {
          msg = responseBody['msg'] ?? responseBody['message'];
        }
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: msg ?? _defaultErrorMassage);
      }
    } catch (e) {
      debugPrint('❌ Network Request Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMassage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> postRequest(String url,
      {Map<String, dynamic>? body, bool skipAuth = false, Map<String, String>? customHeaders}) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = customHeaders ?? commonHeaders();
      _logRequest(url, headers: headers, body: body);
      final Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      _logResponse(response);

      dynamic responseBody;
      try {
        if (response.body.isNotEmpty) {
          responseBody = jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint('❌ JSON Decode Error: $e');
        debugPrint('❌ Response Body: ${response.body}');
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage: "Server error (${response.statusCode}). Response format is invalid.",
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: responseBody);
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: "Un-authorize");
      } else {
        String? msg;
        if (responseBody is Map) {
          msg = responseBody['msg'] ?? responseBody['message'];
        }
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: msg ?? _defaultErrorMassage);
      }
    } catch (e) {
      debugPrint('❌ Network Request Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMassage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> putRequest(String url,
      {Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders());
      final Response response = await put(
        uri,
        headers: commonHeaders(),
        body: jsonEncode(body),
      );
      _logResponse(response);

      dynamic responseBody;
      try {
        if (response.body.isNotEmpty) {
          responseBody = jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint('❌ JSON Decode Error: $e');
        debugPrint('❌ Response Body: ${response.body}');
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage: "Server error (${response.statusCode}). Response format is invalid.",
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: responseBody);
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: "Un-authorize");
      } else {
        String? msg;
        if (responseBody is Map) {
          msg = responseBody['msg'] ?? responseBody['message'];
        }
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: msg ?? _defaultErrorMassage);
      }
    } catch (e) {
      debugPrint('❌ Network Request Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMassage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> patchRequest(String url,
      {Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders());
      final Response response = await patch(
        uri,
        headers: commonHeaders(),
        body: jsonEncode(body),
      );
      _logResponse(response);

      dynamic responseBody;
      try {
        if (response.body.isNotEmpty) {
          responseBody = jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint('❌ JSON Decode Error: $e');
        debugPrint('❌ Response Body: ${response.body}');
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage: "Server error (${response.statusCode}). Response format is invalid.",
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: responseBody);
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: "Un-authorize");
      } else {
        String? msg;
        if (responseBody is Map) {
          msg = responseBody['msg'] ?? responseBody['message'];
        }
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: msg ?? _defaultErrorMassage);
      }
    } catch (e) {
      debugPrint('❌ Network Request Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMassage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> deleteRequest(String url,
      {Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(
        url,
        headers: commonHeaders(),
      );
      final Response response = await delete(
        uri,
        headers: commonHeaders(),
        body: jsonEncode(body),
      );
      _logResponse(response);

      dynamic responseBody;
      try {
        if (response.body.isNotEmpty) {
          responseBody = jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint('❌ JSON Decode Error: $e');
        debugPrint('❌ Response Body: ${response.body}');
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage: "Server error (${response.statusCode}). Response format is invalid.",
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: responseBody);
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: "Un-authorize");
      } else {
        String? msg;
        if (responseBody is Map) {
          msg = responseBody['msg'] ?? responseBody['message'];
        }
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: msg ?? _defaultErrorMassage);
      }
    } catch (e) {
      debugPrint('❌ Network Request Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMassage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> patchMultipartRequest(
    String url, {
    required Map<String, String> fields,
    Map<String, String>? files, // fieldName : filePath
  }) async {
    try {
      final request = MultipartRequest('PATCH', Uri.parse(url));
      request.headers.addAll(commonHeaders());
      request.fields.addAll(fields);

      if (files != null) {
        for (var entry in files.entries) {
          if (entry.value.isNotEmpty) {
            request.files.add(await MultipartFile.fromPath(entry.key, entry.value));
          }
        }
      }

      _logRequest(url, headers: request.headers, body: fields);
      final streamedResponse = await request.send();
      final response = await Response.fromStream(streamedResponse);
      _logResponse(response);

      dynamic responseBody;
      try {
        if (response.body.isNotEmpty) {
          responseBody = jsonDecode(response.body);
        }
      } catch (e) {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage:
              "Server error (${response.statusCode}). Response format is invalid.",
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
            isSuccess: false, statusCode: 401, errorMassage: "Un-authorize");
      } else {
        String? msg;
        if (responseBody is Map) msg = responseBody['msg'] ?? responseBody['message'];
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: msg ?? _defaultErrorMassage);
      }
    } catch (e) {
      debugPrint('❌ Network Request Error: $e');
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMassage: e.toString());
    }
  }

  void _logRequest(String url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) {
    final String message = '''
    URL -> $url
    HEADERS -> $headers
    BODY -> $body
     ''';

    _logger.i(message);
  }

  void _logResponse(Response response) {
    final String message = '''
    URL -> ${response.request?.url}
    STATUS CODE -> ${response.statusCode}
    HEADERS -> ${response.request?.headers}
    BODY -> ${response.body}
     ''';
    _logger.i(message);
  }
}
