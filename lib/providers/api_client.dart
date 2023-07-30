import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:work_out/common/api_response.dart';
import 'package:work_out/preferences.dart';
import 'package:work_out/providers/api_error.dart';
import 'package:work_out/utils/endpoints.dart';

@injectable
class ApiClient {
  Dio? _dio;

  Preferences? _preference;

  ApiClient(Dio? dio, Preferences preferences) {
    _preference = preferences;

    _dio = dio;
  }

  Future<T> httpGet<T>(String serviceName,
      {Map<String, dynamic>? param}) async {
    Response? response;
    try {
      response = await _dio?.get('${Endpoints.baseUrl}$serviceName',
          queryParameters: param);
      _checkResponseIsOk(response!);
      if (kDebugMode) {
        print(response.data);
      }
    } catch (e) {
      _handleRequestError(e);
    }
    return response?.data as T;
  }

  Future<T> httpGetUrl<T>(String serviceName, String token,
      {Map<String, dynamic>? param}) async {
    Response? response;
    try {
      if (kDebugMode) {
        print(token);
      }
      _dio?.options.connectTimeout = 10000; //5s
      _dio?.options.receiveTimeout = 10000;
      _dio?.options.headers = {
        'Accept': 'application/json',
        'responseType': ResponseType.json,
        'Authorization': token,
      };
      if (kDebugMode) {
        print(_dio?.options.headers);
      }

      response = await _dio?.get('${Endpoints.baseUrl}$serviceName',
          queryParameters: param);
      _checkResponseIsOk(response!);
      if (kDebugMode) {
        print(response.data!);
      }
    } catch (e) {
      _handleRequestError(e);
    }
    return response!.data as T;
  }

