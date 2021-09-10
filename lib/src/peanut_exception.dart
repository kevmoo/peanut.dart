class PeanutException implements Exception {
  final String message;
  final int exitCode;

  PeanutException(this.message, {this.exitCode = 1});

  @override
  String toString() => message;
}
