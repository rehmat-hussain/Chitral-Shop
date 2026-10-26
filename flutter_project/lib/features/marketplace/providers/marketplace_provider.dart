import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../models/shop_model.dart';
import '../services/trending_engine.dart';

final deliveryLocationProvider = StateProvider<String>((ref) => 'Chitral Town, Main Bazaar');

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final searchQueryProvider = StateProvider<String>((ref) => '');

final cartItemsProvider = StateNotifierProvider<CartNotifier, List<MapEntry<ProductModel, int>>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<MapEntry<ProductModel, int>>> {
  CartNotifier() : super([]);

  void addProduct(ProductModel product) {
    final index = state.indexWhere((e) => e.key.id == product.id);
    if (index >= 0) {
      final current = state[index];
      state = [
        ...state.sublist(0, index),
        MapEntry(current.key, current.value + 1),
        ...state.sublist(index + 1),
      ];
    } else {
      state = [...state, MapEntry(product, 1)];
    }
  }

  void removeProduct(String productId) {
    state = state.where((e) => e.key.id != productId).toList();
  }

  void clearCart() {
    state = [];
  }

  int get totalAmount => state.fold(0, (sum, item) => sum + (item.key.pricePkr * item.value));
  int get itemCount => state.fold(0, (sum, item) => sum + item.value);
}

final productsListProvider = Provider<List<ProductModel>>((ref) {
  return [
    ProductModel(
      id: 'p1',
      title: 'Hand-Rolled Chitrali Pakol Cap',
      description: 'Handcrafted from 100% pure mountain sheep wool with natural peacock feather accent. Made in historic Shahi Bazaar.',
      category: 'Caps & Wool',
      pricePkr: 1800,
      originalPricePkr: 2200,
      imageUrl: 'assets/icons/images/chitral_logo.png',
      shopId: 's1',
      shopName: 'Shahi Bazaar Traditional Crafts',
      shopLocation: 'Shahi Bazaar, Chitral Town',
      rating: 4.9,
      reviewCount: 142,
      stock: 45,
      metrics: const ProductTrendingMetrics(
        productId: 'p1',
        confirmedOrders7Days: 84,
        unitsSoldRecent: 112,
        uniqueBuyers: 79,
        conversionRate: 0.18,
        averageRating: 4.9,
        totalVerifiedReviews: 142,
        recentViewsAndClicks: 820,
        cancelledOrReturnedOrders: 1,
        stockAvailable: 45,
      ),
    ),
    ProductModel(
      id: 'p2',
      title: 'Chitral Patti Chugha Woolen Shawl',
      description: 'Heavy winter ceremonial shawl handspun in Kalash Valley using traditional wooden pit looms.',
      category: 'Patti Wool',
      pricePkr: 8900,
      originalPricePkr: 11500,
      imageUrl: 'assets/icons/images/chitral_logo.png',
      shopId: 's2',
      shopName: 'Bumburet Kalash Artisans',
      shopLocation: 'Bumburet, Kalash Valley',
      rating: 5.0,
      reviewCount: 68,
      stock: 12,
      metrics: const ProductTrendingMetrics(
        productId: 'p2',
        confirmedOrders7Days: 42,
        unitsSoldRecent: 46,
        uniqueBuyers: 40,
        conversionRate: 0.22,
        averageRating: 5.0,
        totalVerifiedReviews: 68,
        recentViewsAndClicks: 430,
        cancelledOrReturnedOrders: 0,
        stockAvailable: 12,
      ),
    ),
    ProductModel(
      id: 'p3',
      title: 'Organic Roasted Chilgoza (Pine Nuts) 500g',
      description: 'Wild forest pine nuts harvested by hand in Golen Valley. Rich in essential oils and crunchy natural flavor.',
      category: 'Dry Fruits',
      pricePkr: 4900,
      originalPricePkr: 5500,
      imageUrl: 'assets/icons/images/chitral_logo.png',
      shopId: 's3',
      shopName: 'Golen Valley Natural Organics',
      shopLocation: 'Golen Valley, Chitral',
      rating: 4.8,
      reviewCount: 95,
      stock: 60,
      metrics: const ProductTrendingMetrics(
        productId: 'p3',
        confirmedOrders7Days: 65,
        unitsSoldRecent: 88,
        uniqueBuyers: 61,
        conversionRate: 0.16,
        averageRating: 4.8,
        totalVerifiedReviews: 95,
        recentViewsAndClicks: 610,
        cancelledOrReturnedOrders: 2,
        stockAvailable: 60,
      ),
    ),
    ProductModel(
      id: 'p4',
      title: 'Tirich Mir Wild Mountain Honey (1kg)',
      description: 'Raw unpasteurized honey gathered from wild high-altitude mountain flora around Mount Tirich Mir.',
      category: 'Pure Honey',
      pricePkr: 2900,
      originalPricePkr: 3400,
      imageUrl: 'assets/icons/images/chitral_logo.png',
      shopId: 's4',
      shopName: 'Hindukush Apiaries',
      shopLocation: 'Drosh, Lower Chitral',
      rating: 4.9,
      reviewCount: 110,
      stock: 30,
      metrics: const ProductTrendingMetrics(
        productId: 'p4',
        confirmedOrders7Days: 52,
        unitsSoldRecent: 70,
        uniqueBuyers: 49,
        conversionRate: 0.19,
        averageRating: 4.9,
        totalVerifiedReviews: 110,
        recentViewsAndClicks: 520,
        cancelledOrReturnedOrders: 1,
        stockAvailable: 30,
      ),
    ),
    ProductModel(
      id: 'p5',
      title: 'Natural Chitral Aquamarine Specimen',
      description: 'Hexagonal untreated blue beryl crystal on mica matrix, extracted from pegmatites in Chitral.',
      category: 'Gemstones',
      pricePkr: 14500,
      originalPricePkr: 18000,
      imageUrl: 'assets/icons/images/chitral_logo.png',
      shopId: 's5',
      shopName: 'Pamir Minerals & Gems',
      shopLocation: 'Booni, Upper Chitral',
      rating: 4.9,
      reviewCount: 32,
      stock: 5,
      metrics: const ProductTrendingMetrics(
        productId: 'p5',
        confirmedOrders7Days: 18,
        unitsSoldRecent: 19,
        uniqueBuyers: 17,
        conversionRate: 0.11,
        averageRating: 4.9,
        totalVerifiedReviews: 32,
        recentViewsAndClicks: 390,
        cancelledOrReturnedOrders: 0,
        stockAvailable: 5,
      ),
    ),
  ];
});

