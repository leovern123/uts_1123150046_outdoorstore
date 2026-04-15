class ApiConstants {
  static const String baseUrl = 'http://192.168.0.28:8080/v1';

  // ================= AUTH =================
  static const String verifyToken = '/auth/verify-token';

  // ================= PRODUCT =================
  static const String products = '/products';

  // ================= CART =================
  static const String cart = '/cart';

  // ================= ORDER =================
  static const String orders = '/orders';

  // ================= TIMEOUT =================
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}