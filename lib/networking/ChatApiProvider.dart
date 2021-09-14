import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'CustomException.dart';

class ChatApiProvider {
  String _baseUrl = "";

  ChatApiProvider(String baseUrl) {
    this._baseUrl = baseUrl;
  }

  Future<dynamic> get(String url, {Map header}) async {
    debugPrint('Base Url ==> GET ${_baseUrl + url}');
    debugPrint('Headers ==> ${json.encode(header).toString()}');

    var responseJson;
    try {
      final response = await http
          .get(Uri.parse(_baseUrl + url), headers: header)
          .timeout(const Duration(seconds: 40));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      // A timeout occurred.
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, {Map body, Map header}) async {
    debugPrint('Base Url ==> POST ${_baseUrl + url}');
    debugPrint('Request Body ==> ${json.encode(body).toString()}');
    debugPrint('Headers ==> ${json.encode(header).toString()}');

    var responseJson;
    try {
      final response = await http
          .post(Uri.parse(_baseUrl + url),
              body: json.encode(body), headers: header)
          .timeout(const Duration(seconds: 40));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      // A timeout occurred.
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, {Map body, Map header}) async {
    debugPrint('Base Url ==> PUT ${_baseUrl + url}');
    debugPrint('Request Body ==> ${json.encode(body).toString()}');
    debugPrint('Headers ==> ${json.encode(header).toString()}');

    var responseJson;
    try {
      final response = await http
          .put(Uri.parse(_baseUrl + url),
              body: json.encode(body), headers: header)
          .timeout(const Duration(seconds: 40));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      // A timeout occurred.
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url, {Map header}) async {
    debugPrint('Base Url ==> DELETE ${_baseUrl + url}');
    debugPrint('Headers ==> ${json.encode(header).toString()}');

    var responseJson;
    try {
      final response = await http
          .delete(Uri.parse(_baseUrl + url), headers: header)
          .timeout(const Duration(seconds: 40));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      // A timeout occurred.
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 400:
      case 401:
      case 403:
      //case 404:
      case 500:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;

      default:
        var code = response.statusCode.toString();
        print('Status_Code ${code.toString()}');
        throw FetchDataException('Opps! Something wents wrong.');

//      case 400:
//        throw BadRequestException(response.body.toString());
//      case 401:
//
//      case 403:
//        throw UnauthorisedException(response.body.toString());
//      case 500:
//
//      default:
//        throw FetchDataException(
//            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  // Future<dynamic> _upload(String filename, String url) async {
  //
  //   var responseJson;
  //   try {
  //   var request = http.MultipartRequest('POST', Uri.parse(_baseUrl+'/resources/upload/'),);
  //   request.files.add(
  //       await http.MultipartFile.fromPath(
  //           'name',
  //           filename
  //       )
  //   );
  //   final res = await request.send();
  //   responseJson = _response(res.stream.bytesToString());
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   } on TimeoutException catch (_) {
  //     // A timeout occurred.
  //     throw FetchDataException('No Internet connection');
  //   }
  //   return responseJson;
  // }

  multipart(String url, {String filePath, Map header}) async {
    debugPrint('Base Url ==> POST ${_baseUrl + url}');
    debugPrint('Request File Path ==> ${filePath}');
    debugPrint('Headers ==> ${json.encode(header).toString()}');

    var responseJson;
    try {
      var postUri = Uri.parse(_baseUrl + url);
      var request = new http.MultipartRequest("POST", postUri);
      request.headers.addAll(header);
      request.files.add(new http.MultipartFile.fromBytes(
          'name', await File.fromUri(Uri.parse(filePath)).readAsBytes()));

      request
          .send()
          .then((response) async {
            /* try {
          var responseFinal = await http.Response.fromStream(response);
          responseJson = _response(responseFinal);
        } on CustomException{
          debugPrint("test");
        }*/

            if (response.statusCode == 200) {
              final respStr = await response.stream.bytesToString();
              debugPrint("Uploded " + respStr);
              responseJson = respStr;
            }

            /*http.Response.fromStream(response)
            .then((response) {

          if (response.statusCode == 200)
          {
            print("Uploaded! ");
            print('response.body '+response.body);
          }

          return response.body;

        });*/
          })
          .catchError((err) => print('error : ' + err.toString()))
          .whenComplete(() {});
      ;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      // A timeout occurred.
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  String getBaseUrl() {
    return _baseUrl;
  }
}
