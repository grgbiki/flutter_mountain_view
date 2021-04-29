import 'package:flutter/material.dart';
import 'package:flutter_mountain_view/constants.dart';

class MountainImage extends StatefulWidget {
  final AnimationController animationController;
  final bool isCurrent;
  final bool isNext;
  final bool isUpcomming;
  final String imagePath;
  MountainImage({
    Key key,
    @required this.animationController,
    @required this.imagePath,
    this.isCurrent,
    this.isNext,
    this.isUpcomming,
  }) : super(key: key);

  @override
  MountainImageState createState() => MountainImageState();
}

class MountainImageState extends State<MountainImage> {
  Animation<Offset> _imageSlideAnimation;

  Tween<Offset> _slideTween;

  @override
  void initState() {
    super.initState();

    _slideTween = Tween<Offset>(
      begin: Offset(
          widget.isCurrent
              ? 0.0
              : widget.isNext
                  ? 0.4
                  : widget.isUpcomming
                      ? 0.6
                      : 1.0,
          widget.isCurrent
              ? 0.0
              : widget.isNext
                  ? 0.1
                  : widget.isUpcomming
                      ? 0.17
                      : 1.0),
      end: Offset.zero,
    );

    _imageSlideAnimation = _slideTween.animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        widget.isCurrent ? 0.2 : 0.0,
        widget.isCurrent ? 1.0 : 0.7,
        curve: Curves.linear,
      ),
    ));
  }

  updatePreviousAnimation(_isPrevious, _isCurrent, _isNext, _isUpcomming) {
    setState(() {
      _slideTween.begin = Offset(
          _isPrevious
              ? -0.5
              : _isCurrent
                  ? 0.0
                  : _isNext
                      ? 0.35
                      : _isUpcomming
                          ? 0.55
                          : 1.0,
          _isPrevious
              ? 0.0
              : _isCurrent
                  ? 0.0
                  : _isNext
                      ? 0.1
                      : _isUpcomming
                          ? 0.17
                          : 0.2);
      _slideTween.end = Offset(
          _isPrevious
              ? 0.0
              : _isCurrent
                  ? 0.35
                  : _isNext
                      ? 0.55
                      : 1.0,
          _isPrevious
              ? 0.0
              : _isCurrent
                  ? 0.1
                  : _isNext
                      ? 0.17
                      : 0.2);

      _imageSlideAnimation = _slideTween.animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          _isPrevious ? 0.0 : 0.0,
          _isPrevious ? 0.6 : 1.0,
          curve: Curves.easeIn,
        ),
      ));
    });
  }

  updateNextAnimation(_isPrevious, _isCurrent, _isNext, _isUpcomming) {
    setState(() {
      _slideTween.begin = Offset(
          _isPrevious
              ? 0.0
              : _isCurrent
                  ? 0.35
                  : _isNext
                      ? 0.55
                      : 1.0,
          _isPrevious
              ? 0.0
              : _isCurrent
                  ? 0.1
                  : 0.17);
      _slideTween.end = Offset(
          _isPrevious
              ? -0.5
              : _isCurrent
                  ? 0.0
                  : _isNext
                      ? 0.35
                      : _isUpcomming
                          ? 0.55
                          : 0.0,
          _isPrevious
              ? 0.0
              : _isCurrent
                  ? 0.0
                  : _isNext
                      ? 0.1
                      : 0.17);

      _imageSlideAnimation = _slideTween.animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          _isPrevious ? 0.0 : 0.0,
          _isPrevious ? 1.0 : 0.6,
          curve: Curves.easeIn,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedOpacity(
        duration: pageTransitionAnimationDuration,
        opacity: widget.isCurrent
            ? 1
            : widget.isNext
                ? 0.5
                : widget.isUpcomming
                    ? 0.2
                    : 0,
        child: SlideTransition(
          position: _imageSlideAnimation,
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
