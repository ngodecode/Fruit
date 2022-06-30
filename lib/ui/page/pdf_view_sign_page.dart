import 'package:flutter/material.dart';
import 'package:fruit/ui/page/pdf_aspect_ratio.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-05-31

class PdfViewSignPage extends StatefulWidget {
  final double pdfDx;
  final double pdfDy;
  final double bottomSpace;
  final int page;
  final String? path;

  const PdfViewSignPage({
    Key? key,
    required this.pdfDx,
    required this.pdfDy,
    required this.bottomSpace,
    this.page = 1,
    this.path,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PdfViewSignPageState();
}

class PdfViewSignPageState extends State<PdfViewSignPage> {
  late PdfController pdfController;
  late PdfPointer pdfPointer;

  final GlobalKey _pdfFrameKey = GlobalKey();

  int currentPage = 0;

  PdfSize? pdfSize;
  ContainerSize? containerSize;
  WidgetPointer? widgetPointer;

  @override
  void initState() {
    final path = widget.path;
    pdfController = PdfController(
      document: path != null
          ? PdfDocument.openFile(path)
          : PdfDocument.openAsset('assets/sample-pdf.pdf'),
      initialPage: widget.page,
    );
    pdfPointer = PdfPointer(dx: widget.pdfDx, dy: widget.pdfDy);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _pointer = widgetPointer;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  key: _pdfFrameKey,
                  color: Colors.grey,
                  child: _buildPdfWidget(),
                ),
                if (_pointer != null) ...[
                  Positioned(
                    left: _pointer.dx,
                    top: _pointer.dy,
                    child: _buildSignatureFrameWidget(),
                  )
                ],
              ],
            ),
          ),
          _buildBottomWidget(),
        ],
      ),
    );
  }

  Widget _buildPdfWidget() {
    return PdfView(
      controller: pdfController,
      renderer: (page) async {
        pdfSize = PdfSize(width: page.width, height: page.height);
        _showPointer();
        return page.render(
          width: page.width,
          height: page.height,
          format: PdfPageImageFormat.jpeg,
          backgroundColor: '#ffffff',
        );
      },
    );
  }

  Widget _buildBottomWidget() {
    final _pdfPixel =
        pdfSize?.viewSize(containerSize ?? ContainerSize(width: 0, height: 0));

    final _wPositon = PdfPointer(dx: 612, dy: 0).toWidgetPointer(
      container: containerSize ?? ContainerSize(width: 0, height: 0),
      pdf: pdfSize ?? PdfSize(width: 0, height: 0),
    );
    return Container(
      height: widget.bottomSpace,
      color: Colors.amberAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
                "W Pointer: ${_wPositon.dx.toStringAsFixed(2)}, ${_wPositon.dy.toStringAsFixed(2)} "),
            Text(
                "Pdf Pointer: ${pdfPointer.dx.toStringAsFixed(2)}, ${pdfPointer.dy.toStringAsFixed(2)} "),
            Text(
                "Container: ${containerSize?.width.toStringAsFixed(2)}, ${containerSize?.height.toStringAsFixed(2)} "),
            Text(
                "Container pointer: ${widgetPointer?.dx.toStringAsFixed(2)}, ${widgetPointer?.dy.toStringAsFixed(2)} "),
            Text("Pdf Origin: ${pdfSize?.width}, ${pdfSize?.height} "),
            Text(
                "Pdf Pixel: ${_pdfPixel?.width.toStringAsFixed(2)}, ${_pdfPixel?.height.toStringAsFixed(2)} "),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureFrameWidget() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        color: Colors.red,
      ),
    );
  }

  _showPointer() {
    final context = _pdfFrameKey.currentContext;
    final container = context?.findRenderObject() as RenderBox;

    setState(() {
      containerSize = ContainerSize(
        width: container.size.width,
        height: container.size.height,
      );

      widgetPointer = pdfPointer.toWidgetPointer(
        container: containerSize ?? ContainerSize(width: 0, height: 0),
        pdf: pdfSize ?? PdfSize(width: 0, height: 0),
      );
    });
  }
}
