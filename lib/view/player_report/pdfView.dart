import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String pdfUrl;
  final String fileName;
  final String type;

  const PdfPreviewScreen({
    super.key,
    required this.pdfUrl,
    required this.fileName,
    this.type = ""
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${widget.fileName}');

    final response = await http.get(Uri.parse(widget.pdfUrl));
    await file.writeAsBytes(response.bodyBytes);

    setState(() {
      localPath = file.path;
      isLoading = false;
    });
  }

  Future<void> _downloadPdf() async {
    Directory? dir;

    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final downloadFile = File('${dir.path}/${widget.fileName}');
    await File(localPath!).copy(downloadFile.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF downloaded successfully")),
    );
  }


  Future<void> downloadStripeInvoicePdf({
    required String invoiceUrl,
    String fileName = 'invoice.pdf',
  }) async {
    try {
      // 1️⃣ Download PDF bytes
      final dio = Dio();
      final response = await dio.get<List<int>>(
        invoiceUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      // 2️⃣ Save temporarily in cache
      final cacheDir = await getTemporaryDirectory();
      final tempFile = File('${cacheDir.path}/$fileName');
      await tempFile.writeAsBytes(response.data!);

      // 3️⃣ Save to Downloads using MediaStore
      final params = SaveFileDialogParams(
        sourceFilePath: tempFile.path,
        fileName: fileName,
        mimeTypesFilter: ['application/pdf']
      );

      await FlutterFileDialog.saveFile(params: params);
    } catch (e) {
      debugPrint('Stripe PDF download failed: $e');
      rethrow;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview CV"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: localPath == null
                ? null
                : () {
              if (widget.type == "invoice") {
                downloadStripeInvoicePdf(invoiceUrl: widget.pdfUrl);
              }else{
                _downloadPdf();
              }

            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: localPath!,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
      ),
    );
  }
}
