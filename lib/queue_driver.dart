import 'package:app/Ads.dart';

import 'api.dart';
import 'package:openapi/api.dart';

class QueueDriver {
  static QueueDriver _instance = QueueDriver._internal();
  final int _adFrequency = 10; // show ads every x swipes

  QueueDriver._internal();

  factory QueueDriver() {
    return _instance;
  }

  Future<QueueItem> _front;
  QueueItem _frontItem;
  String _acceptId;
  int _swipeCounter = 0;

  /// Call to reset the queue, for example when leaving the room
  void reset() => _front = _frontItem = _acceptId = null;

  /// Call when swiping to move on to the next item
  void swipe(bool accepted) {
    if (_frontItem == null) {
      return; // swiped right before the next element was loaded and displayed
    }
    _acceptId = null;
    if (accepted) {
      if (_frontItem.recommendation != null) {
        _acceptId = _frontItem.recommendation.id;
      }
    }
    _front = _frontItem = null;
    ++_swipeCounter;
    if (_swipeCounter % _adFrequency == 0) {
      Ads().interstitial();
    }
  }

  /// Retuns the current item at the front of the queue
  Future<QueueItem> getFront({void Function(Room room) updateRoom}) {
    if (_front != null) return _front;
    return _front = Api.I().ready().then((_) async {
      if (_acceptId != null) {
        await Api.attempt(Api.I().queue.acceptQueue(_acceptId));
        _acceptId = null;
      }
      return Api.attempt(Api.I().queue.getQueue());
    }).then((item) {
      if (updateRoom != null && item != null && item.room != null) {
        updateRoom(item.room);
      }
      return _frontItem = item as QueueItem;
    });
  }
}
