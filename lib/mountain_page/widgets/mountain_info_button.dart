import 'package:flutter/material.dart';

class MountainInfoButton extends StatefulWidget {
  final AnimationController animationController;
  final bool isCurrent;
  final Function toggleInfo;
  final bool isInfoShowing;
  MountainInfoButton({
    Key key,
    @required this.animationController,
    this.isCurrent,
    @required this.toggleInfo,
    this.isInfoShowing,
  }) : super(key: key);

  @override
  MountainInfoButtonState createState() => MountainInfoButtonState();
}

class MountainInfoButtonState extends State<MountainInfoButton> {
  Animation<Offset> _buttonSlideAnimation;

  Tween<Offset> _slideTween;

  @override
  void initState() {
    super.initState();

    _slideTween = Tween<Offset>(
      begin: Offset(widget.isCurrent ? 0.0 : 1.0, 0.0),
      end: Offset(1.0, 0.0),
    );

    _buttonSlideAnimation = _slideTween.animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        widget.isCurrent ? 0 : 0.5,
        widget.isCurrent ? 0.5 : 1.0,
        curve: Curves.linear,
      ),
    ));
  }

  updatePreviousAnimation(isPrevious, _isCurrent) {
    setState(() {
      _slideTween.begin = Offset(_isCurrent ? 1 : 0.0, 0.0);
      _slideTween.end = Offset(_isCurrent ? 0.0 : 1.0, 0.0);

      _buttonSlideAnimation = _slideTween.animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          _isCurrent ? 0.5 : 0.0,
          _isCurrent ? 1.0 : 0.5,
          curve: Curves.linear,
        ),
      ));
    });
  }

  updateNextAnimation(_isPrevious, _isCurrent) {
    setState(() {
      _slideTween.begin = Offset(_isPrevious ? 0.0 : 1.0, 0.0);
      _slideTween.end = Offset(
          _isPrevious
              ? 1
              : _isCurrent
                  ? 0.0
                  : 1.0,
          0.0);

      _buttonSlideAnimation = _slideTween.animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          _isPrevious ? 0 : 0.5,
          _isPrevious ? 0.5 : 1.0,
          curve: Curves.linear,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _buttonSlideAnimation,
      child: InkWell(
        onTap: () {
          if (!widget.isInfoShowing) widget.toggleInfo();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          color: Colors.white.withAlpha(40),
          child: IntrinsicWidth(
            child: Row(
              children: [
                Text(
                  "Information".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.double_arrow_rounded,
                  size: 18,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
