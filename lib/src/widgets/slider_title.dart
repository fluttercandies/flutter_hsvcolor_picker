import 'package:flutter/material.dart';

class SliderTitle extends StatelessWidget {
  const SliderTitle(
    this.title,
    this.text, {
    Key? key,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(left: 10.0),
            child: Opacity(
              opacity: 0.7,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontSize: 18,
                    ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(right: 10.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontSize: 18,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
