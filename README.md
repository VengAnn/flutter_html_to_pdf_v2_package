# flutter_html_to_pdf_v2

A Flutter plugin to convert HTML content to PDF files with proper support for complex scripts like Khmer, Thai, Arabic, etc.

## Features

- Convert HTML content to PDF
- Support for complex scripts (Khmer, Thai, Arabic, etc.)
- Multi-page PDF support
- A4 page format
- Works on Android and iOS
- Proper file path handling for both platforms

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_html_to_pdf_v2: ^1.0.0
  path_provider: ^2.1.5
```

Then run:

```bash
flutter pub get
```

## Setup

### Android Setup

1. **Minimum SDK Version**: Ensure your Android project targets Android 5.0 (API level 21) or higher.

2. **Add to `android/app/build.gradle.kts` (or `build.gradle` for older projects)**:

```gradle
android {
    compileSdk 34

    defaultConfig {
        minSdk 21
        targetSdk 34
    }
}
```

3. **Permissions in `android/app/src/main/AndroidManifest.xml`**:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
```

**Note**: For Android 11+, `MANAGE_EXTERNAL_STORAGE` permission is required to save files to the Downloads folder.

### iOS Setup

1. **Minimum iOS Version**: Ensure your iOS project targets iOS 13.0 or higher.

2. **Update `ios/Podfile`** to ensure CocoaPods post-install hooks are configured:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
      ]
    end
  end
end
```

3. **Permissions in `ios/Runner/Info.plist`**:

```xml
<key>NSDocumentUsageDescription</key>
<string>This app needs access to store and manage PDF files</string>
```

## Usage

### Basic Example - Save to Downloads (Recommended)

Save PDFs to the Downloads folder like other apps do - easy for users to find and access:

```dart
import 'package:flutter_html_to_pdf_v2/flutter_html_to_pdf_v2.dart';
import 'package:path_provider/path_provider.dart';

Future<void> convertHtmlToPdf() async {
  try {
    // Get the Downloads directory - visible to users like other apps
    final directory = await getDownloadsDirectory();

    if (directory == null) {
      // Fallback: use Documents if Downloads not available
      final docDir = await getApplicationDocumentsDirectory();
      await _savePdf(docDir.path);
      return;
    }

    await _savePdf(directory.path);
  } on PlatformException catch (e) {
    print('❌ Error: ${e.message}');
  }
}

