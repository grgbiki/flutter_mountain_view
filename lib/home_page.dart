import 'package:flutter/material.dart';
import 'package:flutter_mountain_view/constants.dart';
import 'package:flutter_mountain_view/models/mountain_model.dart';
import 'package:flutter_mountain_view/mountain_page/mountain_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _infoAnimationController;
  List<MountainModel> _mountains = [
    MountainModel(
      "Everest",
      Colors.blue,
      "assets/images/everest.png",
      "8,849 M",
      "1st",
      "27\u00B059\'17\"N 86\u00B055\'31\"E",
    ),
    MountainModel(
      "K2",
      Colors.blueGrey,
      "assets/images/k2.png",
      "8,611 M",
      "2nd",
      "27\u00B059\'17\"N 86\u00B055\'31\"E",
    ),
    MountainModel(
      "KANGCHENJUNGA",
      Colors.deepPurple,
      "assets/images/mountain.png",
      "8,586 M",
      "3 rd",
      "27\u00B059\'17\"N 86\u00B055\'31\"E",
    ),
    // MountainModel(
    //   "Lhotse",
    //   Colors.pink,
    //   "assets/images/mountain.png",
    //   "8,516 M",
    //   "4 th",
    //   "27\u00B059\'17\"N 86\u00B055\'31\"E",
    // ),
    MountainModel(
      "Mt. Fuji",
      Colors.deepOrange[400],
      "assets/images/fuji.png",
      "3,777 M",
      "35th",
      "27\u00B059\'17\"N 86\u00B055\'31\"E",
    ),
  ];

  int _pageNumber = 0;
  bool _isInfoShowing = false;
  bool _pending = false;

  @override
  void initState() {
    super.initState();

    _infoAnimationController = new AnimationController(
        vsync: this, duration: infoTransitionAnimationDuration);
  }

  toggleInfo() {
    setState(() {
      _isInfoShowing = !_isInfoShowing;
      if (_isInfoShowing)
        _infoAnimationController.forward();
      else
        _infoAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onPanUpdate: (drag) {
            double _sensitivity = 8.0;
            if (!_isInfoShowing) {
              if (!_pending) {
                if (drag.delta.dx > _sensitivity) {
                  previousPage();
                } else if (drag.delta.dx < -_sensitivity) {
                  nextPage();
                }
              }
            }
          },
          child: Container(
            color: _mountains[_pageNumber].backgroundColor,
            child: Stack(
              children: _mountains.reversed
                  .map(
                    (mountain) => MountainPage(
                      animationController: _infoAnimationController,
                      key: mountain.key,
                      mountain: mountain,
                      index: _mountains.indexOf(mountain),
                      pageNumber: _pageNumber,
                      isInfoShowing: _isInfoShowing,
                      toggleInfo: toggleInfo,
                    ),
                  )
                  .toList(),
            ),
          )),
    );
  }

  previousPage() {
    if (_pageNumber > 0) {
      _pending = true;
      Future.delayed(Duration(milliseconds: 400))
          .then((value) => _pending = false);

      setState(() {
        _pageNumber -= 1;
      });
      _mountains[_pageNumber].key.currentState.previousPage(_pageNumber);
      _mountains[_pageNumber + 1].key.currentState.previousPage(_pageNumber);

      if (_pageNumber + 2 < _mountains.length) {
        _mountains[_pageNumber + 2].key.currentState.previousPage(_pageNumber);
        if (_pageNumber + 3 < _mountains.length) {
          _mountains[_pageNumber + 3]
              .key
              .currentState
              .previousPage(_pageNumber);
        }
      }
    }
  }

  nextPage() {
    if (_pageNumber < _mountains.length - 1) {
      _pending = true;
      Future.delayed(Duration(milliseconds: 400))
          .then((value) => _pending = false);

      setState(() {
        _pageNumber += 1;
      });
      _mountains[_pageNumber - 1].key.currentState.nextPage(_pageNumber);
      _mountains[_pageNumber].key.currentState.nextPage(_pageNumber);
      if (_pageNumber + 1 < _mountains.length) {
        _mountains[_pageNumber + 1].key.currentState.nextPage(_pageNumber);
        if (_pageNumber + 2 < _mountains.length) {
          _mountains[_pageNumber + 2].key.currentState.nextPage(_pageNumber);
        }
      }
    }
  }
}
