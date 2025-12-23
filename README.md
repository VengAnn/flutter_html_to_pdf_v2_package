# flutter_html_to_pdf_v2

A Flutter plugin to convert HTML content to PDF files with proper support for complex scripts like Khmer, Thai, Arabic, etc.

## Features

- Convert HTML content to PDF
- Support for complex scripts (Khmer, Thai, Arabic, etc.)
- Multi-page PDF support
- A4 page format

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_html_to_pdf_v2: ^1.0.0
```

## Usage

```dart
import 'package:flutter_html_to_pdf_v2/flutter_html_to_pdf_v2.dart';
import 'package:path_provider/path_provider.dart';

// Get directory to save PDF
final directory = await getTemporaryDirectory();

// HTML content
final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: sans-serif; padding: 20px; }
    h1 { text-align: center; }
  </style>
</head>
<body>
  <h1>វិក្កយបត្រ</h1>
  <p>Hello World!</p>
</body>
</html>
''';

// Convert HTML to PDF
final pdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
  htmlContent,
  directory.path,
  'my_document',  // filename without .pdf extension
);

print('PDF saved to: ${pdfFile.path}');
```

## Platform Support

| Android | iOS |
|:-------:|:---:|
|    ✅   |  🚧  |

## License

MIT License