Future<void> _savePdf(String savePath) async {
  try {
    // HTML content with Khmer text
    final htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          body { font-family: sans-serif; padding: 20px; margin: 0; }
          h1 { text-align: center; color: #2196F3; }
          p { font-size: 14px; line-height: 1.6; }
        </style>
      </head>
      <body>
        <h1>ឯកសារខ្មែរ</h1>
        <p>សូមស្វាគមន៍មកកាន់កម្មវិធីបម្លែង HTML ទៅ PDF</p>
        <p>កាលបរិច្ឆេទ: ${DateTime.now()}</p>
      </body>
      </html>
    ''';

    // Convert HTML to PDF
    final pdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      htmlContent,
      savePath,
      'khmer_document_${DateTime.now().millisecondsSinceEpoch}',
    );

    // Show success with file path information
    print('✅ PDF Saved Successfully!');
    print('📁 File: ${pdfFile.path.split('/').last}');
    print('📍 Location: $savePath');

  } on PlatformException catch (e) {
    print('❌ Error: ${e.message}');
  }
}
```

### File Locations

The plugin saves files to user-accessible locations on both platforms:

#### Android

- **Downloads folder** (Recommended):

  ```
  /storage/emulated/0/Download/
  ```

  Users can access via: Files app → Downloads folder

- **Documents folder** (Fallback):
  ```
  /data/data/com.example.yourapp/files/
  ```

#### iOS

- **Downloads folder** (Recommended):

  ```
  /var/mobile/Containers/Data/Application/{APP_ID}/Documents/Downloads/
  ```

  Users can access via: Files app → Downloads

- **Documents folder** (Fallback):
  ```
  /var/mobile/Containers/Data/Application/{APP_ID}/Documents/
  ```

### Khmer (and other complex script) Support

The plugin includes built-in support for complex scripts. Always include the UTF-8 charset declaration:

```dart
final khmerHtml = '''
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
      <style>
        body { font-family: sans-serif; padding: 20px; }
      </style>
    </head>
    <body>
      <h1>ឯកសារជាខ្មែរ</h1>
      <p>អក្សរខ្មែរ ៖ A-Z, a-z, 0-9, ល។</p>
      <p>ត្រូវប្រើ meta charset="UTF-8" សម្រាប់ការបង្ហាញលម្អិត។</p>
    </body>
  </html>
''';

final directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();

final pdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
  khmerHtml,
  directory.path,
  'khmer_document_${DateTime.now().millisecondsSinceEpoch}',
);

// Print the file location
print('✅ File saved: ${pdfFile.path}');
```

## Troubleshooting

### Android Issues

**Issue**: `processDebugManifest` gradle task fails

- **Solution**: Ensure the `package` attribute is removed from `android/src/main/AndroidManifest.xml`

**Issue**: File not saved or permission error

- **Solution**: Use `getDownloadsDirectory()` for easy user access, or `getApplicationDocumentsDirectory()` as fallback

**Issue**: Files not visible in Downloads folder

- **Solution**: Ensure `MANAGE_EXTERNAL_STORAGE` permission is added to AndroidManifest.xml

**Issue**: Gradle build errors

- **Solution**: Run `flutter clean` and then `flutter pub get`

### iOS Issues

**Issue**: Pod install fails

- **Solution**: Run `pod install --repo-update` in the `ios/` directory
  ```bash
  cd ios
  rm -rf Pods
  pod install --repo-update
  cd ..
  ```

**Issue**: PDF not being saved or encoding issues

- **Solution**:
  1. Ensure `Info.plist` has proper file access permissions
  2. Include `<meta charset="UTF-8">` in your HTML

**Issue**: Build fails with missing Swift files

- **Solution**: Run `flutter pub get` and then `flutter clean` before rebuilding

## API Reference

### `convertFromHtmlContent()`

```dart
static Future<File> convertFromHtmlContent(
  String htmlContent,
  String savePath,
  String fileName,
)
```

**Parameters**:

- `htmlContent`: The HTML string to convert
  - Must include `<meta charset="UTF-8">` in the head section for proper encoding
  - Supports complex scripts like Khmer, Thai, Arabic, etc.
- `savePath`: Directory path where the PDF will be saved
  - Use `getDownloadsDirectory()` from `path_provider` for easy user access (recommended)
  - Use `getApplicationDocumentsDirectory()` as fallback
  - Both work on Android and iOS
- `fileName`: Name of the PDF file without `.pdf` extension
  - Recommend adding timestamp to avoid duplicates: `'khmer_document_${DateTime.now().millisecondsSinceEpoch}'`
  - Example: `'khmer_document_1234567890'` creates `'khmer_document_1234567890.pdf'`

**Returns**: `Future<File>` - The saved PDF file

**Throws**: `PlatformException` if conversion fails

**Example**:

```dart
try {
  // Save to Downloads folder (recommended)
  final directory = await getDownloadsDirectory() ??
                   await getApplicationDocumentsDirectory();

  final pdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
    '<html><head><meta charset="UTF-8"></head><body><h1>Test</h1></body></html>',
    directory.path,
    'test_document_${DateTime.now().millisecondsSinceEpoch}',
  );

  // Print success with file information
  print('✅ PDF Saved Successfully!');
  print('📁 File: ${pdfFile.path.split('/').last}');
  print('📍 Location: ${directory.path}');

  // Print success with file information
  print('✅ PDF Saved Successfully!');
  print('📁 File: ${pdfFile.path.split('/').last}');
  print('📍 Location: ${directory.path}');
} on PlatformException catch (e) {
  print('❌ Error: ${e.message}');
}
```

## Best Practices

1. **Always use `getDownloadsDirectory()` for user access** (recommended)

   ```dart
   import 'package:path_provider/path_provider.dart';

   // Get Downloads folder for easy user access
   final directory = await getDownloadsDirectory();

   // Fallback to Documents if Downloads not available
   final directory = await getDownloadsDirectory() ??
                     await getApplicationDocumentsDirectory();
   ```

2. **Always print the file path** so users can locate their PDF

   ```dart
   final pdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(...);
   print('✅ PDF saved to: ${pdfFile.path}');
   print('📁 File: ${pdfFile.path.split('/').last}');
   ```

3. **Use timestamps in filenames** to avoid overwriting files

   ```dart
   'khmer_document_${DateTime.now().millisecondsSinceEpoch}'
   ```

4. **Include charset UTF-8** in your HTML head for proper text rendering:

   ```html
   <meta charset="UTF-8" />
   ```

5. **Use standard CSS** for styling - some advanced CSS features may not be supported

6. **Test on both platforms** - rendering may differ slightly between Android and iOS

7. **Handle errors properly** - always use try-catch blocks:

   ```dart
   try {
     final file = await FlutterHtmlToPdf.convertFromHtmlContent(...);
     print('✅ Success: ${file.path}');
   } on PlatformException catch (e) {
     print('❌ Error: ${e.message}');
   }
   ```

8. **For Khmer text**, ensure:

   - UTF-8 encoding is declared: `<meta charset="UTF-8">`
   - Text is properly formatted in Khmer Unicode
   - Test on actual devices, not just emulators

9. **Show users where files are saved** - Include feedback in your UI:
   ```dart
   setState(() {
     _status = '✅ PDF Saved\n📁 File: test.pdf\n📍 Location: Downloads';
   });
   ```

## Example Project

See the `example/` directory for a complete Flutter application demonstrating the plugin with Khmer language support.

## Platform Support

| Platform | Status |
| :------: | :----: |
| Android  |   ✅   |
|   iOS    |   ✅   |

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues and questions, please visit the [GitHub Issues](https://github.com/puthsokha/flutter_html_to_pdf_v2/issues) page.
