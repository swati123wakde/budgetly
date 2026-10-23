/// Thrown by data sources; caught by repositories and turned into Failures.
class ServerException implements Exception {
  const ServerException([this.message]);
  final String? message;
}

class AuthException implements Exception {
  const AuthException([this.message]);
  final String? message;
}

class CacheException implements Exception {
  const CacheException([this.message]);
  final String? message;
}

/// Thrown when the user closes a sign-in flow (e.g. the Google account picker).
class CancelledException implements Exception {
  const CancelledException();
}