import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_background.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace Super Admin', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4C1D95), Color(0xFF1E1B4B)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.neonViolet.withOpacity(0.5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.security_rounded, size: 36, color: AppColors.neonCyan),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Super Admin Control Panel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Role-enforced Appwrite Security • Chitral Shop', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Pending Vendor Applications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),

              _VendorApprovalCard(
                shopName: 'Tirich Mir Wool Works',
                location: 'Koghuzi, Upper Chitral',
                owner: 'Ghulam Rasool',
                specialty: 'Handwoven Patti Fabric',
              ),
              _VendorApprovalCard(
                shopName: 'Kalash Gem Mining Co.',
                location: 'Rumbur Valley',
                owner: 'Sardar Wali',
                specialty: 'Tourmaline & Mineral Specimen',
              ),
              const SizedBox(height: 24),

              const Text('Trending Engine Health', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: const Column(
                  children: [
                    _HealthRow(label: 'Anti-Sybil Purchase Filter', status: 'Active (100% Unique Buyer Checked)'),
                    Divider(color: Colors.white10),
                    _HealthRow(label: 'Order Verification Window', status: '7-Day Rolling Decay'),
                    Divider(color: Colors.white10),
                    _HealthRow(label: 'Appwrite Realtime Sync', status: 'Online (Connected)'),
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

class _VendorApprovalCard extends StatelessWidget {
  final String shopName;
  final String location;
  final String owner;
  final String specialty;

  const _VendorApprovalCard({
    required this.shopName,
    required this.location,
    required this.owner,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(shopName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Pending Review', style: TextStyle(color: AppColors.goldAccent, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('$owner • $location', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Text('Specialty: $specialty', style: const TextStyle(color: AppColors.neonCyan, fontSize: 11)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    foregroundColor: Colors.redAccent,
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Approved $shopName as verified vendor!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonCyan,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Approve Vendor', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  final String label;
  final String status;

  const _HealthRow({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(status, style: const TextStyle(color: AppColors.neonCyan, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
