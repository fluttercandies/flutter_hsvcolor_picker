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
    return SizedBox(
      height: 34.0,
      child: Row(
        children: <Widget>[
          Opacity(
            opacity: 0.7,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 18),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
