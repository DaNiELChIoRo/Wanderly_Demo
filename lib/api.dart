import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart'
import 'package:demo_wander/storage.dart';

class ApiClient {
  final _baseLoginUrl = "https://wapi.wanderly.dev";
  final _baseUrl = "https://wapi.staging.wanderly.dev";

  var _token = "";

  getHeaders(String? token) {
    token ??= _token;
    return {
      // Adding authorization
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'wap_access_token': '',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
      'X-WANDA-APPNAME': 'Recruit',
      'Accept-Encoding': 'br;q=1.0, gzip;q=0.9, deflate;q=0.8'
    };
  }

  bool get isAuth => _token.isNotEmpty;

  static final ApiClient _singleton = ApiClient._internal();

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal();

  Map<String, dynamic> validate(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // print('response from network getChatToken: $response');
      return jsonDecode(response.body); //['data']['token'].toString();
    } else {
      // throw Exception('Failed to load album');
      print('error from network getChatToken: $response');
      final error = jsonDecode(response.body)['message'] ?? '';
      throw Exception('unvalid response status code: $error');
    }
  }

  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    print('username: $username , password: $password');
    final url = '$_baseLoginUrl/api/v1/auth/login/';
    var params = {
      'email': username,
      'password': password,
    };
    final response = await http.post(Uri.parse(url), body: params);
    print('response from network: $response');
    var json = jsonDecode(response.body);
    _token = json['user']['accessToken'];
    return jsonDecode(response.body);
    // return response;
  }

  Future<String> getAccessToken(String? token) async {
    final url = '$_baseLoginUrl/api/v1/auth/me';
    final response = await http.get(Uri.parse(url), headers: getHeaders(token));

    print('response from network getAccessToken: $response');
    return jsonDecode(response.body)['accessToken'].toString();
  }

  Future<String> getChatToken(String? token) async {
    final url = '$_baseLoginUrl/api/v1/chat-token';
    final response = await http
        .get(Uri.parse(url), headers: getHeaders(token))
        .catchError(
            (error) => {print('error from network getChatToken: $error')});
    print('response from network getChatToken: $response');
    return jsonDecode(response.body)['data']['token'].toString();
  }

  Future<List<Recruiter>> getUsers(String? token) async {
    // final url =
    // '$_baseUrl/api/v1/candidates?archived=false&favorite=false&my_candidate=all&order_by=last_login&page=1&propose=false&time_limit=all_time';
    final body = {
      "archived": 'false',
      "favorite": 'false',
      "my_candidate": "all",
      "order_by": "last_login",
      "page": '1',
      "propose": 'false',
      "time_limit": "all_time"
    };
    final url = Uri.https('wapi.wanderly.dev', '/api/v1/candidates', body);
    final response =
        await http.get(url, headers: getHeaders(token)).catchError((error) {
      print('error from network getUsers: $error');
      // print('stackTrace from network getUsers: $stackTrace')
      throw Exception('error from network getUsers: $error');
    });
    print('response from network getUsers: $response');

    final json = validate(response);
    // Encode the body to Recuiter List
    print('json from network getUsers: $json');
    final List<Recruiter> users = json['data']['candidates']
        .map<Recruiter>((json) => Recruiter.fromJSON(json))
        .toList();
    return users;
    // return jsonDecode(response.body).;
  }
}

class Recruiter {
  int? id;
  String? full_name;
  String? image;
  String? first_name;
  String? last_name;
  String? firstname;
  String? lastname;

  Recruiter(
      {this.id,
      this.full_name,
      this.image,
      this.first_name,
      this.last_name,
      this.firstname,
      this.lastname});

  factory Recruiter.fromJSON(Map<String, dynamic> json) {
    return Recruiter(
      id: json['id'],
      full_name: json['full_name'],
      image: json['image'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}
