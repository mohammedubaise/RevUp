import 'dart:io';

void main() {
  final logFile = File('copy_log.txt');
  void log(String msg) {
    print(msg);
    logFile.writeAsStringSync('$msg\n', mode: FileMode.append);
  }

  try {
    log('Starting copy process...');
    final sourcePath =
        r'C:\Users\USER\.gemini\antigravity\brain\7ff771ae-e843-4568-ac6e-5415a50f8559\app_icon_137_premium_1769669107572.png';
    final destPath = r'e:\flutter_projects\study\assets\icon.png';

    final source = File(sourcePath);
    final dest = File(destPath);

    if (!source.existsSync()) {
      log('ERROR: Source file does not exist at: $sourcePath');
      return;
    }

    if (!dest.parent.existsSync()) {
      log('Creating assets directory...');
      dest.parent.createSync(recursive: true);
    }

    log('Reading bytes...');
    final bytes = source.readAsBytesSync();
    log('Read ${bytes.length} bytes.');

    log('Writing to destination...');
    dest.writeAsBytesSync(bytes);
    log('Write successful!');
  } catch (e, stack) {
    log('EXCEPTION: $e');
    log('STACK: $stack');
  }
}
