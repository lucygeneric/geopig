

import 'package:geopig/models/connectors/event.dart';
import 'package:geopig/redux/states/event.dart';
import 'package:geopig/redux/store.dart' as Store;
import 'package:geopig/models/base.dart';
import 'package:uuid/uuid.dart';

var uuid = new Uuid();

enum EventType { SCAN_IN, SCAN_OUT }

class Event implements BaseModel {

  String id;
  EventType type;
  DateTime timestamp;
  EventData data;

  static EventConnector db = EventConnector();

  Event({ this.id, this.type, this.timestamp, this.data });

  static EventState get store => Store.store.state.eventState;

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      type: EventType.values[map['type']],
      timestamp: DateTime.parse(map['timestamp']),
      data: EventData.fromMap(map['data'])
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    "id": id,
    "type": type.index,
    "timestamp": timestamp.toIso8601String(),
    "data": data.toMap()
  };

}

class EventData {

  double latitude;
  double longitude;
  double accuracy;
  int siteId;

  EventData({ this.latitude, this.longitude, this.accuracy, this.siteId });

  factory EventData.fromMap(Map<String, dynamic> map) {
    return EventData(
      latitude: map['latitude'],
      longitude: map['longitude'],
      accuracy: map['accuracy'],
      siteId: map['site_id']
    );
  }

  Map<String, dynamic> toMap() => {
    "latitude": latitude,
    "longitude": longitude,
    "accuracy": accuracy,
    "site_id": siteId
  };

}

