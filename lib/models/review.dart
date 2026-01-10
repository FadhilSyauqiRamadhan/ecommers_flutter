class Review {
  final String id;
  final String productId;
  final String userId;
  final int rating;
  final String comment;

  Review({required this.id, required this.productId, required this.userId, required this.rating, required this.comment});

  factory Review.fromJson(Map<String, dynamic> j) => Review(
        id: j['id']?.toString() ?? '',
        productId: j['productId']?.toString() ?? '',
        userId: j['userId']?.toString() ?? '',
        rating: (j['rating'] is int) ? j['rating'] : int.tryParse('${j['rating']}') ?? 0,
        comment: j['comment'] ?? '',
      );
}
