import 'package:customizable_space_bar/customizable_space_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          leading: Icon(
            LineIcons.alternateMapMarker,
          ),
          actions: [
            GestureDetector(
              child: Icon(LineIcons.searchLocation),
            ),
            GestureDetector(child: Icon(LineIcons.mapPin))
          ],
          flexibleSpace: CustomizableSpaceBar(
            builder: (context, scrollingRate) {
              return Padding(
                padding:
                    EdgeInsets.only(bottom: 13, left: 12 + 40 * scrollingRate),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Indonesia",
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
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeContainerSmall(),
                  HomeContainerSmall(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeContainerSmall(),
                  HomeContainerSmall(),
                ],
              ),
              HomeContainerLarge(),
              HomeContainerLarge(),
            ],
          ),
        )
      ],
    );
  }
}

class HomeContainerLarge extends StatelessWidget {
  const HomeContainerLarge({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Container(
        width: 382,
        height: 180,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

class HomeContainerSmall extends StatelessWidget {
  const HomeContainerSmall({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 179,
        height: 122,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
