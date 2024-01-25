import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotFoundComponent extends StatelessWidget {
  final String title;
  const NotFoundComponent({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/back_home.svg',
            fit: BoxFit.contain,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
