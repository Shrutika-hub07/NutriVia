import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../core/providers/app_state_provider.dart';

class DoctorReportPdfGenerator {
  static Future<void> generateAndPrintReport(BuildContext context, AppState state) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with Nutrivia Brand
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'NUTRIVIA MIDLIFE HEALTH SUMMARY',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#5B2A86'),
                        ),
                      ),
                      pw.Text(
                        'Doctor Consultation & Care Continuity Report',
                        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#FDC88C'),
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(
                      'Doctor\'s Copy',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 1.5, color: PdfColor.fromHex('#5B2A86')),
              pw.SizedBox(height: 12),

              // Patient Profile Box
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F6F1FB'),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Patient: ${state.profile.name} (Age: ${state.profile.age})', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text('Region: ${state.profile.region}', style: const pw.TextStyle(fontSize: 11)),
                    pw.Text('Diet: ${state.profile.diet.toUpperCase()}', style: const pw.TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),

              // Reproductive Milestone (STRAW+10)
              pw.Text('REPRODUCTIVE STAGE (STRAW+10)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColor.fromHex('#5B2A86'))),
              pw.SizedBox(height: 4),
              pw.Text('Estimated Phase: ${state.strawStage['name'] ?? 'Late Perimenopause'}', style: const pw.TextStyle(fontSize: 11)),
              pw.Text('Cycle History: Last menstrual period ~${state.profile.monthsSinceLastPeriod} months ago. Variance: ~${state.profile.cycleLengthVarianceDays} days between cycles.', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
              pw.SizedBox(height: 14),

              // Risk Flags with Deterministic Reasons
              pw.Text('PREDICTIVE DEFICIENCY RISKS & EXPLAINABLE CONTRIBUTING FACTORS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColor.fromHex('#5B2A86'))),
              pw.SizedBox(height: 6),
              ...state.riskResults.where((r) => r.level == 'high' || r.level == 'medium').map((r) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 6),
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(r.displayName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                          pw.Text(r.level.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: r.level == 'high' ? PdfColor.fromHex('#B8325A') : PdfColor.fromHex('#D9A21B'))),
                        ],
                      ),
                      pw.Text('Contributing Triggers: ${r.breakdown.map((b) => b.reason).join(" | ")}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      pw.Text('Suggested Tests to Discuss: ${r.testsToDiscuss.join(", ")}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#5B2A86'))),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 14),

              // Medicine Response
              pw.Text('ACTIVE MEDICINE RESPONSE & ADHERENCE OVER 6 WEEKS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColor.fromHex('#5B2A86'))),
              pw.SizedBox(height: 6),
              ...state.medicines.map((m) {
                return pw.Bullet(
                  text: '${m.name} (${m.dosage}) - Target: ${m.targetProblem}. Symptom Severity changed from ${m.severityBefore}/10 to ${m.severityAfter}/10. Adherence: ${m.adherencePercent.toInt()}%. Notes: ${m.notes}',
                  style: const pw.TextStyle(fontSize: 10),
                );
              }),
              pw.SizedBox(height: 14),

              // Lab Baseline Values
              pw.Text('RECORDED LAB VALUES', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColor.fromHex('#5B2A86'))),
              pw.SizedBox(height: 6),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Test Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Value', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Status', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
                    ],
                  ),
                  ...state.labs.map((l) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(l.testName, style: const pw.TextStyle(fontSize: 9))),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${l.value} ${l.unit}', style: const pw.TextStyle(fontSize: 9))),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(l.status.toUpperCase(), style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: l.status == 'low' ? PdfColor.fromHex('#B8325A') : PdfColor.fromHex('#5E8C61')))),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 20),

              // Medical Disclaimer Footer
              pw.Divider(thickness: 1, color: PdfColors.grey400),
              pw.Text(
                'Clinical Notice: This document synthesizes self-reported patient symptom logs and lifestyle patterns from Nutrivia for medical consultation review. Nutrivia does not provide clinical diagnoses. Prescriptions, dosage alterations, and diagnostic interpretations remain the sole prerogative of the attending physician.',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Nutrivia_Doctor_Report_${state.profile.name.replaceAll(' ', '_')}.pdf',
    );
  }
}
