import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgService {

  static Future preloadSvg(BuildContext context, String path) async {
    var picture = SvgPicture.asset(path);
    return precachePicture(picture.pictureProvider, context);
  }

  static Future preloadSvgs(BuildContext context, List<String> paths) async {
    List<Future> futures = [];
    for(String path in paths){
      futures.add(preloadSvg(context, path));
    }
    return Future.wait(futures);
  }

}