import 'package:flutter/material.dart';

/// author: febriarianto1195@gmail.com
/// date: 2022-04-23
extension on String {
  String toWordCase() {
    if (isEmpty) return this;
    final prefix = substring(0,1);
    return prefix.toUpperCase() + substring(1);
  }
}
class FruitListItemWidget extends StatelessWidget {
  final String name;
  final String price;
  final Function() onTap;

  const FruitListItemWidget({
    Key? key,
    required this.name,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name.toWordCase(),
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
