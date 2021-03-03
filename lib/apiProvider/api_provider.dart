import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:lyrics_track/apiProvider/Modal/all_request.dart';
import 'package:lyrics_track/apiProvider/Modal/all_tracks_data.dart';
import 'package:lyrics_track/apiProvider/Modal/track_details_data.dart';
import 'all_respose.dart';
import 'api_constant.dart';

class HttpResponse {
  int status;
  String errMessage;
  dynamic json;
  bool failDueToToken;

  HttpResponse(
      {this.status, this.errMessage, this.json, this.failDueToToken = false});
}

class ResponseKeys {
  static String kMessage = 'message';
  static String kStatus = 'status';
  static String kId = 'id';
  static String kData = 'body';
}

class ApiProvider {
  CancelToken lastRequestToken;

  factory ApiProvider() {
    return _singleton;
  }

  final Dio dio = new Dio();
  static final ApiProvider _singleton = ApiProvider._internal();

  ApiProvider._internal() {
    print("Instance created ApiProvider");
    // Setting up connection and response time out
    dio.options.connectTimeout = 60 * 1000;
    dio.options.receiveTimeout = 60 * 1000;
  }


  Future<HttpResponse> _handleDioNetworkError({DioError error, ApiType apiType}) async {
    print("Error Details :: ${error.message}");

    if ((error.response == null) || (error.response.data == null)) {
      String errMessage =
          'spmething went wrong';
      return HttpResponse(status: 500, errMessage: errMessage, json: null);
    } else {
      print("Error Details :: ${error.response.data}");
      dynamic jsonResponse = error.response.data;
      if (jsonResponse is Map) {
        final status = jsonResponse[ResponseKeys.kStatus] ?? 400;

        if (status == 401 || error.response.statusCode == 401) {
          String errMessage = jsonResponse["message"] ??
             'SomethingWrong';
          return HttpResponse(
              status: status, errMessage: errMessage, json: null);
        } else {
          String errMessage = jsonResponse["message"] ??
              'SomethingWrong';
          return HttpResponse(
              status: status, errMessage: errMessage, json: null);
        }
      } else {
        if (error.response.statusCode == 401) {
        }
        return HttpResponse(
            status: 500,
            errMessage: 'SomethingWrong',
            json: null
        );
      }
    }
  }

  //region Get All Tracks API
  Future<GetAllTracksResponse> getAllTracksApi(GetAllTracksRequest params) async {

    final requestFinal = ApiConstant.requestParamsForSync(ApiType.getAllTracks, params: params.toJson());
    final option = Options(headers: requestFinal.item2);
    try {
      final response = await this.dio.get(requestFinal.item1, queryParameters: requestFinal.item3, options: option);
      print("URL ======= ${requestFinal.item1}");
      print("PARAMS ======= ${requestFinal.item3}");
      print(response);
      return GetAllTracksResponse(status: 200, message: "  ", data: AllTracks.fromJson(jsonDecode(response.data)));

    } on DioError catch (error) {
      final response = await this.dio.get(requestFinal.item1, queryParameters: requestFinal.item3, options: option);
      print("URL ======= ${requestFinal.item1}");
      print("PARAMS ======= ${requestFinal.item3}");
      print(response);
      final result =
      await this._handleDioNetworkError(error: error, apiType: ApiType.getAllTracks);
      if (result.failDueToToken ?? false) {
        return GetAllTracksResponse(status: 200, message: "  ", data: AllTracks.fromJson(jsonDecode(response.data)));
      }
      return GetAllTracksResponse(status: 200, message: "  ", data: AllTracks.fromJson(jsonDecode(response.data)));
    }
  }
  //endregion

  //region Get Track Details API
  Future<GetTrackDetailsResponse> getTrackDetailsApi(GetTrackDetailsRequest params) async {

    final requestFinal = ApiConstant.requestParamsForSync(ApiType.trackDetails, params: params.toJson());
    final option = Options(headers: requestFinal.item2);
    try {
      final response = await this.dio.get(requestFinal.item1, queryParameters: requestFinal.item3, options: option);
      print("URL ======= ${requestFinal.item1}");
      print("PARAMS ======= ${requestFinal.item3}");
      print(response);
      return GetTrackDetailsResponse(status: 200, message: "  ", data: TrackDetails.fromJson(jsonDecode(response.data)));

    } on DioError catch (error) {
      final response = await this.dio.get(requestFinal.item1, queryParameters: requestFinal.item3, options: option);
      print("URL ======= ${requestFinal.item1}");
      print("PARAMS ======= ${requestFinal.item3}");
      print(response);
      final result =
      await this._handleDioNetworkError(error: error, apiType: ApiType.trackDetails);
      if (result.failDueToToken ?? false) {
        return GetTrackDetailsResponse(status: 200, message: "  ", data: TrackDetails.fromJson(jsonDecode(response.data)));
      }
      return GetTrackDetailsResponse(status: 200, message: "  ", data: TrackDetails.fromJson(jsonDecode(response.data)));
    }
  }
  //endregion


}


