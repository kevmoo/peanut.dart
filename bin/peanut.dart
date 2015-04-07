library peanut.bin;

import 'package:peanut/peanut.dart';

const _targetBranch = 'gh-pages';
const _targetDir = 'web';
const _commitMsg = 'building!';

void main() {
  run(_targetDir, _targetBranch, _commitMsg);
}
