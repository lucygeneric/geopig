
import 'package:geopig/models/event.dart';
import 'package:geopig/models/site.dart';
import 'package:geopig/redux/actions/event.dart';
import 'package:geopig/redux/actions/site.dart';
import 'package:geopig/redux/states/scan.dart';
import 'package:geopig/redux/store.dart';
import 'package:geopig/services/location.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class ScanService  {

  /// picks apart the scan data, upserts site and generates event
  static decodeScan(Map<String, dynamic> scan) async {
    try {
      // decode site / upsert
      Site site = store.state.siteState.sites.firstWhere((site) => site.id == scan["data"]["id"], orElse: () => null);
      if (site == null)
        site = Site.fromMap(ScanService.siteMapFromScan(scan));
      await store.dispatchFuture(AddSite(site: site));

      // pinpoint scan location
      dynamic result = await LocationService.currentLocation;

      if (result is LocationData){
        EventType type = store.state.scanState.state == ScanFlowState.SCANNED_IN ? EventType.SCAN_OUT : EventType.SCAN_IN;
        Event event = Event(id: Uuid().v4(), timestamp: DateTime.now(), type: type, data: EventData(
          latitude: result.latitude,
          longitude: result.longitude,
          accuracy: result.accuracy,
          siteId: site.id
        ));
        // upsert event
        await store.dispatchFuture(AddEvent(event: event));
        return []; // returns empty errors yay
      } else {
        return result;
      }
    } catch (e) {
      return [e];
    }
  }

  static siteMapFromScan(Map<String, dynamic> scan){
    return {
      "id": scan["data"]["id"],
      "name": scan["data"]["name"],
      "address": scan["data"]["address"],
      "geojson": "{\"type\":\"Feature\",\"properties\": {\"stroke\": \"#019ade\",\"stroke-width\": 2,\"stroke-opacity\": 1,\"fill\": \"#019ade\",\"fill-opacity\": 0.5},\"geometry\":{\"type\":\"Polygon\",\"coordinates\": ${scan['data']['coordinates']}}}"
    };
  }

}