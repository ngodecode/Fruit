import 'package:flutter/material.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23

class FruitPreviewWidget extends StatelessWidget {
  final String imageUrl;

  const FruitPreviewWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                  size: 32,
                ),
              )
            ],
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Image.network(
              imageUrl,
              loadingBuilder: (context, widget, chunk) {
                if (chunk?.expectedTotalBytes == chunk?.cumulativeBytesLoaded) {
                  return widget;
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, object, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.sd_card_alert_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
