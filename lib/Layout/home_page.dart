import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyrics_track/Bloc/all_tracks_bloc.dart';
import 'package:lyrics_track/Layout/track_adapter.dart';
import 'package:lyrics_track/Layout/track_details_page.dart';
import 'package:lyrics_track/UIUtils/after_layout.dart';
import 'package:lyrics_track/UIUtils/pull_to_refresh_list_view.dart';
import 'package:lyrics_track/UIUtils/reachability.dart';
import 'package:lyrics_track/UIUtils/ui_utils.dart';
import 'package:lyrics_track/apiProvider/all_respose.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  StreamSubscription<GetAllTracksResponse> _allTracksStreamSubscription;
  AllTracksBloc _bloc = AllTracksBloc();



  @override
  void initState() {
    super.initState();
    //region Listen for All Tracks
    _allTracksStreamSubscription = this._bloc.trackListStream.listen((response) async {
      await UIUtils.dismissProgressDialog(_key.currentContext);
      setState(() {});
    });
    //endregion
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(microseconds: 500), () {
      this._getAllTracksData();
    });
  }


  @override
  void dispose() {
    super.dispose();
    _allTracksStreamSubscription?.cancel();
    this._bloc.dispose();

  }


  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    UIUtils().updateScreenDimension(height: deviceSize.height, width: deviceSize.width);


    return Scaffold(
      key: _key,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Trending",style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: PullToRefreshListView(
          itemCount: this._bloc.trackList?.length ?? 0,
          padding: EdgeInsets.all(UIUtils().getProportionalWidth(20)),
          onRefresh: _onRefresh,
          builder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrackDetailsPage(trackList: this._bloc.trackList[index],))),
              child: TrackAdapter(trackList: this._bloc.trackList[index],),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _getAllTracksData();
  }


  _getAllTracksData() {
    if (!UIUtils.isInternetAvailable(_key)) {
      UIUtils.showSnackBar(_key, "NO INTERNET AVAILABLE");
      return;
    } else {
      UIUtils.showSnackBar(_key, "INTERNET AVAILABLE");
    }
    UIUtils.showProgressDialog(_key.currentContext);
    this._bloc.callTrackListAPI();
  }


}
