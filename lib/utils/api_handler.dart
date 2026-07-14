import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../config/app_shared_pref.dart';

class ApiHandler {
  static Logger logger = Logger();
  static Dio dio = Dio();

  static Future<Map<String, String>> getHeaders() async {
    String? token = Pref.getToken();
    debugPrint("Token =====> ${token}");
    if (token != null && token.isNotEmpty) {
      return {'Content-Type': 'application/json', 'Accept': '*/*', 'Authorization': "Bearer $token"};
    } else {
      debugPrint("in that");
      return {'Content-Type': 'application/json', 'Accept': '*/*'};
    }
  }

  static Dio createRequest() {
    return Dio(
      BaseOptions(
        validateStatus: (int? statusCode) {
          if (statusCode != null) {
            if (statusCode >= 100 && statusCode <= 500) {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        },
        connectTimeout: const Duration(seconds: 20),
        receiveDataWhenStatusError: true,
      ),
    );
  }

  /// get api
  static Future<Response> getRequest(String url) async {
    logger.i("get $url");

    Response response = await createRequest().get(
      url,
      options: Options(headers: await getHeaders(), responseType: ResponseType.plain),
    );

    logger.i(response);
    return response;
  }

  static Future<Response> deleteRequest(String url) async {
    logger.i("delete $url");

    Response response = await createRequest().delete(
      url,
      options: Options(headers: await getHeaders(), responseType: ResponseType.plain),
    );

    logger.i(response);
    return response;
  }

  /// post api
  static Future<Response> postRequest({required String url, required Map body, Map<String, dynamic>? headers}) async {
    logger.i("post $url");
    logger.i(JsonEncoder.withIndent("" * 4).convert(body));
    Response? response;
    try {
      response = await createRequest().post(
        url,
        data: body,
        options: Options(headers: headers ?? await getHeaders()),
      );
      logger.i(JsonEncoder.withIndent(" " * 4).convert(json.encode(response.data)));
      return response;
    } catch (e) {
      print("error === $e");
      return Response(requestOptions: RequestOptions(data: {"message": "Something went wrong!"}));
    }
  }

  static Future<Response> putRequest({required String url, required Map body, Map<String, dynamic>? headers}) async {
    logger.i("post $url");
    logger.i(JsonEncoder.withIndent("" * 4).convert(body));
    Response? response;
    try {
      response = await createRequest().put(
        url,
        data: body,
        options: Options(headers: headers ?? await getHeaders()),
      );
      logger.i(JsonEncoder.withIndent(" " * 4).convert(json.encode(response.data)));
      return response;
    } catch (e) {
      print("error === $e");
      return Response(requestOptions: RequestOptions(data: {"message": "Something went wrong!"}));
    }
  }

  /// patch api
  static Future<Response> patchRequest({required String url, required Map body, Map<String, dynamic>? headers}) async {
    logger.i("patch $url");
    logger.i(JsonEncoder.withIndent("" * 4).convert(body));
    Response? response;
    try {
      response = await createRequest().patch(
        url,
        data: body,
        options: Options(headers: headers ?? await getHeaders()),
      );
      logger.i(JsonEncoder.withIndent(" " * 4).convert(json.encode(response.data)));
      return response;
    } catch (e) {
      print("error === $e");
      return Response(requestOptions: RequestOptions(data: {"message": "Something went wrong!"}));
    }
  }

  /// post token api
  static Future<Response> postTokenRequest({required String url, required String body}) async {
    logger.i(url);
    logger.i(body);
    // logger.i(JsonEncoder.withIndent(" " * 4).convert(body));
    Response response = await dio.post(
      url,
      data: body,
      options: Options(
        method: 'POST',
        headers: {'accept': '*/*', 'Content-Type': 'application/json', 'Authorization': "Bearer ${Pref.getToken()}"},
        responseType: ResponseType.json,
      ),
    );
    logger.i(response);
    return response;
  }

  static Future<Response> patchTokenRequest({required String url, required String body}) async {
    logger.i(url);
    logger.i(body);
    Response response = await dio.patch(
      url,
      data: body,
      options: Options(
        method: 'POST',
        headers: {'accept': '*/*', 'Content-Type': 'application/json', 'Authorization': "Bearer ${Pref.getToken()}"},
        responseType: ResponseType.plain,
      ),
    );
    logger.i(response);
    return response;
  }

  /*  static Future<Response> multipartRequest(String filePath) async {
    var data = FormData.fromMap({'files': await MultipartFile.fromFile(filePath), 'foldername': 'opportunity-logs'});


    var response = await dio.request(
      'https://traderpuatapi.cygnux.in/api/v1/file/upload',
      options: Options(method: 'POST', headers: await getHeaders(), contentType: 'multipart/form-data',),
      data: data,
    );

    return response;
  }  */
  static Future<Response> uploadFile(File file, {String folderName = 'Opportunity'}) async {
    debugPrint("file path ===${file.path}");
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({"foldername": folderName, "file": await MultipartFile.fromFile(file.path, filename: fileName)});

    var headers = await getHeaders();
    headers.remove('Content-Type'); // Important: Remove Content-Type for Multipart requests

    return await createRequest().post(
      'https://tradeapi.cygnux.in/api/v1/file/upload',
      data: formData,
      options: Options(headers: headers),
    );
  }
}

bool isUnAuthorized(Response response) {
  final int statusCode = response.statusCode!;
  if (statusCode == 401) return true;
  return false;
}