  Future<T> httpPost<T>(String serviceName, dynamic data) async {
    Response? response;
    try {
      var token = await _preference?.getString(Preference.accessToken);
      _dio?.options.connectTimeout = 10000; //5s
      _dio?.options.receiveTimeout = 10000;
      if (token == null || token == '') {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
        };
      } else {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
          'Authorization': token,
        };
      }
      response = await _dio?.post(
        '${Endpoints.baseUrl}$serviceName',
        data: data,
      );
      if (kDebugMode) {
        print('****RESPONSE****\n $response');
      }
      _checkResponseIsOk(response!);
    } catch (e) {
      if (kDebugMode) {
        print('****ERROR RESPONSE****\n ${e.toString()}');
      }
      _handleRequestError(e);
    }
    return response?.data as T;
  }

  Future<T> httpPatch<T>(String serviceName, dynamic data) async {
    Response? response;
    try {
      var token = await _preference?.getString(Preference.accessToken);
      _dio?.options.connectTimeout = 10000; //5s
      _dio?.options.receiveTimeout = 10000;
      if (token == null || token == '') {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
        };
      } else {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
          'Authorization': token,
        };
      }
      response = await _dio?.patch(
        '${Endpoints.baseUrl}$serviceName',
        data: data,
      );
      if (kDebugMode) {
        print('****RESPONSE****\n $response');
      }
      _checkResponseIsOk(response!);
    } catch (e) {
      if (kDebugMode) {
        print('****ERROR RESPONSE****\n ${e.toString()}');
      }
      _handleRequestError(e);
    }
    return response?.data as T;
  }

  Future<T> httpPostSendMoney<T>(String serviceName, dynamic data) async {
    Response? response;
    try {
      var token = await _preference?.getString(Preference.accessToken);
      _dio?.options.connectTimeout = 10000; //5s
      _dio?.options.receiveTimeout = 10000;
      if (token == null || token == '') {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
        };
      } else {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
          'Authorization': token,
        };
      }
      response = await _dio?.post(
        '${Endpoints.baseUrl}$serviceName',
        data: data,
      );
      if (kDebugMode) {
        print('****RESPONSE****\n $response');
      }
      _checkResponseIsOk(response!);
    } catch (e) {
      if (kDebugMode) {
        print('****ERROR RESPONSE****\n ${e.toString()}');
      }
      _handleRequestErrorSendMoney(e);
    }
    return response?.data as T;
  }

  void _handleRequestErrorSendMoney(error) {
    try {
      DioError err = error;
      if (err.response?.statusCode == 404 ||
          err.response?.statusCode == 401 ||
          err.response?.statusCode == 402 ||
          err.response?.statusCode == 403 ||
          err.response?.statusCode == 400 ||
          err.response?.statusCode == 405 ||
          err.response?.statusCode == 406 ||
          err.response?.statusCode == 500) {
        if (kDebugMode) {
          print('${err.response}');
        }
        throw ApiErrorResponse(
          status: Status.error,
          statusCode: err.response?.statusCode,
          message: err.response?.data['data'],
        );
      }
      if (error is SocketException) {
        var errorCode = error.osError!.errorCode;
        if (errorCode == 61 ||
            errorCode == 60 ||
            errorCode == 111 ||
            // Network is unreachable
            errorCode == 101 ||
            errorCode == 104 ||
            errorCode == 51 ||
            errorCode == 8 ||
            errorCode == 113 ||
            errorCode == 7 ||
            errorCode == 64) {
          throw ApiConnectionRefusedError(error);
        }
      }

      throw error;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> httpPostUrl<T>(String url, dynamic data, String token) async {
    Response? response;
    try {
      _dio?.options.connectTimeout = 10000; //5s
      _dio?.options.receiveTimeout = 10000;
      _dio?.options.headers = {
        'Accept': 'application/json',
        'responseType': ResponseType.json,
        'Authorization': 'Bearer $token',
      };

      response = await _dio?.post(
        url,
        data: data,
      );
      _checkResponseIsOk(response!);
    } catch (e) {
      _handleRequestError(e);
    }
    return response as T;
  }

  Future<T> httpPostJsonUrl<T>(String url, dynamic data, String token) async {
    Response? response;
    try {
      _dio?.options.connectTimeout = 10000; //5s
      _dio?.options.receiveTimeout = 10000;
      _dio?.options.headers = {
        'Accept': 'application/json',
        'responseType': ResponseType.json,
        'Authorization': 'Bearer $token',
      };

      response = await _dio?.post(
        url,
        data: json.encode(data.toJson()),
      );
      _checkResponseIsOk(response!);
    } catch (e) {
      _handleRequestError(e);
    }
    return response as T;
  }

  Future<T?> httpPut<T>(String serviceName, dynamic data) async {
    Response? response;
    try {
      var token = await _preference?.getString(Preference.accessToken);
      if (token == null || token == '') {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
        };
      } else {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
          'Authorization': token,
        };
      }

      response =
          await _dio?.put('${Endpoints.baseUrl}$serviceName', data: data);

      // response = await _dio?.put(
      //     _environmentHelper?.getValue(EnvironmentKey.BaseUrl!),
      //     data: json.encode(data),
      //     options: Options(
      //         headers: {'Content-Type': 'application/json; charset=utf-8'}));
      _checkResponseIsOk(response!);
    } catch (e) {
      _handleRequestError(e);
    }
    return response?.data as T;
  }

  Future<T> httpDelete<T>(String serviceName,
      {String? token, Map<String, dynamic>? data}) async {
    Response? response;
    try {
      _dio?.options.connectTimeout = 10000; //5s
      _dio?.options.receiveTimeout = 10000;
      if (token == null || token == '') {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
        };
      } else {
        _dio?.options.headers = {
          'Accept': 'application/json',
          'responseType': ResponseType.json,
          'Authorization': token,
        };
      }
      response =
          await _dio?.delete('${Endpoints.baseUrl}$serviceName', data: data);

      if (kDebugMode) {
        print('****RESPONSE****\n $response');
      }
      _checkResponseIsOk(response!);
    } catch (e) {
      if (kDebugMode) {
        print('****ERROR RESPONSE****\n ${e.toString()}');
      }
      _handleRequestError(e);
    }
    return response?.data as T;
  }

  void _checkResponseIsOk(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) return;
    throw ApiError(response);
  }

  void _handleRequestError(error) {
    try {
      DioError err = error;
      if (err.response?.statusCode == 404 ||
          err.response?.statusCode == 401 ||
          err.response?.statusCode == 403 ||
          err.response?.statusCode == 405 ||
          err.response?.statusCode == 406 ||
          err.response?.statusCode == 407 ||
          err.response?.statusCode == 400) {
        if (kDebugMode) {
          print('${err.response}');
          print('${err.response?.data}');
        }

        throw ApiErrorResponse(
          status: Status.error,
          details: (err.response?.data['error'] as List<dynamic>?)
              ?.map((e) => Details.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      if (error is SocketException) {
        var errorCode = error.osError!.errorCode;
        if (errorCode == 61 ||
            errorCode == 60 ||
            errorCode == 111 ||
            // Network is unreachable
            errorCode == 101 ||
            errorCode == 104 ||
            errorCode == 51 ||
            errorCode == 8 ||
            errorCode == 113 ||
            errorCode == 7 ||
            errorCode == 64) {
          throw ApiConnectionRefusedError(error);
        }
      }

      throw error;
    } catch (e) {
      rethrow;
    }
  }
}
