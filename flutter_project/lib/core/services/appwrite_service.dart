import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AppwriteService {
  static const String endpoint = 'https://cloud.appwrite.io/v1';
  static const String projectId = 'chitral-shop-prod';
  static const String databaseId = 'chitral_marketplace_db';

  // Collection IDs
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String shopsCollection = 'shops';
  static const String reviewsCollection = 'reviews';
  static const String trendingMetricsCollection = 'trending_metrics';

  // Storage Bucket
  static const String productImagesBucket = 'product_images';

  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Storage storage;
  late final Realtime realtime;

  static final AppwriteService _instance = AppwriteService._internal();
  factory AppwriteService() => _instance;

  AppwriteService._internal() {
    client = Client()
      ..setEndpoint(endpoint)
      ..setProject(projectId)
      ..setSelfSigned(status: true);

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    realtime = Realtime(client);
  }

  // Authentication operations
  Future<models.User> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    return await account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }

  Future<models.Session> login({
    required String email,
    required String password,
  }) async {
    return await account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  Future<void> createOAuth2Session({required String provider}) async {
    final oauthProvider = switch (provider.toLowerCase()) {
      'google' => OAuthProvider.google,
      _ => throw UnsupportedError('Unsupported OAuth provider: $provider'),
    };
    await account.createOAuth2Session(provider: oauthProvider);
  }

  Future<void> createEmailVerification() async {
    await account.createVerification(url: 'https://chitralshop.pk/verify-email');
  }

  Future<models.User?> getCurrentUser() async {
    try {
      return await account.get();
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
  }

  Future<models.Token> createPasswordRecovery({required String email}) async {
    return await account.createRecovery(
      email: email,
      url: 'https://chitralshop.pk/recovery',
    );
  }

  // Realtime subscription for trending metrics and product stock
  RealtimeSubscription subscribeToTrendingMetrics(
    Function(RealtimeMessage) onUpdate,
  ) {
    final subscription = realtime.subscribe([
      'databases.$databaseId.collections.$trendingMetricsCollection.documents',
      'databases.$databaseId.collections.$productsCollection.documents',
    ]);
    subscription.stream.listen(onUpdate);
    return subscription;
  }
}
