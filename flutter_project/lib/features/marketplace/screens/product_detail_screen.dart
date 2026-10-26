import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/tilt_3d_card.dart';
import '../models/product_model.dart';
import '../providers/marketplace_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cartNotifier = ref.read(cartItemsProvider.notifier);

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Custom Top App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      '3D Product Showcase',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3D Perspective interactive container
                      Tilt3DCard(
                        borderRadius: BorderRadius.circular(24),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundNavy,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(Icons.view_in_ar, size: 90, color: AppColors.neonCyan),
                                  Positioned(
                                    bottom: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: AppColors.neonCyan.withOpacity(0.5)),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.touch_app, size: 14, color: AppColors.neonCyan),
                                          SizedBox(width: 4),
                                          Text('Touch & drag to inspect 3D angle', style: TextStyle(color: Colors.white, fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title & Shop details
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.category.toUpperCase(),
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.neonCyan, letterSpacing: 1.1),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.title,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceCard,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.goldAccent),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: AppColors.goldAccent),
                                const SizedBox(width: 4),
                                Text(
                                  '${product.rating}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Price and Trending Signals
                      Row(
                        children: [
                          Text(
                            'Rs. ${product.pricePkr}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.neonCyan),
                          ),
                          if (product.hasDiscount) ...[
                            const SizedBox(width: 10),
                            Text(
                              'Rs. ${product.originalPricePkr}',
                              style: const TextStyle(fontSize: 16, color: AppColors.textTertiary, decoration: TextDecoration.lineThrough),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${product.discountPercent}%',
                                style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Verified Marketplace Activity
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MetricItem(
                              icon: Icons.verified_outlined,
                              label: 'Confirmed Sales',
                              value: '${product.metrics.confirmedOrders7Days}',
                            ),
                            _MetricItem(
                              icon: Icons.inventory_2_outlined,
                              label: 'In Stock',
                              value: '${product.stock} units',
                            ),
                            _MetricItem(
                              icon: Icons.star_rate_rounded,
                              label: 'Buyer Reviews',
                              value: '${product.reviewCount}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        'About this Chitral Craft',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                      ),
                      const SizedBox(height: 20),

                      // Shop Information
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGlass,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.storefront, color: AppColors.neonCyan, size: 26),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.shopName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                                  ),
                                  Text(
                                    product.shopLocation,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar: Quantity & Add to Cart
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
                ),
                child: Row(
                  children: [
                    // Quantity selector
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundNavy,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                            onPressed: () {
                              if (_selectedQuantity > 1) {
                                setState(() => _selectedQuantity--);
                              }
                            },
                          ),
                          Text('$_selectedQuantity', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.add, size: 16, color: Colors.white),
                            onPressed: () {
                              if (_selectedQuantity < product.stock) {
                                setState(() => _selectedQuantity++);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonCyan,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          for (int i = 0; i < _selectedQuantity; i++) {
                            cartNotifier.addProduct(product);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added $_selectedQuantity x ${product.title} to cart'),
                              backgroundColor: AppColors.surfaceCard,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.neonCyan),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }
}
