import 'dart:math';

class ProductTrendingMetrics {
  final String productId;
  final int confirmedOrders7Days;
  final int unitsSoldRecent;
  final int uniqueBuyers;
  final double conversionRate; // e.g. 0.05 = 5%
  final double averageRating; // 1.0 to 5.0
  final int totalVerifiedReviews;
  final int recentViewsAndClicks;
  final int cancelledOrReturnedOrders;
  final int stockAvailable;

  const ProductTrendingMetrics({
    required this.productId,
    required this.confirmedOrders7Days,
    required this.unitsSoldRecent,
    required this.uniqueBuyers,
    required this.conversionRate,
    required this.averageRating,
    required this.totalVerifiedReviews,
    required this.recentViewsAndClicks,
    required this.cancelledOrReturnedOrders,
    required this.stockAvailable,
  });

  /// Mathematical Scoring Formula for Genuine Trend Calculation:
  ///
  /// Weights:
  /// - 35% Confirmed Purchases (primary signal)
  /// - 25% Recent Units Sold (weighted volume)
  /// - 15% Unique Purchasing Customers (anti-bot protection)
  /// - 10% Conversion Rate (interest-to-purchase efficiency)
  /// - 10% Rating Quality (review count dampened by Bayesian average)
  /// - 05% Engagement Activity (views/add-to-cart)
  ///
  /// Penalties:
  /// - Fraud/Cancellation rate deduction
  /// - Out-of-stock damping (prevents dead trends)
  double calculateTrendScore() {
    if (stockAvailable <= 0) return 0.0;

    // 1. Normalized purchase volume with logarithmic dampening
    final double purchaseScore = log(1 + confirmedOrders7Days) * 35.0;

    // 2. Units sold score
    final double unitsScore = log(1 + unitsSoldRecent) * 25.0;

    // 3. Unique buyer ratio (Anti-sybil: penalizes single-buyer repeat spam)
    final double buyerRatio = confirmedOrders7Days > 0
        ? (uniqueBuyers / confirmedOrders7Days).clamp(0.0, 1.0)
        : 0.0;
    final double uniqueBuyerScore = buyerRatio * 15.0;

    // 4. Conversion rate factor
    final double conversionScore = (conversionRate.clamp(0.0, 0.5) / 0.5) * 10.0;

    // 5. Rating score dampened by review quantity
    final double ratingConfidence = (totalVerifiedReviews / (totalVerifiedReviews + 5.0));
    final double ratingScore = (averageRating / 5.0) * ratingConfidence * 10.0;

    // 6. Engagement score
    final double engagementScore = log(1 + recentViewsAndClicks) * 5.0;

    // 7. Fraud and return deduction
    final double returnPenalty = (cancelledOrReturnedOrders * 4.0);

    final double rawScore = (purchaseScore + unitsScore + uniqueBuyerScore + conversionScore + ratingScore + engagementScore) - returnPenalty;

    return max(0.0, rawScore);
  }
}

class TrendingEngine {
  static List<T> rankProducts<T>({
    required List<T> items,
    required ProductTrendingMetrics Function(T) getMetrics,
  }) {
    final scoredItems = items.map((item) {
      final metrics = getMetrics(item);
      final score = metrics.calculateTrendScore();
      return MapEntry(item, score);
    }).toList();

    scoredItems.sort((a, b) => b.value.compareTo(a.value));
    return scoredItems.map((entry) => entry.key).toList();
  }
}
