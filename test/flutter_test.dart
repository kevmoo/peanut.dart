import 'package:test/test.dart';
import 'package:peanut/src/utils.dart';

void main() {
  group('detecting Flutter SDK', () {
    final dartSubPath = 'sdk/bin/cache/dart-sdk/bin'.split('/');

    test('true negative', () {
      final path = ['some', 'path', 'that', 'clearly', "isn't", 'that'];
      expect(isFlutterSdkHeuristic(path), isFalse);
    });

    test('true positive (classic installation)', () {
      final path = ['Users', 'johndoe', 'dev', 'flutter', ...dartSubPath];
      expect(isFlutterSdkHeuristic(path), isTrue);
    });

    test('true positive (FVM installation)', () {
      final path = ['Users', 'me', 'fvm', 'versions', 'beta', ...dartSubPath];
      expect(isFlutterSdkHeuristic(path), isTrue);
    });
  });
}
