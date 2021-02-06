import 'package:latlng/latlng.dart';

class MapService {

  // FIXME ENV!!!!
  static String mapboxApiKey = "pk.eyJ1IjoibHVjeWdlbmVyaWMiLCJhIjoiY2l1ZDM5aHZzMDAwcTNvcGd6OTVqaDByZSJ9.jIqofS4akAtXOPn1wKEakQ";

  static getStaticMap(LatLng latlng){
    return 'https://api.mapbox.com/styles/v1/lucygeneric/ck7c4yvfu009e1is8rafmpgfo/static/' +
      'geojson(%7B%22type%22%3A%22Point%22%2C%22coordinates%22%3A%5B${latlng.longitude}%2C${latlng.latitude}%5D%7D)/${latlng.longitude},${latlng.latitude},16/500x300?' +
      'access_token=$mapboxApiKey';
  }
}