import 'package:flutter/foundation.dart';
import 'package:geopig/models/event.dart';

class EventState {
  List<Event> get events => Event.db.items;

  EventState({ List<Event> events }) {
    if(events != null) {
      Event.db.replace(events);
    }
  }

  EventState copy({Event event}) {
    return EventState(events: events ?? this.events);
  }

  static EventState initialState() => EventState(events: const []);

  Future persist() async {
    await Event.db.upsertMany(events);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is EventState &&
      runtimeType == other.runtimeType &&
      listEquals(events, other.events);
  }

  @override
  int get hashCode => events.hashCode;
}
