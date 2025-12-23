import 'package:flutter/services.dart';

import 'flutter_html_to_pdf_v2_platform_interface.dart';

class MethodChannelFlutterHtmlToPdf extends FlutterHtmlToPdfPlatform {
  final methodChannel = const MethodChannel('flutter_html_to_pdf_v2');

  @override
  Future<String> convertHtmlToPdf({
    required String html,
    required String targetDirectory,
    required String targetName,
  }) async {
    final result = await methodChannel.invokeMethod<String>('convertHtmlToPdf', {
      'html': html,
      'targetDirectory': targetDirectory,
      'targetName': targetName,
    });
    return result!;
  }
}
