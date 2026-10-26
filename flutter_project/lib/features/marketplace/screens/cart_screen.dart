import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_background.dart';
import '../providers/marketplace_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartList = ref.watch(cartItemsProvider);
    final cartNotifier = ref.watch(cartItemsProvider.notifier);
    final location = ref.watch(deliveryLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBackground(
        child: cartList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_shopping_cart_outlined, size: 70, color: AppColors.textTertiary),
                    const SizedBox(height: 16),
                    const Text('Your Cart is Empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Explore Chitral handicrafts, Pakol caps, and organic pine nuts!', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        final entry = cartList[index];
                        final product = entry.key;
                        final qty = entry.value;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundNavy,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.view_in_ar, color: AppColors.neonCyan),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 2),
                                    Text('Rs. ${product.pricePkr} x $qty', style: const TextStyle(color: AppColors.neonCyan, fontSize: 12)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                onPressed: () => cartNotifier.removeProduct(product.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Checkout summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.neonCyan),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text('Delivering to: $location', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text('Rs. ${cartNotifier.totalAmount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.neonCyan)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.neonCyan,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                cartNotifier.clearCart();
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: AppColors.surfaceCard,
                                    title: const Text('Order Placed!', style: TextStyle(color: Colors.white)),
                                    content: const Text(
                                      'Shukriya! Your Chitral Shop order has been confirmed. You will receive an SMS tracking code.',
                                      style: TextStyle(color: AppColors.textSecondary),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Back to Shop', style: TextStyle(color: AppColors.neonCyan)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Proceed to Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
