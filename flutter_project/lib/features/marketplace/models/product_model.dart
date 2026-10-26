import '../services/trending_engine.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int pricePkr;
  final int? originalPricePkr;
  final String imageUrl;
  final String shopId;
  final String shopName;
  final String shopLocation;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool is3DSupported;
  final ProductTrendingMetrics metrics;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.pricePkr,
    this.originalPricePkr,
    required this.imageUrl,
    required this.shopId,
    required this.shopName,
    required this.shopLocation,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    this.is3DSupported = true,
    required this.metrics,
  });

  bool get hasDiscount => originalPricePkr != null && originalPricePkr! > pricePkr;
  int get discountPercent => hasDiscount ? (((originalPricePkr! - pricePkr) / originalPricePkr!) * 100).round() : 0;
  double get trendScore => metrics.calculateTrendScore();
}