final trendingProductsProvider = Provider<List<ProductModel>>((ref) {
  final all = ref.watch(productsListProvider);
  return TrendingEngine.rankProducts(
    items: all,
    getMetrics: (p) => p.metrics,
  );
});

final shopsListProvider = Provider<List<ShopModel>>((ref) {
  return const [
    ShopModel(
      id: 's1',
      name: 'Shahi Bazaar Traditional Crafts',
      valleyLocation: 'Shahi Bazaar, Chitral',
      ownerName: 'Sher Afzal Khan',
      bannerImageUrl: 'assets/icons/images/chitral_logo.png',
      rating: 4.9,
      totalSales: 840,
      isVerified: true,
      specialty: 'Handcrafted Pakol & Embroidered Waistcoats',
    ),
    ShopModel(
      id: 's2',
      name: 'Bumburet Kalash Artisans',
      valleyLocation: 'Kalash Valley',
      ownerName: 'Yasmin Gul',
      bannerImageUrl: 'assets/icons/images/chitral_logo.png',
      rating: 5.0,
      totalSales: 490,
      isVerified: true,
      specialty: 'Handwoven Patti Wool & Traditional Beads',
    ),
    ShopModel(
      id: 's3',
      name: 'Golen Valley Natural Organics',
      valleyLocation: 'Golen Valley',
      ownerName: 'Fazal Karim',
      bannerImageUrl: 'assets/icons/images/chitral_logo.png',
      rating: 4.8,
      totalSales: 1250,
      isVerified: true,
      specialty: 'Chilgoza, Walnuts & Pure Salajeet',
    ),
  ];
});
