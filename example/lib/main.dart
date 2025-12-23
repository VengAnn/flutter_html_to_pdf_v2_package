import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf_v2/flutter_html_to_pdf_v2.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Ready to convert HTML to PDF';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _convertHtmlToPdf() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final html =
          '<html><body><h1>Hello World!</h1><p>This is a test PDF.</p></body></html>';

      final file = await FlutterHtmlToPdf.convertFromHtmlContent(
        html,
        directory.path,
        'test_document',
      );

      if (!mounted) return;
      setState(() {
        _status = 'PDF created: ${file.path}';
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _status = 'Failed: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('HTML to PDF Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertHtmlToPdf,
                child: const Text('Convert HTML to PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
