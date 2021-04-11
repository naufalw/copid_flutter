import 'package:customizable_space_bar/customizable_space_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          leading: Icon(
            LineIcons.newspaperAlt,
          ),
          flexibleSpace: CustomizableSpaceBar(
            builder: (context, scrollingRate) {
              return Padding(
                padding:
                    EdgeInsets.only(bottom: 13, left: 12 + 40 * scrollingRate),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "News",
                    style: TextStyle(
                        fontSize: 43 - 18 * scrollingRate,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [],
          ),
        )
      ],
    );
  }
}
