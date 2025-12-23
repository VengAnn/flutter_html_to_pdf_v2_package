import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

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
  String _status = 'រៀបចំដើម្បីបម្លែង HTML ទៅ PDF';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _convertHtmlToPdf() async {
    try {
      String savePath;

      if (Platform.isAndroid) {
        // ANDROID: Save to actual Downloads folder
        // Path: /storage/emulated/0/Download/
        savePath = '/storage/emulated/0/Download';
      } else if (Platform.isIOS) {
        // iOS: Save to Documents folder (accessible via Files app)
        final directory = await getApplicationDocumentsDirectory();
        savePath = directory.path;
      } else {
        final directory = await getApplicationDocumentsDirectory();
        savePath = directory.path;
      }

      await _saveAndShowPdf(savePath);
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _status = 'មានកំហុស: ${e.message}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = 'មានកំហុស: $e';
      });
    }
  }

  Future<void> _saveAndShowPdf(String savePath) async {
    try {
      final html =
          '''
        <html>
          <head>
            <meta charset="UTF-8">
            <style>
              body { font-family: sans-serif; padding: 20px; }
              h1 { color: #2196F3; text-align: center; }
              p { font-size: 16px; line-height: 1.6; }
            </style>
          </head>
          <body>
            <h1>ឯកសារលេខ ១</h1>
            <p>សូមស្វាគមន៍មកកាន់កម្មវិធីបម្លែង HTML ទៅ PDF</p>
            <p>នេះគឺជាឯកសារលក្ខណ៍ម៉ាកដែលបានបង្កើតដោយប្រើ HTML។ មានលក្ខណៈសម្បត្តិសម្រាប់ Text ដែលគាំទ្នលម្អិត។</p>
            <p>កាលបរិច្ឆេទ: ${DateTime.now().toString()}</p>
          </body>
        </html>
      ''';

      final fileName =
          'khmer_document_${DateTime.now().millisecondsSinceEpoch}';

      // Print HTML content before conversion
      print('═══════════════════════════════════════════════════════════');
      print('📄 HTML CONTENT TO CONVERT:');
      print('═══════════════════════════════════════════════════════════');
      print(html);
      print('═══════════════════════════════════════════════════════════');
      print('🔄 Converting HTML to PDF...');
      print('📁 Filename: $fileName.pdf');
      print('📍 Save Path: $savePath');
      print('═══════════════════════════════════════════════════════════');

      final file = await FlutterHtmlToPdf.convertFromHtmlContent(
        html,
        savePath,
        fileName,
      );

      // Print success with full details
      print('');
      print('✅ PDF Saved Successfully!');
      print('📁 File: $fileName.pdf');
      print('📍 Path: ${file.path}');
      print('📊 File Size: ${await file.length()} bytes');
      print('═══════════════════════════════════════════════════════════');

      if (!mounted) return;
      setState(() {
        _status =
            '✅ PDF រក្សាទុកបានជោគជ័យ!\n\n📁 ឯកសារ: $fileName.pdf\n\n📍 ទីតាំង:\n$savePath';
      });
    } on PlatformException catch (e) {
      print('❌ Platform Error: ${e.message}');
      if (!mounted) return;
      setState(() {
        _status = 'មានកំហុស: ${e.message}';
      });
    } catch (e) {
      print('❌ Error: $e');
      if (!mounted) return;
      setState(() {
        _status = 'មានកំហុស: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('បម្លែង HTML ទៅ PDF (ភាសាខ្មែរ)'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertHtmlToPdf,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'បម្លែង HTML ទៅ PDF',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
