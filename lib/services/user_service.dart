import '../config.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _api = ApiClient();

  Future<List<dynamic>> fetchUsers() async {
    final res = await _api.get('${Config.userBase}/users');
    final data = (res is Map<String, dynamic>) ? res['data'] : null;
    return data is List ? data : [];
  }

  // CREATE tanpa password
  Future<void> createUser(String name, String email, String role) async {
    await _api.post('${Config.userBase}/users', {
      'name': name,
      'email': email,
      'role': role,
    });
  }

  Future<void> updateUser(String id, {String? name, String? email, String? role}) async {
    await _api.put('${Config.userBase}/users/$id', {
      'name': name,
      'email': email,
      'role': role,
    });
  }

  Future<void> deleteUser(String id) async {
    await _api.delete('${Config.userBase}/users/$id');
  }
}
