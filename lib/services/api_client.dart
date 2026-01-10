import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<dynamic> get(String url) async => _process(await http.get(Uri.parse(url)));

  Future<dynamic> post(String url, Map<String, dynamic> body) async =>
      _process(await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: jsonEncode(body)));

  Future<dynamic> put(String url, Map<String, dynamic> body) async =>
      _process(await http.put(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: jsonEncode(body)));

  Future<dynamic> delete(String url) async => _process(await http.delete(Uri.parse(url)));

  dynamic _process(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    }
    throw Exception('API error ${res.statusCode}: ${res.body}');
  }
}
