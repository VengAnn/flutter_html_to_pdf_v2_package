import 'dart:io';

import 'flutter_html_to_pdf_v2_platform_interface.dart';

/// A Flutter plugin to convert HTML content to PDF files.
/// 
/// Supports complex scripts like Khmer, Thai, Arabic, etc.
class FlutterHtmlToPdf {
  /// Convert HTML content to PDF file
  /// 
  /// [html] - HTML content string
  /// [targetDirectory] - Directory path to save PDF
  /// [targetName] - PDF file name (without .pdf extension)
  /// 
  /// Returns the generated PDF file
  /// 
  /// Example:
  /// ```dart
  /// final file = await FlutterHtmlToPdf.convertFromHtmlContent(
  ///   '<html><body><h1>Hello</h1></body></html>',
  ///   '/path/to/save',
  ///   'my_document',
  /// );
  /// ```
  static Future<File> convertFromHtmlContent(
    String html,
    String targetDirectory,
    String targetName,
  ) async {
    final filePath = await FlutterHtmlToPdfPlatform.instance.convertHtmlToPdf(
      html: html,
      targetDirectory: targetDirectory,
      targetName: targetName,
    );
    return File(filePath);
  }
}
