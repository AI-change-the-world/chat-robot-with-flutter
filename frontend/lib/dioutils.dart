import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DioUtil {
  static DioUtil _instance = DioUtil._internal();
  factory DioUtil() => _instance;
  Dio? _dio;

  DioUtil._internal() {
    if (null == _dio) {
      _dio = new Dio();
    }
  }

  ///get请求方法
  get(url, {params, options, cancelToken}) async {
    late Response response;
    try {
      response = await _dio!.get(url,
          queryParameters: params, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      print('getHttp exception: $e');
      formatError(e);
    }
    return response;
  }

  ///put请求方法
  put(url, {data, params, options, cancelToken}) async {
    late Response response;
    try {
      response = await _dio!.put(url,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
    } on DioError catch (e) {
      print('getHttp exception: $e');
      formatError(e);
    }
    return response;
  }

  ///post请求
  post(url, {data, params, options, cancelToken}) async {
    late Response response;
    try {
      response = await _dio!.post(url,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
    } on DioError catch (e) {
      print('getHttp exception: $e');
      formatError(e);
    }
    return response;
  }

  //取消请求
  cancleRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      print("连接超时");
      Fluttertoast.showToast(
          msg: "连接超时",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (e.type == DioErrorType.sendTimeout) {
      print("请求超时");
      Fluttertoast.showToast(
          msg: "请求超时",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (e.type == DioErrorType.receiveTimeout) {
      print("响应超时");
      Fluttertoast.showToast(
          msg: "响应超时",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (e.type == DioErrorType.response) {
      print("出现异常");
      Fluttertoast.showToast(
          msg: "返回结果异常",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (e.type == DioErrorType.cancel) {
      print("请求取消");
      Fluttertoast.showToast(
          msg: "请求取消",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print("未知错误");
      Fluttertoast.showToast(
          msg: "无法连接服务器",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
