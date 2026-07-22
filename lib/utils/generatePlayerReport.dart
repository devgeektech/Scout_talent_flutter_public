import 'dart:io';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import '../backend/model/playerDetailResponse.dart';

Future<void> generatePDF(
     {
       String? playerName,
       String? club,
       int? height,
       int? weight,
       String? nationality,
       String? dob,
       int? age,
       String? preferredFoot,
       String? position,
       //Stats
       int? matches,
       String? compLevel,
       int? squadNo,
       int? goals,
       int? assists,
       int? minutes,
       int? passAccuracy,
       int? dualWons,
       int? passComp,
       int? shortsOnTarget,
       int? dribles,

       //Contract info
       String? contractStart,
       String? contractEnd,

       //National info
       String?callUps,
       String?caps,
       String? transferStatus,
       List<PlayerCareer>? career,
       List<Trophies>? trophies,


     }
    ) async {


  final fontRegular = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Montserrat-Regular.ttf'),
  );

  final fontBold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Montserrat-SemiBold.ttf'),
  );

  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
    ),
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (context) => [
        /// HEADER
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  playerName!,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text("${'Actual Club'.tr}: $club"),
                pw.Text("${'Height'.tr}: $height"),
                pw.Text("${'Weight'.tr}: $weight"),
                pw.Text("${'Nationality'.tr}: $nationality"),
                pw.Text(
                  age != null
                      ? "${'DOB'.tr}: $dob , ${'Age'.tr}: $age"
                      : "${'DOB'.tr}: $dob",
                ),

                pw.Text("${'Preferred Foot'.tr}: $preferredFoot"),
                pw.Text("${'Position'.tr}: $position"),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 20),
        pw.Divider(),

        /// STATISTICS TITLE
        pw.Text(
          'Statistics'.tr,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),

        /// STATISTICS TABLE
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _cell("Matches".tr, isHeader: true),
                _cell("Comp Level".tr, isHeader: true),
                _cell("Squad No.".tr, isHeader: true),
                _cell("Goals".tr, isHeader: true),
                _cell("Assists".tr, isHeader: true),
                _cell("Minutes".tr, isHeader: true),
                _cell("Pass Accuracy".tr, isHeader: true),
                _cell("Duels Won".tr, isHeader: true),
                _cell("Pass Comp.".tr, isHeader: true),
                _cell("Shorts On Target".tr, isHeader: true),
                _cell("Dribles Comp.".tr, isHeader: true),
              ],
            ),

            pw.TableRow(
              children: [
                _cell(stat(matches)),
                _cell(stat(compLevel)),
                _cell(stat(squadNo)),
                _cell(stat(goals)),
                _cell(stat(assists)),
                _cell(stat(minutes)),
                _cell(stat(passAccuracy, percent: true)),
                _cell(stat(dualWons, percent: true)),
                _cell(stat(passComp, percent: true)),
                _cell(stat(shortsOnTarget, percent: true)),
                _cell(stat(dribles, percent: true)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),

        /// CAREER
        pw.Text(
          "Career".tr,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),

        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _cell("Season".tr, isHeader: true),
                _cell("Club".tr, isHeader: true),
                _cell("Matches".tr, isHeader: true),
                _cell("Minutes".tr, isHeader: true),
                _cell("Goals".tr, isHeader: true),
              ],
            ),

            ...?career?.map(
                  (career) =>
                      pw.TableRow(
                          children:
                          [
                            _cell(career.season ?? "-"),
                            _cell(career.club ?? "-"),
                            _cell(career.matches ?? "-"),
                            _cell(career.minutes ?? "-"),
                            _cell(career.goals ?? "-"),
                  ]),
            ),
          ],
        ),

        pw.SizedBox(height: 20),

        /// CONTRACT INFO
        pw.Text(
          "Contract Information".tr,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Text("${'Contract Start'.tr}: $contractStart"),
        pw.Text("${'Contract End'.tr}: $contractEnd"),

        pw.SizedBox(height: 16),

        /// NATIONAL INFO
        pw.Text(
          "National Information".tr,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Text("${'Call Ups'.tr}: $callUps"),
        pw.Text("${'Caps'.tr}: $caps"),
        pw.Text("${'Transfer Status'.tr}: $transferStatus"),
        pw.SizedBox(height: 16),

        /// TROPHIES
        pw.Text(
          "Trophies".tr,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),

        if (trophies != null && trophies.isNotEmpty)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: trophies
                .map(
                  (trophy) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Text(
                  _formatTrophy(trophy),
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
            )
                .toList(),
          )
        else
          pw.Text(
            "N/A",
            style: const pw.TextStyle(fontSize: 11),
          ),
      ],
    ),
  );

  final safeTitle = playerName?.replaceAll(' ', '_');
  final timestamp =
  DateTime.now().toIso8601String().replaceAll(':', '-');

  Directory dir;

  if (Platform.isAndroid) {
    dir = Directory('/storage/emulated/0/Download');
  } else {
    dir = await getApplicationDocumentsDirectory();
  }

  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  final filePath = '${dir.path}/${safeTitle}_$timestamp.pdf';


  /*final filePath =
      "/storage/emulated/0/Download/${safeTitle}_$timestamp.pdf";*/

  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  print("PDF saved to: ${file.path}");
  OpenFile.open(file.path); // Opens the generated PDF
}
pw.TableRow _tableRow(String label, String value) {
  return pw.TableRow(
    children: [
      _cell(label),
      _cell(value),
    ],
  );
}

pw.Widget _cell(String text, {bool isHeader = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}
String _formatTrophy(Trophies trophy) {
  final name = trophy.name?.trim();
  final year = trophy.year?.toString();

  if ((name == null || name.isEmpty) && year == null) {
    return 'N/A';
  }

  if (name != null && year != null) {
    return '$name ($year)';
  }

  return name ?? 'N/A';
}
String stat(dynamic value, {bool percent = false}) {
  if (value == null) return 'N/A';
  return percent ? '$value %' : value.toString();
}