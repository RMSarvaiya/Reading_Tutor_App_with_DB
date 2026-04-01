// User Session - Login ke baad data yahan save hoga
class UserSession {
  static String name = '';
  static String email = '';
  static String phone = '';
  static String token = '';

  static void saveUser({
    required String name,
    required String email,
    required String phone,
    required String token,
  }) {
    UserSession.name = name;
    UserSession.email = email;
    UserSession.phone = phone;
    UserSession.token = token;
  }

  static void clear() {
    name = '';
    email = '';
    phone = '';
    token = '';
  }
}
