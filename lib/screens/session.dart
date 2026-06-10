class Session {
  static int? currentUserId;
  static bool get isLoggedIn => currentUserId != null;
  
  static void logout() {
    currentUserId = null;
  }
}