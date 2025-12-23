import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_html_to_pdf_v2/flutter_html_to_pdf_v2.dart';
import 'package:flutter_html_to_pdf_v2/flutter_html_to_pdf_v2_platform_interface.dart';
import 'package:flutter_html_to_pdf_v2/flutter_html_to_pdf_v2_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterHtmlToPdfPlatform
    with MockPlatformInterfaceMixin
    implements FlutterHtmlToPdfPlatform {
  @override
  Future<String> convertHtmlToPdf({
    required String html,
    required String targetDirectory,
    required String targetName,
  }) =>
      Future.value('$targetDirectory/$targetName.pdf');
}

void main() {
  final FlutterHtmlToPdfPlatform initialPlatform =
      FlutterHtmlToPdfPlatform.instance;

  test('$MethodChannelFlutterHtmlToPdf is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterHtmlToPdf>());
  });

  test('convertFromHtmlContent', () async {
    MockFlutterHtmlToPdfPlatform fakePlatform = MockFlutterHtmlToPdfPlatform();
    FlutterHtmlToPdfPlatform.instance = fakePlatform;

    final file = await FlutterHtmlToPdf.convertFromHtmlContent(
      '<html></html>',
      '/tmp',
      'test',
    );
    expect(file.path, '/tmp/test.pdf');
  });
}
