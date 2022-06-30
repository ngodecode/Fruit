import 'dart:io';
import 'dart:typed_data';

import 'package:fruit/pdf/pdf_page.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart' as pdf_renderer;

/// author: febri.arianto@bukalapak.com
/// date: 2022-06-22

extension PdfPageExt on PdfPage {
  addText(Text text, {required double dX, required double dY}) {
    children.add(
      Positioned(
        child: text,
        top: dY,
        left: dX,
      ),
    );
  }

  addImage(Image image, {required double dX, required double dY}) {
    children.add(
      Positioned(
        child: image,
        top: dY,
        left: dX,
      ),
    );
  }

  build() {
    return Page(
        pageFormat: pdf.PdfPageFormat(width, height),
        orientation: PageOrientation.portrait,
        build: (context) => Stack(children: [
              Image(
                RawImage(
                  bytes: background,
                  width: width.toInt(),
                  height: height.toInt(),
                ),
              ),
              ...children
            ]));
  }
}

class PdfEditor {
  final List<PdfPage<Uint8List?, Object>> _pages = [];

  load(String path) async {
    var file = pdf_renderer.PdfImageRendererPdf(path: path);
    await file.open();
    var count = await file.getPageCount();
    for (var i = 0; i < count; i++) {
      var size = await file.getPageSize(pageIndex: i);
      var rawImage = await file.renderPage(
        y: 0,
        width: size.width,
        height: size.height,
        scale: 1.0,
        pageIndex: i,
      );
      _pages.add(PdfPage(
        background: rawImage,
        height: size.height.toDouble(),
        width: size.width.toDouble(),
      ));
    }
    file.close();
  }

  PdfPage getPage(int index) {
    return _pages[index];
  }

  saveAs(File file) async{
    final document = Document();
    for (var page in _pages) {
      document.addPage(page.build());
    }
    file.writeAsBytes(await document.save());
  }
  
}
