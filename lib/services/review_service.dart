import '../config.dart';
import 'api_client.dart';

class ReviewService {
  final ApiClient _api = ApiClient();

  Future<List<dynamic>> fetchReviews(int productId) async {
    final res = await _api.get('${Config.reviewBase}/reviews/$productId');
    final data = (res is Map<String, dynamic>) ? res['data'] : null;
    return data is List ? data : [];
  }

  Future<void> postReview(int productId, int rating, String comment) async {
    await _api.post('${Config.reviewBase}/reviews', {
      'product_id': productId,
      'review': comment,
      'rating': rating,
    });
  }
}
