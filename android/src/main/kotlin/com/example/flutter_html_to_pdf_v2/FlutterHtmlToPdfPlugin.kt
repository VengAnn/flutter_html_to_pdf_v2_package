package com.example.flutter_html_to_pdf_v2

import android.content.Context
import android.graphics.pdf.PdfDocument
import android.os.Handler
import android.os.Looper
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileOutputStream

class FlutterHtmlToPdfPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_html_to_pdf_v2")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "convertHtmlToPdf") {
      val html = call.argument<String>("html")!!
      val targetDirectory = call.argument<String>("targetDirectory")!!
      val targetName = call.argument<String>("targetName")!!
      
      convertHtmlToPdf(html, targetDirectory, targetName, result)
    } else {
      result.notImplemented()
    }
  }

  private fun convertHtmlToPdf(
    html: String,
    targetDirectory: String,
    targetName: String,
    result: Result
  ) {
    Handler(Looper.getMainLooper()).post {
      try {
        val webView = WebView(context)
        webView.settings.javaScriptEnabled = true
        webView.settings.loadWithOverviewMode = true
        webView.settings.useWideViewPort = true
        webView.settings.setSupportZoom(false)
        
        // A4 size in pixels at 72 DPI
        val pageWidth = 595
        val pageHeight = 842
        
        webView.layout(0, 0, pageWidth, pageHeight)
        
        webView.webViewClient = object : WebViewClient() {
          override fun onPageFinished(view: WebView?, url: String?) {
            super.onPageFinished(view, url)
            
            // Delay to ensure content is rendered
            Handler(Looper.getMainLooper()).postDelayed({
              try {
                createPdfFromWebView(webView, targetDirectory, targetName, pageWidth, pageHeight, result)
              } catch (e: Exception) {
                result.error("PDF_ERROR", e.message, null)
              }
            }, 500)
          }
        }
        
        webView.loadDataWithBaseURL(null, html, "text/html", "UTF-8", null)
      } catch (e: Exception) {
        result.error("WEBVIEW_ERROR", e.message, null)
      }
    }
  }

  private fun createPdfFromWebView(
    webView: WebView,
    targetDirectory: String,
    targetName: String,
    pageWidth: Int,
    pageHeight: Int,
    result: Result
  ) {
    try {
      val filePath = "$targetDirectory/$targetName.pdf"
      val file = File(filePath)
      
      // Measure content height
      webView.measure(
        android.view.View.MeasureSpec.makeMeasureSpec(pageWidth, android.view.View.MeasureSpec.EXACTLY),
        android.view.View.MeasureSpec.makeMeasureSpec(0, android.view.View.MeasureSpec.UNSPECIFIED)
      )
      val contentHeight = webView.measuredHeight
      webView.layout(0, 0, pageWidth, contentHeight)
      
      // Create PDF document
      val document = PdfDocument()
      
      // Calculate number of pages
      val totalPages = Math.ceil(contentHeight.toDouble() / pageHeight.toDouble()).toInt().coerceAtLeast(1)
      
      for (pageNum in 0 until totalPages) {
        val pageInfo = PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageNum + 1).create()
        val page = document.startPage(pageInfo)
        
        val canvas = page.canvas
        canvas.translate(0f, -(pageNum * pageHeight).toFloat())
        
        webView.draw(canvas)
        
        document.finishPage(page)
      }
      
      // Write to file
      val outputStream = FileOutputStream(file)
      document.writeTo(outputStream)
      document.close()
      outputStream.close()
      
      result.success(filePath)
    } catch (e: Exception) {
      result.error("WRITE_ERROR", e.message, null)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
