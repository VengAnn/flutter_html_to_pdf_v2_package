import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_html_to_pdf_v2_method_channel.dart';

abstract class FlutterHtmlToPdfPlatform extends PlatformInterface {
  FlutterHtmlToPdfPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterHtmlToPdfPlatform _instance = MethodChannelFlutterHtmlToPdf();

  static FlutterHtmlToPdfPlatform get instance => _instance;

  static set instance(FlutterHtmlToPdfPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> convertHtmlToPdf({
    required String html,
    required String targetDirectory,
    required String targetName,
  }) {
    throw UnimplementedError('convertHtmlToPdf() has not been implemented.');
  }
}
