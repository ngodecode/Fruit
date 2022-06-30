// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';
// import 'package:xignature_mobile/localizations/localization_constants.dart';
// import 'package:xignature_mobile/pallete.dart';
//
// class SignDocumentPlaceSignature extends StatefulWidget {
//   const SignDocumentPlaceSignature({
//     Key? key,
//     this.documentPath,
//     this.fullname,
//     this.signType,
//     this.pageController,
//     required this.useMeterai,
//     required this.xposController,
//     required this.yposController,
//     required this.isPlaceSign,
//     this.totalPageController,
//   }) : super(key: key);
//   final TextEditingController? pageController;
//   final String? documentPath;
//   final String? fullname;
//   final String? signType;
//   final bool useMeterai;
//   final bool isPlaceSign;
//   final TextEditingController? totalPageController;
//
//   final TextEditingController xposController;
//   final TextEditingController yposController;
//
//   @override
//   State<SignDocumentPlaceSignature> createState() =>
//       _SignDocumentPlaceSignatureState();
// }
//
// class _SignDocumentPlaceSignatureState
//     extends State<SignDocumentPlaceSignature> {
//   late final PdfController _pdfController;
//
//   final _widgetKey = GlobalKey();
//
//   final _cardWidgetKey = GlobalKey();
//   Size? _cardWidgetSize;
//
//   double _offsetFromTop = 0;
//   double pdfH = 0;
//   double pdfW = 0;
//   int? page = 0;
//   int totalPage = 0;
//
//   bool isReadySign = false;
//
//   @override
//   // TODO: implement mounted
//   bool get mounted => super.mounted;
//
//   @override
//   void initState() {
//     print('ini page berapa x' + widget.signType.toString());
//     page = int.parse(widget.pageController!.text) - 1;
//     _pdfController = PdfController(
//       document: widget.documentPath != null
//           ? PdfDocument.openFile(widget.documentPath!)
//           : PdfDocument.openAsset('assets/sample_document.pdf'),
//     );
//
//     getPageSize();
//
//     // Get pdf view offset from top from global position.
//     // after first frame is rendered
//     Future.delayed(Duration.zero, () {
//       final renderBox =
//           _widgetKey.currentContext!.findRenderObject() as RenderBox;
//       Offset position = renderBox.localToGlobal(Offset.zero);
//
//       renderBox.size.width
//
//       setState(() => _offsetFromTop = position.dy);
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _pdfController.dispose();
//     super.dispose();
//   }
//
//   getPageSize() async {
//     setState(() {
//       widget.totalPageController!.text = totalPage.toString();
//     });
//     await Future.delayed(Duration(milliseconds: 120));
//     setState(() {
//       isReadySign = true;
//       // widget.totalPageController!.text = totalPage.toString();
//     });
//   }
//
//   final Completer<PDFViewController> _controller =
//       Completer<PDFViewController>();
//
//   @override
//   Widget build(BuildContext context) {
//     final palette = Palette.of(context);
//     double heightContainer = MediaQuery.of(context).size.height;
//     if (int.parse(widget.pageController!.text) == 1 ||
//         int.parse(widget.pageController!.text) == totalPage) {
//       heightContainer = MediaQuery.of(context).size.height;
//     } else {
//       print(widget.signType);
//       if (widget.signType != "false") {
//         if (pdfH < 700) {
//           heightContainer = 300;
//         }
//       }
//     }
//
//     print(heightContainer);
//     return Stack(
//       key: _widgetKey,
//       children: [
//         Positioned(
//           child: Center(
//             child: Container(
//               height: heightContainer,
//               // height: int.parse(widget.pageController!.text) == 1 ||
//               //         int.parse(widget.pageController!.text) == totalPage
//               //     ? MediaQuery.of(context).size.height
//               //     : pdfH < 700
//               //         ? widget.signType == "false"
//               //             ? MediaQuery.of(context).size.height
//               //             : Platform.isAndroid
//               //                 ? 300
//               //                 : MediaQuery.of(context).size.height
//               //         : MediaQuery.of(context).size.height,
//               decoration: BoxDecoration(
//                   color: pdfH < 840
//                       ? Color.fromARGB(255, 81, 80, 80)
//                       : palette.background2),
//               child: (isReadySign == true)
//                   ? PDFView(
//                       enableDoubleTap: false,
//                       setBackgroundColor: Color.fromARGB(255, 81, 80, 80),
//                       filePath: widget.documentPath,
//                       enableSwipe: widget.signType == "false" ? true : false,
//                       swipeHorizontal: false,
//                       autoSpacing: true,
//                       pageFling: false,
//                       pageSnap: false,
//                       defaultPage: page!,
//                       fitPolicy: FitPolicy.BOTH,
//                       fitEachPage: false,
//                       spacing: 10,
//                       setMaxZoom: 1,
//                       setMidZoom: 1,
//                       setMinZoom: 1,
//
//                       onRender: (_pages) {
//                         setState(() {
//                           if (pdfH == 0.0) {
//                             print("reload");
//                           }
//
//                           page = _pages;
//                           // isReady = true;
//                         });
//                       },
//                       onError: (error) {
//                         setState(() {
//                           // errorMessage = error.toString();
//                         });
//                         print(error.toString());
//                       },
//                       onPageError: (page, error) {
//                         setState(() {
//                           // errorMessage = '$page: ${error.toString()}';
//                         });
//                         print('$page: ${error.toString()}');
//                       },
//                       onViewCreated: (PDFViewController pdfViewController) {
//                         // _controller.complete(pdfViewController.getPageCount())
//                       },
//                       // onLinkHandler: (String? uri) {
//                       //   print('goto uri: $uri');
//                       // },
//                       onPageChanged: (int? page, int? total) {
//                         setState(() {
//                           totalPage = total!;
//                           page = page! + 1;
//                           widget.pageController!.text = page.toString();
//                           widget.totalPageController!.text = total.toString();
//                         });
//                         print('page change: $page/$total');
//                       },
//                     )
//                   : PdfView(
//                       pageSnapping: true,
//                       renderer: (page) {
//                         setState(() {
//                           pdfH = page.height.toDouble();
//                           pdfW = page.width.toDouble();
//                           widget.totalPageController!.text =
//                               page.document.pagesCount.toString();
//                           totalPage = page.document.pagesCount;
//                         });
//                         print("render sini bang " +
//                             widget.totalPageController!.text);
//                         return page.render(
//                           width: page.width,
//                           height: page.height,
//                           format: PdfPageFormat.JPEG,
//                         );
//                       },
//                       pageBuilder: (
//                         Future<PdfPageImage> pageImage,
//                         int index,
//                         PdfDocument document,
//                       ) =>
//                           PhotoViewGalleryPageOptions(
//                         imageProvider: PdfPageImageProvider(
//                           pageImage,
//                           index,
//                           document.id,
//                         ),
//                         disableGestures: true,
//                         minScale: PhotoViewComputedScale.contained,
//                         maxScale: PhotoViewComputedScale.contained,
//                         initialScale: PhotoViewComputedScale.contained,
//                         heroAttributes: PhotoViewHeroAttributes(
//                             tag: '${document.id}-$index'),
//                       ),
//                       controller: _pdfController,
//                       scrollDirection: Axis.vertical,
//                       backgroundDecoration: BoxDecoration(color: Colors.black),
//                       onPageChanged: (page) {
//                         setState(() {
//                           widget.pageController!.text = page.toString();
//                         });
//                       },
//                     ),
//             ),
//           ),
//         ),
//         widget.signType == 'REQUEST_OTHER' || widget.signType == 'false'
//             ? Container()
//             : _SignatureContainer(
//                 currentPage: int.parse(widget.pageController!.text),
//                 totalPage: totalPage,
//                 pdfHeight: pdfH,
//                 pdfWidth: pdfW,
//                 offsetFromTop: _offsetFromTop,
//                 fullname: widget.fullname,
//                 xposController: widget.xposController,
//                 yposController: widget.yposController,
//                 useMeterai: widget.useMeterai,
//                 isPlaceSign: widget.isPlaceSign,
//               ),
//       ],
//     );
//   }
// }
//
// class _SignatureContainer extends StatefulWidget {
//   const _SignatureContainer({
//     Key? key,
//     required this.currentPage,
//     required this.totalPage,
//     required this.pdfHeight,
//     required this.pdfWidth,
//     required this.offsetFromTop,
//     required this.xposController,
//     required this.yposController,
//     required this.useMeterai,
//     required this.isPlaceSign,
//     this.fullname,
//   }) : super(key: key);
//   final int currentPage;
//   final int totalPage;
//   final double offsetFromTop;
//   final double pdfHeight;
//   final double pdfWidth;
//   final String? fullname;
//   final bool useMeterai;
//   final bool isPlaceSign;
//   final TextEditingController xposController;
//   final TextEditingController yposController;
//
//   @override
//   State<_SignatureContainer> createState() => _SignatureContainerState();
// }
//
// class _SignatureContainerState extends State<_SignatureContainer> {
//   double appBarHeight = AppBar().preferredSize.height;
//   late Offset _offset = Offset(2, appBarHeight);
//   Offset _panInitOffset = Offset.zero;
//
//   Size? _signatureSize;
//   Size? _signaturePreviewSize;
//
//   bool qrPosition = false;
//
//   final _draggableKey = GlobalKey();
//
//   @override
//   void initState() {
//     /// Get signature size, after first is frame rendered
//     if (widget.isPlaceSign == true) {
//       Future.delayed(Duration.zero, () {
//         final renderBox =
//             _draggableKey.currentContext!.findRenderObject() as RenderBox;
//
//         setState(() => _signatureSize = renderBox.size);
//       });
//     }
//
//     super.initState();
//   }
//
//   /// Set signature position
//   void _onDragEnd(DraggableDetails details) {
//     var newOffset;
//
//     print("offset " + details.offset.toString());
//
//     double heightSize = MediaQuery.of(context).size.height;
//     double widthSize = MediaQuery.of(context).size.width;
//
//     print('screen height ' + heightSize.toString());
//     print('screen width ' + widthSize.toString());
//
//     double pdfHeight = widget.pdfHeight;
//     double pdfWidth = widget.pdfWidth;
//
//     print('pdf height ' + widget.pdfHeight.toString());
//     print('pdf width ' + widget.pdfWidth.toString());
//
//     double marginHPdf = pdfHeight - heightSize;
//     double marginWPdf = pdfWidth - widthSize;
//
//     double dx = 0;
//     double dy = 0;
//
//     double _offsetDY = 0;
//     double _offsetDX = 0;
//
//     newOffset = details.offset - Offset(2, widget.offsetFromTop);
//     print("new Offset " + newOffset.toString());
//
//     double scaleVertical = newOffset.dy;
//     double scaleHorizontal = newOffset.dx;
//
//     double marginPaperHeight = 0;
//     double marginPaperWidth = 0;
//
//     double pageSizeHight = 842;
//     double pageSizeWidth = 595;
//     double heighScreenSize = 640;
//     double widthScreenSize = 360;
//
//     if (heightSize > 1000) {
//       // Size PDF A4
//       if (pdfHeight == pageSizeHight) {
//         if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//           print("besar");
//           dy = pdfHeight - (details.offset.dy * 0.80);
//           var a = ((heightSize - widget.offsetFromTop) / 4);
//           print("kecil " + a.toString());
//           setState(() {
//             qrPosition = true;
//           });
//         } else {
//           print("kecil");
//           dy = pdfHeight - (details.offset.dy * 0.75);
//           var a = ((heightSize - widget.offsetFromTop) / 4);
//           print("kecil " + dy.toString());
//           if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//             print("kecil sini " + a.toString());
//             dy = pdfHeight - (details.offset.dy * 0.75);
//           }
//
//           setState(() {
//             qrPosition = false;
//           });
//         }
//
//         dx = details.offset.dx * 0.75;
//
//         setState(() {
//           if (newOffset.dy < 0) {
//             _offset = Offset(newOffset.dx, widget.offsetFromTop);
//           } else if (dy < 0) {
//             _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//           } else if (dx > widthSize) {
//             print('siniiiiii ' + dx.toString());
//
//             _offset = Offset(_offsetDX, newOffset.dy);
//           } else if (dx < 0) {
//             dx = 0;
//             _offset = Offset(0, newOffset.dy);
//           } else if (dx > pdfWidth) {
//             _offset = Offset(widthSize - marginWPdf, dy);
//           } else {
//             _offset = newOffset;
//           }
//         });
//       }
//
//       // Size PDF > A4
//       if (pdfHeight > pageSizeHight) {
//         if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//           print("besar");
//           dy = pdfHeight -
//               (details.offset.dy * 0.725) -
//               (pdfHeight - pageSizeHight);
//           var a = ((heightSize - widget.offsetFromTop) / 4);
//           print("kecil " + a.toString());
//           setState(() {
//             qrPosition = true;
//           });
//         } else {
//           print("kecil");
//           dy = pdfHeight -
//               (details.offset.dy * 0.75) -
//               (pdfHeight - pageSizeHight);
//           var a = ((heightSize - widget.offsetFromTop) / 4);
//           print("kecil " + dy.toString());
//           if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//             print("kecil sini " + a.toString());
//             dy = pdfHeight -
//                 (details.offset.dy * 0.75) -
//                 (pdfHeight - pageSizeHight);
//           }
//
//           setState(() {
//             qrPosition = false;
//           });
//         }
//
//         dx = details.offset.dx * 0.75;
//
//         setState(() {
//           if (newOffset.dy < 0) {
//             _offset = Offset(newOffset.dx, widget.offsetFromTop);
//           } else if (dy < 0) {
//             _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//           } else if (dx > widthSize) {
//             print('siniiiiii ' + dx.toString());
//
//             _offset = Offset(_offsetDX, newOffset.dy);
//           } else if (dx < 0) {
//             dx = 0;
//             _offset = Offset(0, newOffset.dy);
//           } else if (dx > pdfWidth) {
//             _offset = Offset(widthSize - marginWPdf, dy);
//           } else {
//             _offset = newOffset;
//           }
//         });
//       }
//
//       // Size PDF < A4
//       if (pdfHeight < pageSizeHight) {
//         if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//           print("besar");
//           dy = pdfHeight - (details.offset.dy * 0.80);
//           var a = ((heightSize - widget.offsetFromTop) / 4);
//           print("kecil " + a.toString());
//           setState(() {
//             qrPosition = true;
//           });
//         } else {
//           print("kecil");
//           dy = pdfHeight - (details.offset.dy * 0.75);
//           var a = ((heightSize - widget.offsetFromTop) / 4);
//           print("kecil " + dy.toString());
//           if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//             print("kecil sini " + a.toString());
//             dy = pdfHeight - (details.offset.dy * 0.75);
//           }
//
//           setState(() {
//             qrPosition = false;
//           });
//         }
//
//         dx = details.offset.dx * 0.75;
//
//         setState(() {
//           if (newOffset.dy < 0) {
//             _offset = Offset(newOffset.dx, widget.offsetFromTop);
//           } else if (dy < 0) {
//             _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//           } else if (dx > widthSize) {
//             print('siniiiiii ' + dx.toString());
//
//             _offset = Offset(_offsetDX, newOffset.dy);
//           } else if (dx < 0) {
//             dx = 0;
//             _offset = Offset(0, newOffset.dy);
//           } else if (dx > pdfWidth) {
//             _offset = Offset(widthSize - marginWPdf, dy);
//           } else {
//             _offset = newOffset;
//           }
//         });
//       }
//     }
//
//     // SIZE SCREEN UNDER 1000px
//     if (heightSize < 1000) {
//       // Size PDF A4
//       if (pdfHeight == pageSizeHight) {
//         // if (Platform.isAndroid) {
//         _offsetDY = widget.offsetFromTop;
//         _offsetDX = widthSize / 1.5;
//
//         // Size screen = 640
//         if (heightSize == heighScreenSize) {
//           // For Portait
//           if (pdfHeight == pageSizeHight) {
//             if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//               print("besar");
//               dy = pdfHeight - (details.offset.dy * 1.55);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//             } else {
//               print("kecil");
//               dy = pdfHeight - (details.offset.dy * 1.35);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//               if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//                 dy = pdfHeight - (details.offset.dy * 1.4);
//               }
//             }
//
//             dx = details.offset.dx * 1.55;
//
//             setState(() {
//               if (newOffset.dy < 0) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//               } else if (dx > widthSize) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else if (dx > pdfWidth) {
//                 _offset = Offset(widthSize - marginWPdf, dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//
//           // For Landscape
//           if (pdfHeight == pageSizeWidth) {
//             if (details.offset.dy > heightSize / 2) {
//               print("besar landscape");
//               dy = pdfHeight - (details.offset.dy * 1.3);
//             } else {
//               print("kecil");
//               dy = pdfHeight - (details.offset.dy * 1.055);
//             }
//             dx = details.offset.dx * 2.5;
//
//             setState(() {
//               if (newOffset.dy < widget.offsetFromTop) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, 300);
//               } else if (dx > pdfWidth) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//         }
//
//         // Size screen > 640
//         if (heightSize > heighScreenSize) {
//           // For Potrait
//           if (pdfHeight == pageSizeHight) {
//             if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//               print("besar");
//               dy = pdfHeight -
//                   (details.offset.dy * 1.55) +
//                   (heightSize - heighScreenSize);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//               setState(() {
//                 qrPosition = true;
//               });
//             } else {
//               print("kecil");
//               dy = pdfHeight -
//                   (details.offset.dy * 1.35) +
//                   (heightSize - heighScreenSize);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + dy.toString());
//               if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//                 print("kecil sini " + a.toString());
//                 dy = pdfHeight -
//                     (details.offset.dy * 1.4) +
//                     (heightSize - heighScreenSize);
//               }
//
//               setState(() {
//                 qrPosition = false;
//               });
//             }
//
//             dx = details.offset.dx * 1.45;
//
//             if (heightSize > 700 && heightSize < 800) {
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 1.05);
//                 } else {
//                   dy = dy - (widget.offsetFromTop * 1.4);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 dy = dy;
//               } else if (widget.totalPage == 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy;
//                 }
//               }
//             }
//
//             if (heightSize > 800 && heightSize < 900) {
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 print("sini bang 800 " + qrPosition.toString());
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 0.75);
//                 } else {
//                   dy = dy - (widget.offsetFromTop * 1.4);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 dy = dy;
//               } else if (widget.totalPage == 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy;
//                 }
//               }
//             }
//
//             if (heightSize > 900 && heightSize < 1000) {
//               print("sini bang 900 " + qrPosition.toString());
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 0.75);
//                 } else {
//                   dy = dy - (widget.offsetFromTop * 1.4);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 if (qrPosition == false) {
//                   dy = dy - widget.offsetFromTop;
//                 } else {
//                   dy = dy - appBarHeight;
//                 }
//               } else if (widget.totalPage == 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - widget.offsetFromTop;
//                 } else {
//                   dy = dy - appBarHeight;
//                 }
//               }
//             }
//
//             setState(() {
//               if (newOffset.dy < 0) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//               } else if (dx > widthSize) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else if (dx > pdfWidth) {
//                 _offset = Offset(widthSize - marginWPdf, dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//           // For Landscape
//           if (pdfHeight == pageSizeWidth) {
//             print("landsacpe");
//             if (details.offset.dy > heightSize / 2) {
//               print("besar");
//               dy = pageSizeHight -
//                   (details.offset.dy * 1.7) -
//                   (heightSize - heighScreenSize);
//             } else {
//               print("kecil");
//               dy = pageSizeHight -
//                   (details.offset.dy * 1.55) -
//                   (heightSize - heighScreenSize);
//             }
//             dx = details.offset.dx * 2;
//
//             if (heightSize > 700 && heightSize < 800) {
//               if (details.offset.dy > heightSize / 2) {
//                 dy = pageSizeHight -
//                     (details.offset.dy * 1.25) -
//                     (heightSize - heighScreenSize);
//               } else {
//                 dy = pageSizeHight -
//                     (details.offset.dy * 1.05) -
//                     (heightSize - heighScreenSize);
//               }
//             }
//
//             if (heightSize > 800 && heightSize < 900) {
//               print("800 sini bang");
//               if (details.offset.dy > heightSize / 2) {
//                 print("besar");
//                 dy = pageSizeHight -
//                     (details.offset.dy * 1.15) -
//                     (heightSize - heighScreenSize);
//               } else {
//                 print("kecil");
//                 dy = pageSizeHight -
//                     (details.offset.dy * 0.5) -
//                     (heightSize - heighScreenSize);
//               }
//             }
//
//             setState(() {
//               if (newOffset.dy < widget.offsetFromTop) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, 300);
//               } else if (dx > pdfWidth) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//         }
//
//         // Size screen < 640
//         if (heightSize < heighScreenSize) {
//           // For Portait
//           if (pdfHeight == pageSizeHight) {
//             if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//               print("besar");
//               dy = pdfHeight -
//                   (heighScreenSize - heightSize) -
//                   (details.offset.dy * 1.55);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil - " + a.toString());
//             } else {
//               print("kecil");
//               dy = pdfHeight - (details.offset.dy * 1.25);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//               if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//                 print("kecil sini lagi " + a.toString());
//                 dy = pdfHeight -
//                     (heighScreenSize - heightSize) -
//                     (details.offset.dy * 1.4);
//               }
//             }
//
//             dx = details.offset.dx * 1.55;
//
//             setState(() {
//               if (newOffset.dy < 0) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//               } else if (dx > widthSize) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else if (dx > pdfWidth) {
//                 _offset = Offset(widthSize - marginWPdf, dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//
//           // For Landscape
//           if (pdfHeight == pageSizeWidth) {
//             if (details.offset.dy > heightSize / 2) {
//               print("besar");
//               dy = pdfHeight -
//                   (heighScreenSize - heightSize) -
//                   (details.offset.dy * 1.3);
//             } else {
//               print("kecil");
//               dy = pdfHeight -
//                   // (heighScreenSize - heightSize) -
//                   (details.offset.dy * 1.055);
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 dy = pdfHeight -
//                     // (heighScreenSize - heightSize) -
//                     (details.offset.dy * 0.65);
//               }
//             }
//             dx = details.offset.dx * 2.5;
//
//             setState(() {
//               if (newOffset.dy < widget.offsetFromTop) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, 300);
//               } else if (dx > pdfWidth) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//         }
//         // }
//       }
//
//       // Size PDF UP A4
//       if (pdfHeight > pageSizeHight) {
//         // if (Platform.isAndroid) {
//         _offsetDY = widget.offsetFromTop;
//         _offsetDX = widthSize / 1.5;
//
//         // Size screen = 640
//         if (heightSize == heighScreenSize) {
//           if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//             print("besar");
//             dy = pdfHeight - (details.offset.dy * 1.685);
//             var a = ((heightSize - widget.offsetFromTop) / 4);
//             print("kecil " + a.toString());
//           } else {
//             print("kecil");
//             dy = pdfHeight - (details.offset.dy * 1.35);
//             var a = ((heightSize - widget.offsetFromTop) / 4);
//             print("kecil " + a.toString());
//             if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//               dy = pdfHeight - (details.offset.dy * 1.65);
//             }
//           }
//
//           dx = details.offset.dx * 1.55;
//
//           setState(() {
//             if (newOffset.dy < 0) {
//               _offset = Offset(newOffset.dx, widget.offsetFromTop);
//             } else if (dy < 0) {
//               _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//             } else if (dx > widthSize) {
//               print('siniiiiii ' + dx.toString());
//
//               _offset = Offset(_offsetDX, newOffset.dy);
//             } else if (dx < 0) {
//               dx = 0;
//               _offset = Offset(0, newOffset.dy);
//             } else if (dx > pdfWidth) {
//               _offset = Offset(widthSize - marginWPdf, dy);
//             } else {
//               _offset = newOffset;
//             }
//           });
//         }
//
//         // Size screen > 640
//         if (heightSize > heighScreenSize) {
//           // For Potrait
//           if (pdfHeight > pageSizeHight) {
//             if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//               print("besar");
//               dy = pdfHeight -
//                   (pdfHeight - pageSizeHight) -
//                   (details.offset.dy * 1.45) +
//                   (heightSize - heighScreenSize);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//               setState(() {
//                 qrPosition = true;
//               });
//             } else {
//               print("kecil");
//               dy = pdfHeight -
//                   (pdfHeight - pageSizeHight) -
//                   (details.offset.dy * 1) +
//                   (heightSize - heighScreenSize);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + dy.toString());
//               if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//                 print("kecil sini " + a.toString());
//                 dy = pdfHeight -
//                     (pdfHeight - pageSizeHight) -
//                     (details.offset.dy * 1.2) +
//                     (heightSize - heighScreenSize);
//               }
//
//               setState(() {
//                 qrPosition = false;
//               });
//             }
//
//             dx = details.offset.dx * 1.4;
//
//             if (heightSize > 700 && heightSize < 800) {
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 1.05);
//                 } else {
//                   dy = dy - (widget.offsetFromTop * 1.4);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 dy = dy;
//               } else if (widget.totalPage == 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy;
//                 }
//               }
//             }
//
//             if (heightSize > 800 && heightSize < 900) {
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 print("sini bang 800 " + qrPosition.toString());
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 0.75);
//                 } else {
//                   dy = dy - (widget.offsetFromTop * 1.4);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 dy = dy;
//               } else if (widget.totalPage == 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - (widget.offsetFromTop * 1.45);
//                 } else {
//                   dy = dy;
//                 }
//               }
//             }
//
//             setState(() {
//               if (newOffset.dy < 0) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//               } else if (dx > widthSize) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else if (dx > pdfWidth) {
//                 _offset = Offset(widthSize - marginWPdf, dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//           // For Landscape
//           if (pdfHeight == pageSizeWidth) {
//             print("landsacpe");
//             if (details.offset.dy > heightSize / 2) {
//               print("besar");
//               dy = pageSizeHight -
//                   (details.offset.dy * 1.7) -
//                   (heightSize - heighScreenSize);
//             } else {
//               print("kecil");
//               dy = pageSizeHight -
//                   (details.offset.dy * 1.55) -
//                   (heightSize - heighScreenSize);
//             }
//             dx = details.offset.dx * 2;
//
//             if (heightSize > 700 && heightSize < 800) {
//               if (details.offset.dy > heightSize / 2) {
//                 dy = pageSizeHight -
//                     (details.offset.dy * 1.25) -
//                     (heightSize - heighScreenSize);
//               } else {
//                 dy = pageSizeHight -
//                     (details.offset.dy * 1.05) -
//                     (heightSize - heighScreenSize);
//               }
//             }
//
//             if (heightSize > 800 && heightSize < 900) {
//               if (details.offset.dy > heightSize / 2) {
//                 dy = pageSizeHight -
//                     (details.offset.dy * 1.25) -
//                     (heightSize - heighScreenSize);
//               } else {
//                 dy = pageSizeHight -
//                     (details.offset.dy) -
//                     (heightSize - heighScreenSize);
//               }
//             }
//
//             setState(() {
//               if (newOffset.dy < widget.offsetFromTop) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, 300);
//               } else if (dx > pdfWidth) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//         }
//
//         // Size screen < 640
//         if (heightSize < heighScreenSize) {
//           if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//             print("besar");
//             dy = pdfHeight - (details.offset.dy * 1.85);
//             var a = ((heightSize - widget.offsetFromTop) / 4);
//             print("kecil " + a.toString());
//           } else {
//             print("kecil");
//             dy = pdfHeight - (details.offset.dy * 1.35);
//             var a = ((heightSize - widget.offsetFromTop) / 4);
//             print("kecil " + a.toString());
//             if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//               dy = pdfHeight - (details.offset.dy * 1.65);
//             }
//           }
//
//           dx = details.offset.dx * 1.45;
//
//           setState(() {
//             if (newOffset.dy < 0) {
//               _offset = Offset(newOffset.dx, widget.offsetFromTop);
//             } else if (dy < 0) {
//               _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//             } else if (dx > widthSize) {
//               print('siniiiiii ' + dx.toString());
//
//               _offset = Offset(_offsetDX, newOffset.dy);
//             } else if (dx < 0) {
//               dx = 0;
//               _offset = Offset(0, newOffset.dy);
//             } else if (dx > pdfWidth) {
//               _offset = Offset(widthSize - marginWPdf, dy);
//             } else {
//               _offset = newOffset;
//             }
//           });
//         }
//         // }
//       }
//
//       // Size PDF UNDER A4
//       if (pdfHeight < pageSizeHight) {
//         // if (Platform.isAndroid) {
//         _offsetDY = widget.offsetFromTop;
//         _offsetDX = widthSize / 1.5;
//
//         // Size screen = 640
//         if (heightSize == heighScreenSize) {
//           // For Portait
//           if (pdfHeight < pageSizeHight) {
//             if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//               print("besar");
//               dy = pdfHeight - (details.offset.dy * 1.55);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//             } else {
//               print("kecil");
//               dy = pdfHeight - (details.offset.dy * 1.35);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//               if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//                 dy = pdfHeight - (details.offset.dy * 1.4);
//               }
//             }
//
//             dx = details.offset.dx * 1.55;
//
//             setState(() {
//               if (newOffset.dy < 0) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//               } else if (dx > widthSize) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else if (dx > pdfWidth) {
//                 _offset = Offset(widthSize - marginWPdf, dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//
//           // For Landscape
//           if (pdfHeight == pageSizeWidth) {
//             if (details.offset.dy > heightSize / 2) {
//               print("besar landscape");
//               dy = pdfHeight - (details.offset.dy * 1.3);
//             } else {
//               print("kecil");
//               dy = pdfHeight - (details.offset.dy * 1.055);
//             }
//             dx = details.offset.dx * 2.5;
//
//             setState(() {
//               if (newOffset.dy < widget.offsetFromTop) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, 300);
//               } else if (dx > pdfWidth) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//         }
//
//         // Size screen > 640
//         if (heightSize > heighScreenSize) {
//           // For Potrait
//           if (pdfHeight < pageSizeHight && pdfWidth == pageSizeWidth) {
//             if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//               print("besar");
//               dy = pdfHeight -
//                   (details.offset.dy * 1.55) +
//                   (heightSize - heighScreenSize);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//               setState(() {
//                 qrPosition = true;
//               });
//             } else {
//               print("kecil");
//               dy = pdfHeight -
//                   (details.offset.dy * 1.35) +
//                   (heightSize - heighScreenSize);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + dy.toString());
//               if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//                 print("kecil sini tong " + a.toString());
//                 dy = pdfHeight -
//                     (details.offset.dy * 1.4) +
//                     (heightSize - heighScreenSize);
//               }
//
//               setState(() {
//                 qrPosition = false;
//               });
//             }
//
//             dx = details.offset.dx * 1.45;
//
//             if (heightSize > 700 && heightSize < 800) {
//               print("qrPosition sini " + qrPosition.toString());
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 1.05);
//                 } else {
//                   dy = dy - (widget.offsetFromTop * 1.4);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy;
//                 }
//               } else if (widget.totalPage == 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy;
//                 }
//               }
//             }
//
//             if (heightSize > 800 && heightSize < 900) {
//               print("sini bang 800 " + qrPosition.toString());
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 0.75);
//                 } else {
//                   dy = dy - (widget.offsetFromTop * 1.4);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 print("qrPosition 1 " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy - ((pageSizeHight - pdfHeight) - appBarHeight);
//                 }
//               } else if (widget.totalPage == 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy;
//                 }
//               }
//             }
//
//             if (heightSize > 900 && heightSize < 1000) {
//               print("sini bang 900 " + qrPosition.toString());
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 0.75);
//                 } else {
//                   dy = dy - (widget.offsetFromTop);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 print("qrPosition 1 " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - widget.offsetFromTop;
//                 } else {
//                   dy = dy - ((pageSizeHight - pdfHeight) - appBarHeight);
//                 }
//               } else if ((widget.totalPage == 1 && widget.currentPage == 1) ||
//                   widget.currentPage == widget.totalPage) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - widget.offsetFromTop;
//                 } else {
//                   dy = dy - appBarHeight;
//                 }
//               }
//             }
//
//             setState(() {
//               if (newOffset.dy < 0) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//               } else if (dx > widthSize) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else if (dx > pdfWidth) {
//                 _offset = Offset(widthSize - marginWPdf, dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//
//           if (pdfHeight < pageSizeHight && pdfWidth > pageSizeWidth) {
//             if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//               print("besar");
//               dy = pdfHeight -
//                   (details.offset.dy * 1.55) +
//                   (heightSize - heighScreenSize);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//               setState(() {
//                 qrPosition = true;
//               });
//             } else {
//               print("kecil");
//               dy = pdfHeight -
//                   (details.offset.dy * 1.35) +
//                   (heightSize - heighScreenSize);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + dy.toString());
//               if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//                 print("kecil sini tong " + a.toString());
//                 dy = pdfHeight -
//                     (details.offset.dy * 1.45) +
//                     (heightSize - heighScreenSize);
//               }
//
//               setState(() {
//                 qrPosition = false;
//               });
//             }
//
//             dx = details.offset.dx * 1.45;
//
//             if (heightSize > 700 && heightSize < 800) {
//               print("qrPosition " + qrPosition.toString());
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 1.05);
//                 } else {
//                   dy = dy - (widget.offsetFromTop * 1.4);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 dy = dy;
//               } else if (widget.totalPage == 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy;
//                 }
//               }
//             }
//
//             if (heightSize > 800 && heightSize < 900) {
//               print("sini bang 800 " + qrPosition.toString());
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 if (qrPosition == true) {
//                   dy = dy - (widget.offsetFromTop * 0.75);
//                 } else {
//                   dy = dy - (widget.offsetFromTop * 1.4);
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 print("qrPosition 1 " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy - ((pageSizeHight - pdfHeight) - appBarHeight);
//                 }
//               } else if (widget.totalPage == 1 && widget.currentPage == 1) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - appBarHeight;
//                 } else {
//                   dy = dy;
//                 }
//               }
//             }
//
//             if (heightSize > 900 && heightSize < 1000) {
//               print("sini bang 900 " + qrPosition.toString());
//               if (widget.currentPage != 1 &&
//                   widget.currentPage != widget.totalPage) {
//                 if (qrPosition == false) {
//                   dy = dy - widget.offsetFromTop;
//                 } else {
//                   dy = dy - ((pageSizeHight - pdfHeight));
//                 }
//               } else if (widget.totalPage > 1 && widget.currentPage == 1) {
//                 print("qrPosition 1 " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - widget.offsetFromTop;
//                 } else {
//                   dy = dy - ((pageSizeHight - pdfHeight) - appBarHeight);
//                 }
//               } else if (widget.totalPage == 1 && widget.currentPage == 1 ||
//                   widget.currentPage == widget.totalPage) {
//                 print("qrPosition " + qrPosition.toString());
//                 if (qrPosition == false) {
//                   dy = dy - widget.offsetFromTop;
//                 } else {
//                   dy = dy;
//                 }
//               }
//             }
//
//             setState(() {
//               if (newOffset.dy < 0) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//               } else if (dx > widthSize) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else if (dx > pdfWidth) {
//                 _offset = Offset(widthSize - marginWPdf, dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//
//           // For Landscape
//           if (pdfHeight == pageSizeWidth) {
//             print("landsacpe");
//             if (details.offset.dy > heightSize / 2) {
//               print("besar");
//               dy = pageSizeHight -
//                   (details.offset.dy * 1.7) -
//                   (heightSize - heighScreenSize);
//             } else {
//               print("kecil");
//               dy = pageSizeHight -
//                   (details.offset.dy * 1.55) -
//                   (heightSize - heighScreenSize);
//             }
//             dx = details.offset.dx * 2;
//
//             if (heightSize > 700 && heightSize < 800) {
//               if (details.offset.dy > heightSize / 2) {
//                 dy = pageSizeHight -
//                     (details.offset.dy * 1.25) -
//                     (heightSize - heighScreenSize);
//               } else {
//                 dy = pageSizeHight -
//                     (details.offset.dy * 1.05) -
//                     (heightSize - heighScreenSize);
//               }
//             }
//
//             if (heightSize > 800 && heightSize < 900) {
//               print("800 sini bang");
//               if (details.offset.dy > heightSize / 2) {
//                 print("besar");
//                 dy = pageSizeHight -
//                     (details.offset.dy * 1.15) -
//                     (heightSize - heighScreenSize);
//               } else {
//                 print("kecil");
//                 dy = pageSizeHight -
//                     (details.offset.dy * 0.5) -
//                     (heightSize - heighScreenSize);
//               }
//             }
//
//             if (heightSize > 900 && heightSize < 1000) {
//               print("900 sini bang");
//               if (details.offset.dy > heightSize / 2) {
//                 print("besar");
//                 dy = pageSizeHight -
//                     (details.offset.dy * 0.95) -
//                     (heightSize - heighScreenSize);
//               } else {
//                 print("kecil");
//                 dy = pageSizeHight -
//                     (details.offset.dy * 0.5) -
//                     (heightSize - heighScreenSize);
//               }
//             }
//
//             setState(() {
//               if (newOffset.dy < widget.offsetFromTop) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, 300);
//               } else if (dx > pdfWidth) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//         }
//
//         // Size screen < 640
//         if (heightSize < heighScreenSize) {
//           // For Portait
//           if (pdfHeight < pageSizeHight) {
//             if (details.offset.dy > (heightSize - appBarHeight) / 2) {
//               print("besar");
//               dy = pdfHeight - (details.offset.dy * 1.6);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//             } else {
//               print("kecil");
//               dy = pdfHeight - (details.offset.dy * 1.35);
//               var a = ((heightSize - widget.offsetFromTop) / 4);
//               print("kecil " + a.toString());
//               if (details.offset.dy > ((heightSize - appBarHeight) / 2) / 2) {
//                 print("kecil sini " + a.toString());
//                 dy = pdfHeight - (details.offset.dy * 1.4);
//               }
//             }
//
//             dx = details.offset.dx * 1.55;
//
//             setState(() {
//               if (newOffset.dy < 0) {
//                 _offset = Offset(newOffset.dx, widget.offsetFromTop);
//               } else if (dy < 0) {
//                 _offset = Offset(newOffset.dx, details.offset.dy / 1.5);
//               } else if (dx > widthSize) {
//                 print('siniiiiii ' + dx.toString());
//
//                 _offset = Offset(_offsetDX, newOffset.dy);
//               } else if (dx < 0) {
//                 dx = 0;
//                 _offset = Offset(0, newOffset.dy);
//               } else if (dx > pdfWidth) {
//                 _offset = Offset(widthSize - marginWPdf, dy);
//               } else {
//                 _offset = newOffset;
//               }
//             });
//           }
//         }
//         // }
//       }
//     }
//
//     print('DY + ${dy}');
//     print('DX + ${dx}');
//
//     setState(() {
//       dx = widget.useMeterai == true ? dx + 30 : dx;
//
//       widget.xposController.text = dx.toString();
//       widget.yposController.text = dy.toString();
//     });
//
//     print("top " + widget.offsetFromTop.toString());
//   }
//
//   /// Set signature size
//   void _onResize(DragUpdateDetails details) {
//     final dxRatio = details.globalPosition.dx / _panInitOffset.dx;
//     final dyRatio = details.globalPosition.dy / _panInitOffset.dy;
//
//     setState(() {
//       _signaturePreviewSize = Size(
//         _signatureSize!.width * dxRatio,
//         _signatureSize!.height * dyRatio,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final palette = Palette.of(context);
//     double heightSize = MediaQuery.of(context).size.height;
//     double widthSize = MediaQuery.of(context).size.width;
//
//     return widget.isPlaceSign == true
//         ? Positioned(
//             left: _offset.dx,
//             top: _offset.dy,
//             child: Stack(
//               children: [
//                 Draggable(
//                   key: _draggableKey,
//                   feedback: _SignatureImage(
//                     useMeterai: widget.useMeterai,
//                     width: heightSize > 1000 ? 400 : 200,
//                     height: 50,
//                     size: _signatureSize,
//                     previewSize: _signaturePreviewSize,
//                     fullname: widget.fullname,
//                   ),
//                   childWhenDragging: Opacity(
//                     opacity: .3,
//                     child: _SignatureImage(
//                       useMeterai: widget.useMeterai,
//                       width: heightSize > 1000 ? 400 : 200,
//                       height: 50,
//                       size: _signatureSize,
//                       previewSize: _signaturePreviewSize,
//                       fullname: widget.fullname,
//                     ),
//                   ),
//                   onDragEnd: _onDragEnd,
//                   child: _SignatureImage(
//                     useMeterai: widget.useMeterai,
//                     width: heightSize > 1000 ? 400 : 200,
//                     height: 50,
//                     size: _signatureSize,
//                     previewSize: _signaturePreviewSize,
//                     fullname: widget.fullname,
//                   ),
//                 ),
//                 // Positioned(
//                 //   bottom: 0,
//                 //   right: 0,
//                 //   child: GestureDetector(
//                 //     onPanStart: (details) =>
//                 //         _panInitOffset = details.globalPosition,
//                 //     // onPanUpdate: _onResize,
//                 //     onPanEnd: (details) {
//                 //       setState(() {
//                 //         _signatureSize = _signaturePreviewSize;
//                 //         _signaturePreviewSize = null;
//                 //       });
//                 //     },
//                 //     child: CircleAvatar(
//                 //       radius: 8,
//                 //       backgroundColor: palette.error,
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           )
//         : Container();
//   }
// }
//
// class _SignatureImage extends StatelessWidget {
//   const _SignatureImage(
//       {Key? key,
//       required this.useMeterai,
//       required this.size,
//       required this.previewSize,
//       this.fullname,
//       this.width,
//       this.height})
//       : super(key: key);
//
//   final bool useMeterai;
//   final Size? size;
//   final Size? previewSize;
//   final String? fullname;
//
//   final int? width;
//   final int? height;
//
//   @override
//   Widget build(BuildContext context) {
//     final palette = Palette.of(context);
//     final textTheme = Theme.of(context).textTheme;
//     var splitName = fullname.toString().split(" ");
//     var lastname = splitName.length > 1 ? splitName[1] : '';
//
//     double heightSize = MediaQuery.of(context).size.height;
//     double widthSize = MediaQuery.of(context).size.width;
//
//     print(splitName);
//
//     return Container(
//         // width: previewSize?.width ?? size?.width,
//         // height: previewSize?.height ?? size?.height,
//         width: useMeterai
//             ? heightSize > 1000
//                 ? 140
//                 : 140
//             : heightSize > 1000
//                 ? 160
//                 : 100,
//         height: 50,
//         decoration: BoxDecoration(border: Border.all(color: palette.error)),
//         margin: const EdgeInsets.all(4.0),
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Container(
//             // width: 100,
//             child: Row(
//               children: [
//                 if (useMeterai)
//                   Icon(
//                     Icons.qr_code_2_rounded,
//                     color: Colors.pink[400],
//                   ),
//                 if (useMeterai)
//                   SizedBox(
//                     width: 5,
//                   ),
//                 SvgPicture.asset(
//                   "assets/icons/qrcode-scan.svg",
//                   width: heightSize > 1000 ? 30 : 18,
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   getTranslated(context, "digital_signed_by").toString() +
//                       ' \n${splitName[0]} ' '${lastname}',
//                   style: TextStyle(
//                     fontSize: heightSize > 1000 ? 12 : 6,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }
