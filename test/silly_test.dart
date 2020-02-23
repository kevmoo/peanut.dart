import 'package:test/test.dart';

const generatorConfigDefaultJson = <String, dynamic>{'a': 1};

void helper(Map<String, dynamic> input) {
  print(input);
}

void main() {
  test('weird', () {
    final nullValueMap = Map.fromEntries(
        generatorConfigDefaultJson.entries.map((e) => MapEntry(e.key, null)));
    helper(nullValueMap);
  });
}
