import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';

class pdfReport extends StatefulWidget {
  final List list;
  final String clas;
  final List total;

  pdfReport({required this.list, required this.clas, required this.total});

  @override
  State<pdfReport> createState() =>
      _pdfReportState(list: list, clas: clas, total: total);
}

class _pdfReportState extends State<pdfReport> {
  List list;
  String clas;
  List total;

  _pdfReportState({required this.list, required this.clas, required this.total});

  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        canChangeOrientation: false,
        canDebug: false,
        build: (format) => generateDocument(format),
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = await PdfGoogleFonts.cabinRegular();
    final font2 = await PdfGoogleFonts.cabinBold();

    doc.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: format.copyWith(
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
          theme: pw.ThemeData.withFont(
            base: font1,
            bold: font2,
          ),
        ),
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                height: 30,
              ),
              pw.Text(
                'Report',
                style: pw.TextStyle(
                  fontSize: 28,
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Row(children: [
                    pw.Text(
                      'Date : ',
                      style: pw.TextStyle(
                        fontSize: 23,
                      ),
                    ),
                    pw.Text(
                      DateFormat.yMMMEd().format(DateTime.now()),
                      style: pw.TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ]),
                  pw.Row(
                    children: [
                      pw.Text(
                        'ID : ',
                        style: pw.TextStyle(
                          fontSize: 23,
                        ),
                      ),
                      pw.Text(
                        clas,
                        style: pw.TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(
                height: 30,
              ),
              pw.Table(
                defaultColumnWidth: pw.FixedColumnWidth(120.0),
                border: pw.TableBorder.all(style: pw.BorderStyle.solid, width: 2),
                children: [
                  pw.TableRow(children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'No.',
                          style: pw.TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Model',
                          style: pw.TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Quantity',
                          style: pw.TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Date Buy',
                          style: pw.TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Date Sell',
                          style: pw.TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
              pw.ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  final listItem = list[index]; // Assuming each item is a map or object
                  final model = listItem['model'];
                  final quantity = listItem['quantity'];
                  final dateBuy = listItem['datebuy'];
                  final dateSell = listItem['datesell'];

                  return pw.Table(
                    defaultColumnWidth: pw.FixedColumnWidth(120.0),
                    border: pw.TableBorder.all(style: pw.BorderStyle.solid, width: 2),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text(
                            '${++index}', // Increment index by 1 and convert to string
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 20.0),
                          ),
                          pw.Column(
                            children: [
                              pw.Text(
                                model.toString(),
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                          pw.Column(
                            children: [
                              pw.Text(
                                quantity.toString(),
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                          pw.Column(
                            children: [
                              pw.Text(
                                dateBuy.toString(),
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                          pw.Column(
                            children: [
                              pw.Text(
                                dateSell.toString(),
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
    return doc.save();
  }
}

class PdfGoogleFonts {
  static Future<pw.Font> cabinRegular() async {
    final fontData = await rootBundle.load("assets/fonts/Cabin-Bold.ttf");
    return pw.Font.ttf(fontData.buffer.asByteData());
  }

  static Future<pw.Font> cabinBold() async {
    final fontData = await rootBundle.load("assets/fonts/Cabin-Bold.ttf");
    return pw.Font.ttf(fontData.buffer.asByteData());
  }
}
