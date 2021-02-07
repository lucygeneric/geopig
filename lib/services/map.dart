import 'package:geopig/models/site.dart';
import 'package:latlng/latlng.dart';

class MapService {

  // FIXME ENV!!!!
  static String mapboxApiKey = "pk.eyJ1IjoibHVjeWdlbmVyaWMiLCJhIjoiY2l1ZDM5aHZzMDAwcTNvcGd6OTVqaDByZSJ9.jIqofS4akAtXOPn1wKEakQ";

  static String getStaticMapPath(LatLng latlng, Site site, int width, int height){
    String geo = "%7B%22type%22%3A%22FeatureCollection%22%2C%22features%22%3A%5B";
    geo += "${Uri.encodeComponent(site.geojson)}%2C";
    geo += "%7B%22type%22%3A%20%22Feature%22%2C%22properties%22%3A%20%7B%7D%2C%22geometry%22%3A%20%7B%22type%22%3A%20%22Point%22%2C%22coordinates%22%3A%20%5B${latlng.longitude}%2C${latlng.latitude}%5D%7D%7D";
    geo += "%5D%7D";
    return 'https://api.mapbox.com/styles/v1/lucygeneric/ck7c4yvfu009e1is8rafmpgfo/static/' +
      'geojson($geo)/${latlng.longitude},${latlng.latitude},16/${width}x$height?' +
      'access_token=$mapboxApiKey';
  }
}