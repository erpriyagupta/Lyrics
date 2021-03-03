import 'dart:io';

import 'package:tuple/tuple.dart';

enum ApiType {
  getAllTracks,
  trackDetails,
}
class PreferenceKey {
  static String storeUser = "LmmUser";
  static String currentFilter = "LmmFilter";
}

class ApiConstant {

  static String get baseDomain => 'https://api.musixmatch.com/ws/1.1/';

  // static String get apiVersion => 'v1';

  static String getValue(ApiType type) {
    switch (type) {
      case ApiType.getAllTracks:
        return 'chart.tracks.get';
      case ApiType.trackDetails:
        return 'track.lyrics.get';

      default:
        return "";
    }
  }
  static Tuple4<String, Map<String, String>, Map<String, dynamic>,
      List<AppMultiPartFile>> requestParamsForSync(ApiType type,
      {Map<String, dynamic> params, List<AppMultiPartFile> arrFile = const [],
        String urlParams}) {
    String apiUrl = ApiConstant.baseDomain +
        // ApiConstant.apiVersion +
        ApiConstant.getValue(type);

    if (urlParams != null) apiUrl = apiUrl + urlParams;

    Map<String, dynamic> paramsFinal = params ?? Map<String, dynamic>();

    Map<String, String> headers = Map<String, String>();
    if (type == ApiType.getAllTracks) {
      headers['language'] = 'en';
    }
    return Tuple4(apiUrl, headers, paramsFinal, arrFile);
  }
}
class AppMultiPartFile {
  List<File> localFiles;
  String key;

  AppMultiPartFile({this.localFiles, this.key});
}