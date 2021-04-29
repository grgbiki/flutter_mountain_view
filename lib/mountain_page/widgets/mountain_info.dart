import 'package:flutter/material.dart';
import 'package:flutter_mountain_view/constants.dart';

class MountainInfo extends StatefulWidget {
  final AnimationController animationController;
  final String height;
  final String rank;
  final String coordinates;
  final bool isCurrent;
  MountainInfo({
    Key key,
    @required this.animationController,
    this.height,
    this.rank,
    this.coordinates,
    this.isCurrent,
  }) : super(key: key);

  @override
  MountainInfoState createState() => MountainInfoState();
}

class MountainInfoState extends State<MountainInfo> {
  Animation<Offset> _infoSlideAnimation;

  Tween<Offset> _slideTween;
  @override
  void initState() {
    super.initState();

    _slideTween = Tween<Offset>(
      begin: Offset(widget.isCurrent ? 0.0 : 0.2, 0.0),
      end: Offset(widget.isCurrent ? -0.2 : 0.0, 0),
    );

    _infoSlideAnimation = _slideTween.animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.linear,
    ));
  }

  updatePreviousAnimation(isPrevious, _isCurrent) {
    setState(() {
      _slideTween.begin = Offset(_isCurrent ? -0.2 : 0.0, 0.0);
      _slideTween.end = Offset(
          _isCurrent
              ? 0.0
              : isPrevious
                  ? 0.2
                  : 1.0,
          0.0);
    });
  }

  updateNextAnimation(isPrevious, _isCurrent) {
    setState(() {
      _slideTween.begin = Offset(isPrevious ? 0.0 : 0.2, 0.0);
      _slideTween.end = Offset(
          isPrevious
              ? -0.2
              : _isCurrent
                  ? 0.0
                  : 0.2,
          0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _infoSlideAnimation,
      child: AnimatedOpacity(
        duration: pageTransitionAnimationDuration,
        opacity: widget.isCurrent ? 1 : 0,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Elevation",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(200),
                ),
              ),
              Text(
                "${widget.height} / Ranked ${widget.rank}",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Coordinates",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(255),
                ),
              ),
              Text(
                widget.coordinates,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
