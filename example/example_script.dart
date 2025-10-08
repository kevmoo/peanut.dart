import 'dart:js_interop';

import 'package:web/web.dart';

void main() {
  print('Hello!');

  final peanutVars = window['_peanutVars'] as _PeanutVars;
  document.querySelector('#dart_version')!.textContent = peanutVars.toolVersion;

  final JSAny gitInfo;

  if (peanutVars.gitInfo == '{{git_info}}') {
    gitInfo = '{{git_info}}'.toJS;
  } else if (peanutVars.gitInfo == 'DIRTY') {
    gitInfo = 'dirty'.toJS;
  } else {
    gitInfo = HTMLAnchorElement()
      ..href =
          'https://github.com/kevmoo/peanut.dart/commit/${peanutVars.gitInfo}'
      ..text = 'kevmoo/peanut.dart@${peanutVars.gitInfo}';
  }

  document.querySelector('#commit_info')!.replaceChildren(gitInfo);
}

extension type _PeanutVars(JSObject _) {
  external String get toolVersion;
  external String get gitInfo;
}
