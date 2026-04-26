class ApiConstants {
  static const String baseUrl =  'http://10.198.178.21:8081';

  // ================= AUTH =================
  static const String verifyToken = "/v1/auth/verify-token";

  // ================= PRODUCT =================
  static const String products = '/v1/products';

  // ================= CART =================
  static const String cart = '/v1/cart';

  // ================= ORDER =================
  static const String orders = '/v1/orders';

  // ================= TIMEOUT =================
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}