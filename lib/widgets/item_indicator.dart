import 'package:flutter/material.dart';

class ItemIndicator extends StatelessWidget {
  final IconData icon;
  final String title;

  const ItemIndicator({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}