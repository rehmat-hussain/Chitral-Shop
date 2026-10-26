import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/tilt_3d_card.dart';
import '../models/product_model.dart';
import '../providers/marketplace_provider.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import '../../seller/screens/seller_dashboard_screen.dart';
import '../../admin/screens/admin_dashboard_screen.dart';

class MarketplaceHomeScreen extends ConsumerStatefulWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  ConsumerState<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends ConsumerState<MarketplaceHomeScreen> {
  int _currentBottomNavIndex = 0;

  final List<String> _chitralLocations = [
    'Chitral Town, Main Shahi Bazaar',
    'Booni, Upper Chitral',
    'Drosh Valley, Lower Chitral',
    'Kalash Valley, Bumburet',
    'Ayun & Garam Chashma Hot Springs',
  ];

  @override
  Widget build(BuildContext context) {
    final selectedLocation = ref.watch(deliveryLocationProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final allProducts = ref.watch(productsListProvider);
    final trendingProducts = ref.watch(trendingProductsProvider);
    final cartNotifier = ref.watch(cartItemsProvider.notifier);
    final cartList = ref.watch(cartItemsProvider);
    final shops = ref.watch(shopsListProvider);

    final categories = ['All', 'Caps & Wool', 'Patti Wool', 'Dry Fruits', 'Pure Honey', 'Gemstones'];

    final filteredProducts = allProducts.where((p) {
      final matchesCategory = (selectedCategory == 'All') || (p.category == selectedCategory);
      final matchesSearch = p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Futuristic Header with Branding & Developer Credit: By Rahmat
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.primaryGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.neonCyan.withOpacity(0.4),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 24),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                                        child: const Text(
                                          'CHITRAL SHOP',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.2,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.neonCyan.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: AppColors.neonCyan.withOpacity(0.4)),
                                        ),
                                        child: const Text(
                                          '3D',
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.neonCyan),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'By Rahmat • Authentic Multi-Vendor Marketplace',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Cart icon with glowing badge
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                            },
                            icon: Badge(
                              isLabelVisible: cartList.isNotEmpty,
                              label: Text('${cartNotifier.itemCount}'),
                              backgroundColor: AppColors.neonCyan,
                              textColor: Colors.black,
                              child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 2. Delivery Location Selector
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.surfaceCard,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        'Select Delivery Location in Chitral',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                    ..._chitralLocations.map((loc) => ListTile(
                                          leading: const Icon(Icons.location_on_outlined, color: AppColors.neonCyan),
                                          title: Text(loc, style: const TextStyle(color: Colors.white)),
                                          trailing: loc == selectedLocation
                                              ? const Icon(Icons.check, color: AppColors.neonCyan)
                                              : null,
                                          onTap: () {
                                            ref.read(deliveryLocationProvider.notifier).state = loc;
                                            Navigator.pop(context);
                                          },
                                        )),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGlass,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: AppColors.neonCyan),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Delivering to: $selectedLocation',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Glowing Search Field
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  child: TextField(
                    onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                      hintText: 'Search Pakol, Patti wool, Chilgoza, Gemstones...',
                      hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: AppColors.neonCyan),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.neonCyan.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.neonCyan.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.neonCyan, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),

              // 4. Categories Selector
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = cat == selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (_) => ref.read(selectedCategoryProvider.notifier).state = cat,
                          selectedColor: AppColors.neonCyan,
                          backgroundColor: AppColors.surfaceCard,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected ? AppColors.neonCyan : Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 5. Promotional 3D Hero Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Tilt3DCard(
                    borderRadius: BorderRadius.circular(18),
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.neonCyan.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'AUTHENTIC CHITRAL',
                                  style: TextStyle(color: AppColors.neonCyan, fontSize: 10, fontWeight: FontWeight.w900),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Hindu Kush Winter Heritage',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Pure Patti wool shawls and Pakols directly from artisan cooperatives.',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.terrain_rounded, size: 54, color: AppColors.neonCyan),
                      ],
                    ),
                  ),
                ),
              ),

              // 6. Dynamic Trending Products Section (Real Purchase Data Engine)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: AppColors.neonCyan, size: 22),
                          const SizedBox(width: 8),
                          const Text(
                            'Trending Now (Real Purchases)',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.neonViolet.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.neonViolet.withOpacity(0.4)),
                        ),
                        child: const Text(
                          'Verified Sales',
                          style: TextStyle(fontSize: 10, color: AppColors.neonViolet, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Horizontal Trending Carousels
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 270,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: trendingProducts.length,
                    itemBuilder: (context, index) {
                      final product = trendingProducts[index];
                      return Container(
                        width: 190,
                        margin: const EdgeInsets.only(right: 14, bottom: 8),
                        child: Tilt3DCard(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
                            );
                          },
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 3D image frame with rank badge
                              Stack(
                                children: [
                                  Container(
                                    height: 110,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundNavy,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.diamond_outlined, size: 48, color: AppColors.neonCyan),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.75),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppColors.goldAccent),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.local_fire_department, size: 12, color: AppColors.goldAccent),
                                          const SizedBox(width: 2),
                                          Text(
                                            '#${index + 1}',
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.goldAccent),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.title,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.shopName,
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                maxLines: 1,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rs. ${product.pricePkr}',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.neonCyan),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      cartNotifier.addProduct(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Added ${product.title} to cart'),
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: AppColors.surfaceCard,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: AppColors.neonCyan,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.add, size: 16, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 7. Popular Multi-Vendor Shops in Chitral
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Shops in Chitral',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerDashboardScreen()));
                        },
                        child: const Text('Vendor Portal', style: TextStyle(color: AppColors.neonCyan, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      final shop = shops[index];
                      return Container(
                        width: 230,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.backgroundNavy,
                                border: Border.all(color: AppColors.neonCyan.withOpacity(0.4)),
                              ),
                              child: const Icon(Icons.storefront_rounded, color: AppColors.neonCyan, size: 24),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          shop.name,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (shop.isVerified)
                                        const Icon(Icons.verified, size: 14, color: AppColors.neonCyan),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    shop.valleyLocation,
                                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${shop.totalSales} orders delivered',
                                    style: const TextStyle(fontSize: 10, color: AppColors.goldAccent),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 8. All Products Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    'All Products (${filteredProducts.length})',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return Tilt3DCard(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
                          );
                        },
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundNavy,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(Icons.view_in_ar, size: 44, color: AppColors.neonCyan),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.title,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              product.category,
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rs. ${product.pricePkr}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.neonCyan),
                                ),
                                GestureDetector(
                                  onTap: () => cartNotifier.addProduct(product),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.neonCyan,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add, size: 14, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentBottomNavIndex,
          selectedItemColor: AppColors.neonCyan,
          unselectedItemColor: AppColors.textSecondary,
          onTap: (index) {
            setState(() => _currentBottomNavIndex = index);
            if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            } else if (index == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerDashboardScreen()));
            } else if (index == 4) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trending'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Sell'),
            BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
          ],
        ),
      ),
    );
  }
}
