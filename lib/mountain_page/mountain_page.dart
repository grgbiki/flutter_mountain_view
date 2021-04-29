import 'package:flutter/material.dart';
import 'package:flutter_mountain_view/constants.dart';
import 'package:flutter_mountain_view/models/mountain_model.dart';
import 'package:flutter_mountain_view/mountain_page/widgets/mountain_image.dart';
import 'package:flutter_mountain_view/mountain_page/widgets/mountain_info.dart';
import 'package:flutter_mountain_view/mountain_page/widgets/mountain_info_button.dart';
import 'package:flutter_mountain_view/mountain_page/widgets/mountain_info_container.dart';
import 'package:flutter_mountain_view/mountain_page/widgets/mountain_title.dart';

class MountainPage extends StatefulWidget {
  final AnimationController animationController;
  final MountainModel mountain;
  final int index;
  final int pageNumber;
  final bool isInfoShowing;
  final Function toggleInfo;
  MountainPage(
      {Key key,
      @required this.animationController,
      @required this.mountain,
      this.index,
      this.pageNumber,
      this.isInfoShowing,
      @required this.toggleInfo})
      : super(key: key);

  @override
  MountainPageState createState() => MountainPageState();
}

class MountainPageState extends State<MountainPage>
    with TickerProviderStateMixin {
  GlobalKey<MountainTitleState> _titleKey = new GlobalKey();
  GlobalKey<MountainInfoContainerState> _infoContainerKey = new GlobalKey();
  GlobalKey<MountainInfoState> _infoKey = new GlobalKey();
  GlobalKey<MountainInfoButtonState> _infoButtonKey = new GlobalKey();
  GlobalKey<MountainImageState> _imageKey = new GlobalKey();

  AnimationController _pageTransitionController;

  Animation _imageSlideAnimation;

  Tween<Offset> _imageSlideTween;

  bool _isPrevious = false;
  bool _isCurrent = false;
  bool _isNext = false;
  bool _isUpcomming = false;

  @override
  void initState() {
    super.initState();
    checkPage(widget.pageNumber);

    _pageTransitionController = new AnimationController(
        vsync: this, duration: pageTransitionAnimationDuration);

    updateSlideTween(_isCurrent);
    _imageSlideAnimation = _imageSlideTween.animate(CurvedAnimation(
        parent: widget.animationController, curve: Curves.linear));
  }

  updateSlideTween(isCurrent) {
    setState(() {
      _imageSlideTween = Tween<Offset>(
          begin: Offset.zero, end: Offset(0.0, isCurrent ? 0.7 : 1.0));
    });
  }

  previousPage(pageNumber) async {
    checkPage(pageNumber);

    widget.animationController.reset();
    updateSlideTween(_isCurrent);
    _infoContainerKey.currentState.updateTween(_isCurrent);

    bool isPrevious = pageNumber == widget.index;
    bool isCurrent = pageNumber + 1 == widget.index;
    bool isNext = pageNumber + 2 == widget.index;
    bool isUpcomming = pageNumber + 3 == widget.index;

    _pageTransitionController.reset();
    if (!isNext && !isUpcomming) {
      _titleKey.currentState.updatePreviousAnimation(_isNext, _isCurrent);
      _infoKey.currentState.updatePreviousAnimation(_isNext, _isCurrent);
      _infoButtonKey.currentState.updatePreviousAnimation(_isNext, _isCurrent);
    }

    _imageKey.currentState
        .updatePreviousAnimation(isPrevious, isCurrent, isNext, isUpcomming);

    _pageTransitionController.forward();
  }

  nextPage(pageNumber) async {
    checkPage(pageNumber);

    widget.animationController.reset();
    updateSlideTween(_isCurrent);
    _infoContainerKey.currentState.updateTween(_isCurrent);

    _pageTransitionController.reset();
    if (!_isNext && !_isUpcomming) {
      _titleKey.currentState.updateNextAnimation(_isPrevious, _isCurrent);
      _infoKey.currentState.updateNextAnimation(_isPrevious, _isCurrent);
      _infoButtonKey.currentState.updateNextAnimation(_isPrevious, _isCurrent);
    }

    _imageKey.currentState
        .updateNextAnimation(_isPrevious, _isCurrent, _isNext, _isUpcomming);

    _pageTransitionController.forward();
  }

  checkPage(pageNumber) {
    setState(() {
      _isPrevious = widget.index == pageNumber - 1;
      _isCurrent = widget.index == pageNumber;
      _isNext = widget.index == pageNumber + 1;
      _isUpcomming = widget.index == pageNumber + 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _imageSlideAnimation,
              child: Container(
                height: size.height * 0.7,
                child: MountainImage(
                  key: _imageKey,
                  animationController: _pageTransitionController,
                  isCurrent: _isCurrent,
                  isNext: _isNext,
                  isUpcomming: _isUpcomming,
                  imagePath: widget.mountain.assetPath,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: size.height * 0.3,
              padding: EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: MountainTitle(
                        key: _titleKey,
                        animationController: _pageTransitionController,
                        title: widget.mountain.name,
                        isCurrent: _isCurrent,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: MountainInfoContainer(
                        key: _infoContainerKey,
                        infoKey: _infoKey,
                        infoButtonKey: _infoButtonKey,
                        animationController: _pageTransitionController,
                        infoAnimationController: widget.animationController,
                        height: widget.mountain.height,
                        rank: widget.mountain.rank,
                        coordinates: widget.mountain.coordinates,
                        isCurrent: _isCurrent,
                        isInfoShowing: widget.isInfoShowing,
                        toggleInfo: widget.toggleInfo,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
