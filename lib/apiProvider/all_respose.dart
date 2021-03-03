
import 'package:lyrics_track/apiProvider/Modal/all_tracks_data.dart';
import 'package:lyrics_track/apiProvider/Modal/track_details_data.dart';

class GetAllTracksResponse {
  int status;
  String message;
  AllTracks data;
  GetAllTracksResponse({this.data,this.status, this.message});

}

class GetTrackDetailsResponse {
  int status;
  String message;
  TrackDetails data;
  GetTrackDetailsResponse({this.data,this.status, this.message});

}