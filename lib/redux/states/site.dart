import 'package:flutter/foundation.dart';
import 'package:geopig/models/site.dart';

class SiteState {
  List<Site> get sites => Site.db.items;

  SiteState({ List<Site> sites }) {
    if(sites != null) {
      Site.db.replace(sites);
    }
  }

  SiteState copy({List<Site> sites}) {
    return SiteState(sites: sites ?? this.sites);
  }

  static SiteState initialState() => SiteState(sites: const []);

  Future persist() async {
    await Site.db.upsertMany(sites);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is SiteState &&
      runtimeType == other.runtimeType &&
      listEquals(sites, other.sites);
  }

  @override
  int get hashCode => sites.hashCode;
}
