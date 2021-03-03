import 'package:lyrics_track/apiProvider/Modal/all_request.dart';
import 'package:lyrics_track/apiProvider/Modal/all_tracks_data.dart';
import 'package:lyrics_track/apiProvider/all_respose.dart';
import 'package:lyrics_track/apiProvider/app_repository.dart';
import 'package:rxdart/rxdart.dart';

final repository = AppRepository();

class AllTracksBloc extends Object {

  List<TrackList> _trackList;
  List<TrackList> get trackList => _trackList;
  final _trackListSubject = PublishSubject<GetAllTracksResponse>();
  Stream<GetAllTracksResponse> get trackListStream => _trackListSubject.stream;
  Future<void> callTrackListAPI() async {
    GetAllTracksRequest request = GetAllTracksRequest();
    GetAllTracksResponse response = await repository.getAllTracksApi(request);
      this._trackList = response.data.message.body.trackList;
    _trackListSubject.sink.add(response);
  }

  void dispose() {
    _trackListSubject?.close();
    print('------------------- ${this} Dispose ------------------- ');
  }
}