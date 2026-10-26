class ShopModel {
  final String id;
  final String name;
  final String valleyLocation; // e.g., Shahi Bazaar, Drosh, Kalash, Booni
  final String ownerName;
  final String bannerImageUrl;
  final double rating;
  final int totalSales;
  final bool isVerified;
  final String specialty;

  const ShopModel({
    required this.id,
    required this.name,
    required this.valleyLocation,
    required this.ownerName,
    required this.bannerImageUrl,
    required this.rating,
    required this.totalSales,
    required this.isVerified,
    required this.specialty,
  });
}
