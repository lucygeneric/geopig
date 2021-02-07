import 'package:geopig/models/site.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/base_action.dart';
import 'package:geopig/redux/states/site.dart';

class AddSite extends BaseAction {

  final Site site;

  AddSite({ this.site }) : assert(site != null);

  @override
  Future<AppState> reduce() async {

    List<Site> sites = List.of(state.siteState.sites);

    // Make sure it doesn't exist in the store already.
    if(sites.firstWhere((e) => e.id == site.id, orElse: () => null) == null) {
      await Site.db.insert(site);
      sites.insert(0, site);
    }

    Site.db.replace(sites);

    return state.copy(siteState: SiteState(sites: sites));

  }
}