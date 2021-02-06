import 'package:geopig/models/event.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/base_action.dart';
import 'package:geopig/redux/states/event.dart';

class AddEvent extends BaseAction {

  final Event event;

  AddEvent({ this.event }) : assert(event != null);

  @override
  Future<AppState> reduce() async {

    List<Event> events = List.of(state.eventState.events);

    events.insert(0, event);

    await Event.db.upsert(event);
    Event.db.replace(events);

    return state.copy(eventState: EventState(events: events));

  }
}