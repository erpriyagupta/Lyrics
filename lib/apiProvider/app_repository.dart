
import 'package:lyrics_track/apiProvider/Modal/all_request.dart';
import 'package:lyrics_track/apiProvider/all_respose.dart';

import 'api_provider.dart';

class AppRepository {
  final apiProvider = ApiProvider();


  Future<GetAllTracksResponse> getAllTracksApi(GetAllTracksRequest params) => apiProvider.getAllTracksApi(params);

  Future<GetTrackDetailsResponse> getTrackDetailsApi(GetTrackDetailsRequest params) => apiProvider.getTrackDetailsApi(params);


}
