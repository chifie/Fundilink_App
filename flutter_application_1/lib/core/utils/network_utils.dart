import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// Utility class for network-related operations and connectivity checks.
class NetworkUtils {
  NetworkUtils._();

  /// Get the current network connectivity status.
  static Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Check connectivity with a timeout.
  static Future<bool> checkConnectivity({
    Duration timeout = const Duration(seconds: 5),
    String host = '8.8.8.8',
  }) async {
    try {
      final address = InternetAddress(host);
      final result = await Socket.connect(
        address,
        53, // DNS port
        timeout: timeout,
      ).then((socket) {
        socket.destroy();
        return true;
      }).catchError((_) => false);
      return result;
    } catch (_) {
      return false;
    }
  }

  /// Create a network-aware HTTP client.
  static http.Client createNetworkAwareClient({
    Duration? timeout,
    Map<String, String>? headers,
    bool followRedirects = true,
    int maxRedirects = 5,
  }) {
    final client = http.Client();
    return client;
  }

  /// Perform a GET request with error handling.
  static Future<NetworkResponse<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    T Function(dynamic)? parser,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(timeout);

      if (parser != null) {
        return NetworkResponse.success(
          parser(response.body),
          response.statusCode,
          response.headers,
        );
      }

      return NetworkResponse.success(
        response.body,
        response.statusCode,
        response.headers,
      );
    } on SocketException {
      return NetworkResponse.error(
        'No internet connection',
        statusCode: 0,
        isNetworkError: true,
      );
    } on TimeoutException {
      return NetworkResponse.error(
        'Request timed out',
        statusCode: 0,
        isNetworkError: true,
      );
    } on FormatException {
      return NetworkResponse.error(
        'Invalid response format',
        statusCode: 0,
        isNetworkError: true,
      );
    } catch (e) {
      return NetworkResponse.error(
        e.toString(),
        statusCode: 500,
        isNetworkError: true,
      );
    }
  }

  /// Perform a POST request with error handling.
  static Future<NetworkResponse<T>> post<T>(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic)? parser,
    Duration timeout = const Duration(seconds: 30),
    String? contentType,
  }) async {
    try {
      final headersMap = <String, String>{};
      if (headers != null) {
        headersMap.addAll(headers);
      }
      
      if (contentType != null) {
        headersMap['Content-Type'] = contentType;
      } else if (body != null && headersMap['Content-Type'] == null) {
        headersMap['Content-Type'] = 'application/json';
      }

      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: headersMap,
      ).timeout(timeout);

      if (parser != null) {
        return NetworkResponse.success(
          parser(response.body),
          response.statusCode,
          response.headers,
        );
      }

      return NetworkResponse.success(
        response.body,
        response.statusCode,
        response.headers,
      );
    } on SocketException {
      return NetworkResponse.error(
        'No internet connection',
        statusCode: 0,
        isNetworkError: true,
      );
    } on TimeoutException {
      return NetworkResponse.error(
        'Request timed out',
        statusCode: 0,
        isNetworkError: true,
      );
    } catch (e) {
      return NetworkResponse.error(
        e.toString(),
        statusCode: 500,
        isNetworkError: true,
      );
    }
  }

  /// Perform a PUT request with error handling.
  static Future<NetworkResponse<T>> put<T>(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic)? parser,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return post<T>(
      url,
      body: body,
      headers: headers,
      parser: parser,
      timeout: timeout,
    );
  }

  /// Perform a DELETE request with error handling.
  static Future<NetworkResponse<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
    T Function(dynamic)? parser,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      ).timeout(timeout);

      if (parser != null) {
        return NetworkResponse.success(
          parser(response.body),
          response.statusCode,
          response.headers,
        );
      }

      return NetworkResponse.success(
        response.body,
        response.statusCode,
        response.headers,
      );
    } on SocketException {
      return NetworkResponse.error(
        'No internet connection',
        statusCode: 0,
        isNetworkError: true,
      );
    } on TimeoutException {
      return NetworkResponse.error(
        'Request timed out',
        statusCode: 0,
        isNetworkError: true,
      );
    } catch (e) {
      return NetworkResponse.error(
        e.toString(),
        statusCode: 500,
        isNetworkError: true,
      );
    }
  }

  /// Download a file with progress callback.
  static Future<NetworkResponse<Uint8List>> downloadFile(
    String url, {
    Map<String, String>? headers,
    void Function(int received, int total)? onProgress,
    Duration timeout = const Duration(minutes: 5),
  }) async {
    try {
      final request = http.Request('GET', Uri.parse(url));
      if (headers != null) {
        request.headers.addAll(headers);
      }

      final streamedResponse = await request.send().timeout(timeout);

      if (streamedResponse.statusCode != 200) {
        return NetworkResponse.error(
          'Failed to download file: ${streamedResponse.statusCode}',
          statusCode: streamedResponse.statusCode,
        );
      }

      final chunks = <Uint8List>[];
      int totalBytes = streamedResponse.contentLength ?? 0;
      int receivedBytes = 0;

      await for (final chunk in streamedResponse.stream.toList().then(
            (list) async {
              for (final c in list) {
                chunks.add(c);
                receivedBytes += c.length;
                onProgress?.call(receivedBytes, totalBytes);
              }
            },
          ),
        );

      final bytes = Uint8List.fromList(chunks.expand((i) => i).toList());

      return NetworkResponse.success(
        bytes,
        streamedResponse.statusCode,
        streamedResponse.headers,
      );
    } on SocketException {
      return NetworkResponse.error(
        'No internet connection',
        statusCode: 0,
        isNetworkError: true,
      );
    } on TimeoutException {
      return NetworkResponse.error(
        'Download timed out',
        statusCode: 0,
        isNetworkError: true,
      );
    } catch (e) {
      return NetworkResponse.error(
        e.toString(),
        statusCode: 500,
        isNetworkError: true,
      );
    }
  }

  /// Check if a URL is reachable.
  static Future<bool> isUrlReachable(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  /// Retry a function with exponential backoff.
  static Future<T> retry<T>({
    required Future<T> Function() action,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    Duration maxDelay = const Duration(seconds: 30),
    bool retryOnNetworkError = true,
    bool retryOnTimeout = true,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await action();
      } catch (e) {
        attempt++;

        if (attempt > maxRetries) {
          rethrow;
        }

        final isNetworkError = e is SocketException ||
            e is TimeoutException ||
            (e.toString().contains('SocketException') ||
                e.toString().contains('TimeoutException'));

        final shouldRetry = (retryOnNetworkError && isNetworkError) ||
            (retryOnTimeout && e is TimeoutException) ||
            attempt <= maxRetries;

        if (!shouldRetry) {
          rethrow;
        }

        await Future.delayed(delay);
        delay = Duration(
          milliseconds: (delay.inMilliseconds * 2).clamp(
            initialDelay.inMilliseconds,
            maxDelay.inMilliseconds,
          ),
        );
      }
    }
  }
}

