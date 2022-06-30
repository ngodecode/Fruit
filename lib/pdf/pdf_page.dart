/// author: febri.arianto@bukalapak.com
/// date: 2022-06-22

class PdfPage<B, C> {
  final B background;
  final List<C> children = [];
  final double width;
  final double height;

  PdfPage({
    required this.background,
    required this.width,
    required this.height,
  });

  addChild(C child) {
    children.add(child);
  }
}
