import 'package:geopig/models/site.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/base_action.dart';
import 'package:geopig/redux/states/site.dart';

class AddSite extends BaseAction {

  final String name;
  final String address;
  final String geojson;

  AddSite({ this.name, this.address, this.geojson }) : assert(name != null);

  @override
  Future<AppState> reduce() async {

    Site site = Site(name: name, address: address, geojson: geojson);

    List<Site> sites = List.of(state.siteState.sites);

    // Make sure it doesn't exist in the store already.
    if(sites.firstWhere((e) => e.name == site.name, orElse: () => null) == null) {
      sites.insert(0, site);
    }

    await Site.db.upsert(site);
    Site.db.replace(sites);

    return state.copy(siteState: SiteState(sites: sites));

  }
}