/// A response wrapper that indicates success or failure.
class NetworkResponse<T> {
  final T? data;
  final String? error;
  final int statusCode;
  final Map<String, String>? headers;
  final bool isNetworkError;

  NetworkResponse._({
    this.data,
    this.error,
    required this.statusCode,
    this.headers,
    this.isNetworkError = false,
  });

  /// Creates a successful response.
  factory NetworkResponse.success(
    T data,
    int statusCode,
    Map<String, String>? headers,
  ) {
    return NetworkResponse._(
      data: data,
      statusCode: statusCode,
      headers: headers,
      isNetworkError: false,
    );
  }

  /// Creates an error response.
  factory NetworkResponse.error(
    String message, {
    int statusCode = 0,
    Map<String, String>? headers,
    bool isNetworkError = false,
  }) {
    return NetworkResponse._(
      error: message,
      statusCode: statusCode,
      headers: headers,
      isNetworkError: isNetworkError,
    );
  }

  /// Whether the response was successful.
  bool get isSuccess => data != null && error == null;

  /// Whether the response was an error.
  bool get isError => error != null;

  /// The error message if any.
  String? get errorMessage => error;

  /// Get the data or throw if error.
  T get dataOrThrow {
    if (error != null) {
      throw NetworkException(
        error!,
        statusCode: statusCode,
        isNetworkError: isNetworkError,
      );
    }
    return data!;
  }
}

/// Exception thrown for network errors.
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final bool isNetworkError;
  final String? type;

  NetworkException(
    this.message, {
    this.statusCode,
    this.isNetworkError = false,
    this.type,
  });

  @override
  String toString() => 'NetworkException: $message (status: $statusCode)';
}
