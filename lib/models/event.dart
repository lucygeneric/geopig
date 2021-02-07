

import 'dart:convert';

import 'package:geopig/models/connectors/event.dart';
import 'package:geopig/models/site.dart';
import 'package:geopig/redux/states/event.dart';
import 'package:geopig/redux/store.dart' as Store;
import 'package:geopig/models/base.dart';
import 'package:geopig/redux/store.dart';
import 'package:latlng/latlng.dart';
import 'package:uuid/uuid.dart';

var uuid = new Uuid();

enum EventType { SCAN_IN, SCAN_OUT, SCAN_MISSING }

class Event implements BaseModel {

  String id;
  EventType type;
  DateTime timestamp;
  EventData data;

  static EventConnector db = EventConnector();

  Event({ this.id, this.type, this.timestamp, this.data });

  static EventState get store => Store.store.state.eventState;

  LatLng get latLng => LatLng(data.latitude, data.longitude);
  String get typeAsString => type == EventType.SCAN_IN ? "Scan In" : "Scan Out";
  Site   get site => data.site;

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? uuid.v4(),
      type: EventType.values[int.parse(map['type'])],
      timestamp: DateTime.parse(map['timestamp']),
      data: EventData.fromMap(json.decode(map['data']))
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    "id": id,
    "type": type.index,
    "timestamp": timestamp.toIso8601String(),
    "data": json.encode(data.toMap())
  };

}

class EventData {

  double latitude;
  double longitude;
  double accuracy;
  String siteId;

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

  Site get site => store.state.siteState.sites.firstWhere((element) => element.id == siteId, orElse: () => null);

}

