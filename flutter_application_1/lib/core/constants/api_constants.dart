class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://api.fundilink.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Users
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadAvatar = '/users/avatar';

  // Fundis
  static const String fundis = '/fundis';
  static const String fundiProfile = '/fundis/profile';
  static const String fundiAvailability = '/fundis/availability';
  static const String fundiPortfolio = '/fundis/portfolio';

  // Categories
  static const String categories = '/categories';

  // Service Requests
  static const String serviceRequests = '/service-requests';
  static const String customerRequests = '/service-requests/customer';
  static const String fundiRequests = '/service-requests/fundi';
  static const String updateRequestStatus = '/service-requests/status';

  // Chat
  static const String conversations = '/conversations';
  static const String messages = '/messages';

  // Reviews
  static const String reviews = '/reviews';
  static const String fundiReviews = '/reviews/fundi';

  // Notifications
  static const String notifications = '/notifications';
  static const String markNotificationsRead = '/notifications/read';

  // Search
  static const String search = '/search';

  // Earnings
  static const String earnings = '/earnings';

  // Images
  static const String uploadImage = '/upload/image';

  // Query Parameters
  static const String pageParam = 'page';
  static const String limitParam = 'limit';
  static const String searchParam = 'search';
  static const String categoryParam = 'category';
  static const String locationParam = 'location';
  static const String ratingParam = 'rating';
  static const String statusParam = 'status';
  static const String sortParam = 'sort';
  static const String orderParam = 'order';
}
