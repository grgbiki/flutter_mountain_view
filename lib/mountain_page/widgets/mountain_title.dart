import 'package:flutter/material.dart';
import 'package:flutter_mountain_view/constants.dart';

class MountainTitle extends StatefulWidget {
  final AnimationController animationController;
  final String title;
  final bool isCurrent;
  MountainTitle({
    Key key,
    @required this.animationController,
    @required this.title,
    this.isCurrent,
  }) : super(key: key);

  @override
  MountainTitleState createState() => MountainTitleState();
}

class MountainTitleState extends State<MountainTitle> {
  Animation<Offset> _titleSlideAnimation;
  Animation<double> _titleScaleAnimation;

  Tween<Offset> _slideTween;
  Tween<double> _scaleTween;

  @override
  void initState() {
    super.initState();

    _slideTween = Tween<Offset>(
      begin: Offset(widget.isCurrent ? 0.0 : 0.2, 0.0),
      end: Offset(widget.isCurrent ? -1.2 : 0.0, 0.0),
    );
    _scaleTween = Tween<double>(
      begin: widget.isCurrent ? 1.0 : 0.6,
      end: widget.isCurrent ? 1.4 : 1.0,
    );

    _titleSlideAnimation = _slideTween.animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.linear,
    ));
    _titleScaleAnimation = _scaleTween.animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.linear,
    ));
  }

  updatePreviousAnimation(isPrevious, _isCurrent) {
    setState(() {
      _scaleTween.begin = _isCurrent ? 1.4 : 1.0;
      _scaleTween.end = _isCurrent
          ? 1.0
          : isPrevious
              ? 0.6
              : 0.6;

      _slideTween.begin = Offset(_isCurrent ? -1.2 : 0.0, 0.0);
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
      _scaleTween.begin = isPrevious ? 1 : 0.6;
      _scaleTween.end = isPrevious
          ? 1.4
          : _isCurrent
              ? 1.0
              : 0.6;

      _slideTween.begin = Offset(isPrevious ? 0.0 : 0.2, 0.0);
      _slideTween.end = Offset(
          isPrevious
              ? -1.2
              : _isCurrent
                  ? 0.0
                  : 0.2,
          0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _titleSlideAnimation,
      child: ScaleTransition(
        scale: _titleScaleAnimation,
        child: AnimatedOpacity(
          duration: pageTransitionAnimationDuration,
          opacity: widget.isCurrent ? 1 : 0,
          child: Container(
            child: Text(
              widget.title.toUpperCase(),
              maxLines: widget.title.length < 8 ? 2 : 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: widget.title.length < 10 ? 80 : 60,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
