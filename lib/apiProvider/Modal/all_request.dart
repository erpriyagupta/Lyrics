class GetAllTracksRequest {
  int apikey;
  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['apikey'] = "2d782bc7a52a41ba2fc1ef05b9cf40d7";
    return data;
  }
}

class GetTrackDetailsRequest {
  String apikey;
  int trackId;
  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['apikey'] = "2d782bc7a52a41ba2fc1ef05b9cf40d7";
    data['track_id'] = trackId.toString();
    return data;
  }
}
