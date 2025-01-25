import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';

class ChapterDocumentView extends StatefulWidget {
  final String fileUrl;
  const ChapterDocumentView({super.key, required this.fileUrl});

  @override
  State<ChapterDocumentView> createState() => _ChapterDocumentViewState();
}

class _ChapterDocumentViewState extends State<ChapterDocumentView> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(titleText: "View Document"),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.fileUrl)),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onLoadStart: (controller, url) {
          // Disable the ability to download the PDF file
          controller.evaluateJavascript(source: """
            var links = document.getElementsByTagName("a");
            for (var i = 0; i < links.length; i++) {
              links[i].setAttribute("download", "");
            }
          """);
        },
        onLoadStop: (controller, url) {
          // Disable the ability to right-click and save the PDF file
          controller.evaluateJavascript(source: """
            document.addEventListener("contextmenu", function(e) {
              e.preventDefault();
            }, false);
          """);
        },
      ),
    );
  }
}
