/// author: febri.arianto@bukalapak.com
/// date: 2022-05-31

class MagicSize {
  final double width;
  final double height;
  MagicSize({required this.width, required this.height});
}

class ContainerSize extends MagicSize {
  ContainerSize({required double width, required double height})
      : super(width: width, height: height);
}

class PdfSize extends MagicSize {
  PdfSize({required double width, required double height})
      : super(width: width, height: height);
}

extension PdfSizeExt on PdfSize {
  int orientation(ContainerSize container) {
    final size = viewSize(container);
    return size.width == container.width ? 1 : 2;
  }

  double ratio(ContainerSize container) {
    double scaleW = container.width / width;
    double scaleH = container.height / height;
    return scaleW <= scaleH ? scaleW : scaleH;
  }

  MagicSize viewSize(ContainerSize container) {
    double _ratio = ratio(container);
    double _w = _ratio * width;
    double _h = _ratio * height;
    return MagicSize(width: _w, height: _h);
  }
}

class WidgetPointer {
  final double dx;
  final double dy;

  WidgetPointer({required this.dx, required this.dy});
}

class PdfPointer {
  final double dx;
  final double dy;

  PdfPointer({required this.dx, required this.dy});
}

extension WidgetPointerExt on WidgetPointer {
  PdfPointer toPdfPointer({
    required ContainerSize container,
    required PdfSize pdf,
  }) {
    final _ratio = pdf.ratio(container);
    final _view = pdf.viewSize(container);

    double _spaceSizeH = (container.height - _view.height) / 2;
    double _spaceSizeW = (container.width - _view.width) / 2;

    double _x = (dx - _spaceSizeW) / _ratio;
    double _y = (dy - _spaceSizeH) / _ratio;

    _y = pdf.height - _y;

    return PdfPointer(dx: _x, dy: _y);
  }
}

extension PdfPointerExt on PdfPointer {
  WidgetPointer toWidgetPointer({
    required ContainerSize container,
    required PdfSize pdf,
  }) {
    final _ratio = pdf.ratio(container);
    final _view = pdf.viewSize(container);

    double _spaceSizeH = (container.height - _view.height) / 2;
    double _spaceSizeW = (container.width - _view.width) / 2;

    double _dy = pdf.height - dy;
    double _x = (dx * _ratio) + _spaceSizeW;
    double _y = (_dy * _ratio) + _spaceSizeH;

    return WidgetPointer(dx: _x, dy: _y);
  }
}
