import 'package:flutter/material.dart';

class GlobalBackground extends StatelessWidget {
  const GlobalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Opacity(
        opacity: 0.6,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.9),
                Theme.of(context).colorScheme.primary.withOpacity(0.5),
                Theme.of(context).colorScheme.surface
              ],
              end: Alignment.topLeft,
              begin: Alignment.bottomRight,
              stops: const [0, 0.0034, 0.34],
            ),
          ),
        ),
      ),
    );
  }
}
