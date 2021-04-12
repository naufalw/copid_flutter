import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class HomeContainerSmall extends StatelessWidget {
  const HomeContainerSmall({
    this.title,
    this.value,
    this.delta,
    Key key,
  }) : super(key: key);

  final title;
  final value;
  final delta;

  Widget getValueText() {
    if (value == null) {
      return SkeletonAnimation(
        shimmerColor: Colors.grey,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 45,
          width: 150,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(18)),
        ),
      );
    } else {
      return AutoSizeText(
        value,
        maxLines: 1,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 45),
      );
    }
  }

  Widget getDeltaText() {
    if (value == null) {
      return SkeletonAnimation(
        shimmerColor: Colors.grey,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 15,
          width: 80,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(18)),
        ),
      );
    } else {
      return AutoSizeText(
        delta,
        maxLines: 1,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 180,
        height: 122,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AutoSizeText(
                title,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.5),
              ),
              getValueText(),
              getDeltaText()
            ],
          ),
        ),
      ),
    );
  }
}
