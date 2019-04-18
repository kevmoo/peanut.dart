class PeanutException implements Exception {
  final String message;

  PeanutException(this.message);

  @override
  String toString() => message;
}
