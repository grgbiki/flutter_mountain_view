import 'package:flutter/material.dart';
import 'package:flutter_mountain_view/constants.dart';
import 'package:flutter_mountain_view/mountain_page/widgets/mountain_info.dart';
import 'package:flutter_mountain_view/mountain_page/widgets/mountain_info_button.dart';

class MountainInfoContainer extends StatefulWidget {
  final GlobalKey<MountainInfoState> infoKey;
  final GlobalKey<MountainInfoButtonState> infoButtonKey;
  final AnimationController animationController;
  final AnimationController infoAnimationController;
  final String height;
  final String rank;
  final String coordinates;
  final bool isCurrent;
  final bool isNext;
  final bool isInfoShowing;
  final Function toggleInfo;
  MountainInfoContainer({
    Key key,
    @required this.infoKey,
    @required this.infoButtonKey,
    @required this.animationController,
    @required this.infoAnimationController,
    this.height,
    this.rank,
    this.coordinates,
    this.isCurrent,
    this.isNext,
    this.isInfoShowing,
    @required this.toggleInfo,
  }) : super(key: key);

  @override
  MountainInfoContainerState createState() => MountainInfoContainerState();
}

class MountainInfoContainerState extends State<MountainInfoContainer> {
  Animation _infoSlideAnimation;

  Tween<Offset> _buttonSlideTween;

  @override
  void initState() {
    super.initState();

    updateTween(widget.isCurrent);
    _infoSlideAnimation = _buttonSlideTween.animate(CurvedAnimation(
        parent: widget.infoAnimationController, curve: Curves.linear));
  }

  updateTween(_isCurrent) {
    setState(() {
      _buttonSlideTween = Tween(
          begin: Offset(0.0, 0.0), end: Offset(_isCurrent ? 1.0 : 0.0, 0.0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            opacity: widget.isCurrent && widget.isInfoShowing ? 1 : 0,
            duration: infoTransitionAnimationDuration,
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  if (widget.isInfoShowing) widget.toggleInfo();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15, right: 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SlideTransition(
            position: _infoSlideAnimation,
            child: Column(
              children: [
                MountainInfo(
                  animationController: widget.animationController,
                  key: widget.infoKey,
                  height: widget.height,
                  rank: widget.rank,
                  coordinates: widget.coordinates,
                  isCurrent: widget.isCurrent,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: MountainInfoButton(
                    key: widget.infoButtonKey,
                    animationController: widget.animationController,
                    isCurrent: widget.isCurrent,
                    toggleInfo: widget.toggleInfo,
                    isInfoShowing: widget.isInfoShowing,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
