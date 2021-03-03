import 'package:lyrics_track/Bloc/all_tracks_bloc.dart';
import 'package:lyrics_track/apiProvider/Modal/all_request.dart';
import 'package:lyrics_track/apiProvider/Modal/track_details_data.dart';
import 'package:lyrics_track/apiProvider/all_respose.dart';
import 'package:rxdart/subjects.dart';

class TrackDetailsBloc extends Object {

  Lyrics _lyrics;
  Lyrics get lyrics => _lyrics;
  final _trackDetailsSubject = PublishSubject<GetTrackDetailsResponse>();
  Stream<GetTrackDetailsResponse> get trackDetailsStream => _trackDetailsSubject.stream;
  Future<void> callTrackDetailsAPI({int trackID}) async {
    GetTrackDetailsRequest request = GetTrackDetailsRequest();
    request.trackId = trackID;
    GetTrackDetailsResponse response = await repository.getTrackDetailsApi(request);
    this._lyrics = response.data.message.body.lyrics;
    _trackDetailsSubject.sink.add(response);
  }



  void dispose() {
    _trackDetailsSubject?.close();
    print('------------------- ${this} Dispose ------------------- ');
  }


}