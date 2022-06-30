import 'package:flutter/material.dart';
import 'package:fruit/ui/page/pdf_aspect_ratio.dart';
import 'package:fruit/ui/page/pdf_view_sign_page.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-05-31

class PdfInputSignPage extends StatefulWidget {
  PdfInputSignPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PdfInputSignPageState();
}

class PdfInputSignPageState extends State<PdfInputSignPage> {
  final _pdfController = PdfController(
    document: PdfDocument.openAsset('assets/sample-pdf.pdf'),
  );
  final GlobalKey _pdfFrameKey = GlobalKey();
  final Map<int, PdfSize> _pdfSizeMap = {};

  Orientation? _orientation;
  bool _isShowPointer = false;
  int _currentPage = 1;
  double _dX = 0;
  double _dY = 0;
  PdfPointer? _lastPdfPointer;

  @override
  Widget build(BuildContext context) {
    // Get container size
    // Displaying PDF
    // Get PDF size
    // Get last Sign Widget Position if any
    // Render Sign Widget

    return OrientationBuilder(
      builder: (context, orientation) {
        if (_orientation?.name != orientation.name) {
          _orientation = orientation;
          _onOrientationChanged();
        }
        print('_isRendered: ${_isShowPointer}');
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
                    if (_isShowPointer) ...[
                      Positioned(
                        left: _dX,
                        top: _dY,
                        child: _buildDraggableWidget(),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: _printOut(),
                      )
                    ],
                  ],
                ),
              ),
              _buildBottomWidget(),
            ],
          ),
        );
      },
    );
  }

  void _onOrientationChanged() {
    debugPrint('_orientationChanged: ${_orientation?.name}');
    _isShowPointer = false;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        //check last position if any
        final lastPos = _lastPdfPointer;
        if (lastPos != null) {
          final pdfSize = _getPdfSize(_currentPage);
          if (pdfSize != null) {
            final newPointer = lastPos.toWidgetPointer(
              container: _getContainerSize(),
              pdf: pdfSize,
            );
            _dX = newPointer.dx;
            _dY = newPointer.dy;
          }
        }
        _isShowPointer = true;
      });
    });
  }

  ContainerSize _getContainerSize() {
    final context = _pdfFrameKey.currentContext;
    final container = context?.findRenderObject() as RenderBox;
    return ContainerSize(
      width: container.size.width,
      height: container.size.height,
    );
  }

  WidgetPointer _getWidgetPointer() {
    return WidgetPointer(dx: _dX, dy: _dY);
  }

  PdfSize? _getPdfSize(int page) {
    return _pdfSizeMap[page];
  }

  PdfPointer _calculatePdfPointer() {
    final _widget = _getWidgetPointer();
    final _container = _getContainerSize();
    final _pdfSize = _getPdfSize(_currentPage) ?? PdfSize(width: 0, height: 0);
    return _widget.toPdfPointer(
      container: _container,
      pdf: _pdfSize,
    );
  }

  void _onDrag(details) {
    setState(() {
      _dX = details.offset.dx;
      _dY = details.offset.dy;
    });
  }

  Widget _buildPdfWidget() {
    return PdfView(
      controller: _pdfController,
      onDocumentLoaded: (document) {
        debugPrint('onDocumentLoaded: ${document.pagesCount} pages');
      },
      onPageChanged: (pageNumber) {
        _currentPage = pageNumber;
      },
      renderer: (page) async {
        debugPrint('renderer: page ${page}');
        setState(() {
          // Put pdf size
          final _pdfSize = PdfSize(width: page.width, height: page.height);
          _pdfSizeMap.putIfAbsent(page.pageNumber, () => _pdfSize);

          // show pointer
          _isShowPointer = true;
        });
        final image = await page.render(
          width: page.width,
          height: page.height,
          format: PdfPageImageFormat.jpeg,
          backgroundColor: '#ffffff',
        );

        return image;
      },
    );
  }

  Widget _buildBottomWidget() {
    return Row(
      children: [
        _buttonWidget('BT_SPACE 100', 100),
        const SizedBox(width: 20),
        _buttonWidget('BT_SPACE 200', 200),
        const SizedBox(width: 20),
        _buttonWidget('BT_SPACE 400', 400),
      ],
    );
  }

  Widget _buttonWidget(String label, double spaces) {
    return TextButton(
      onPressed: () {
        final pointer = _calculatePdfPointer();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PdfViewSignPage(
              page: _currentPage,
              pdfDx: pointer.dx,
              pdfDy: pointer.dy,
              bottomSpace: spaces,
            ),
          ),
        );
      },
      child: Text(label),
    );
  }

  Widget _buildDraggableWidget() {
    return Draggable(
      child: _buildSignatureFrameWidget(),
      feedback: _buildSignatureFrameWidget(),
      onDragEnd: _onDrag,
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
      child: const Center(
        child: Text(
          'W',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _printOut() {
    final _pdfSize = _getPdfSize(_currentPage);
    final _containerSize = _getContainerSize();
    final _pxSize = _pdfSize?.viewSize(_containerSize);

    final _widgetPointer = _getWidgetPointer();
    final _pdfPointer = _calculatePdfPointer();
    _lastPdfPointer = _pdfPointer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Container Size:( ${_containerSize.width.toStringAsFixed(2)}, ${_containerSize.height.toStringAsFixed(2)} )',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
          ),
        ),
        Text(
          'PDF Size Original:( ${_pdfSize?.width.toStringAsFixed(2)}, ${_pdfSize?.height.toStringAsFixed(2)} )',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
          ),
        ),
        Text(
          'PDF Size View(px):( ${_pxSize?.width.toStringAsFixed(2)}, ${_pxSize?.height.toStringAsFixed(2)} )',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Widget Pointer:( ${_widgetPointer.dx.toStringAsFixed(2)}, ${_widgetPointer.dy.toStringAsFixed(2)} )',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
          ),
        ),
        Text(
          'PDF Pointer:( ${_pdfPointer.dx.toStringAsFixed(2)}, ${_pdfPointer.dy.toStringAsFixed(2)} )',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
