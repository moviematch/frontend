import 'package:app/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'queue_driver.dart';
import 'LoadIndicator.dart';
import 'QueueItemCard.dart';
import 'package:openapi/api.dart';

class RecommendationSwiper extends StatelessWidget {
  final GlobalKey<SwipeStackState> _swipeKey = GlobalKey<SwipeStackState>();

  final void Function(Room room) updateRoom;

  RecommendationSwiper({@required this.updateRoom});

  @override
  Widget build(BuildContext context) {
    double availableHeight = MediaQuery.of(context).size.height -
        Scaffold.of(context).appBarMaxHeight;

    return SizedBox.expand(
        child: Stack(children: [
      Positioned(
          left: 0,
          top: 0,
          width: MediaQuery.of(context).size.width,
          height: availableHeight,
          child: SwipeStack(
              key: _swipeKey,
              children: [1, 0]
                  .map((index) => SwiperItem(
                          builder: (SwiperPosition pos, double progress) {
                        return Material(
                            elevation: 20,
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: Colors.white,
                            child: Builder(builder: (context) {
                              if (index > 0) {
                                return Container(); // display nothing on back cards
                              } else {
                                return FutureBuilder(
                                    future: QueueDriver()
                                        .getFront(updateRoom: updateRoom),
                                    builder: (context, future) {
                                      if (future.connectionState !=
                                              ConnectionState.done ||
                                          future.data == null) {
                                        return LoadIndicator(colours: [Green]);
                                      } else {
                                        return QueueItemCard(
                                            item: future.data,
                                            swipePos: pos == SwiperPosition.Left
                                                ? -progress
                                                : progress,
                                            swipe: (bool left) => left
                                                ? _swipeKey.currentState
                                                    .swipeLeft()
                                                : _swipeKey.currentState
                                                    .swipeRight());
                                      }
                                    });
                              }
                            }));
                      }))
                  .toList(),
              scaleInterval: 0.05,
              historyCount: 1,
              padding: EdgeInsets.all(12),
              onSwipe: (int index, SwiperPosition position) {
                QueueDriver().swipe(position == SwiperPosition.Right);
                _swipeKey.currentState.rewind();
              })),
      /*Positioned(
        bottom: 0,
        width: MediaQuery.of(context).size.width,
        height: 92,
        child: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 12, left: 12, right: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Button('No',
                  press: () => _swipeKey.currentState.swipeLeft(),
                  color: Colors.green,
                  textColor: Colors.black),
              SizedBox(width: 12),
              Button('Yes',
                  press: () => _swipeKey.currentState.swipeRight(),
                  color: Colors.green,
                  textColor: Colors.black),
            ])),
      ),*/
    ]));
  }
}
