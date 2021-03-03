import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lyrics_track/Bloc/track_details_bloc.dart';
import 'package:lyrics_track/UIUtils/after_layout.dart';
import 'package:lyrics_track/UIUtils/ui_utils.dart';
import 'package:lyrics_track/apiProvider/Modal/all_tracks_data.dart';
import 'package:lyrics_track/apiProvider/all_respose.dart';

class TrackDetailsPage extends StatefulWidget {

  TrackList trackList;
  TrackDetailsPage({this.trackList});

  @override
  _TrackDetailsPageState createState() => _TrackDetailsPageState();
}

class _TrackDetailsPageState extends State<TrackDetailsPage> with AfterLayoutMixin<TrackDetailsPage> {

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  StreamSubscription<GetTrackDetailsResponse> _trackDetailsStreamSubscription;
  TrackDetailsBloc _bloc = TrackDetailsBloc();

  @override
  void initState() {
    super.initState();
    //region Listen for Track Details
    _trackDetailsStreamSubscription = this._bloc.trackDetailsStream.listen((response) async {
      await UIUtils.dismissProgressDialog(_key.currentContext);
      setState(() {});
    });
    //endregion

  }

  @override
  void dispose() {
    super.dispose();
    this._trackDetailsStreamSubscription?.cancel();
    this._bloc.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(microseconds: 500), () {
      this._getTrackDetailsData();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_outlined,color: Colors.black,),
        ),
        title: Text("Track Details",style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(UIUtils().getProportionalWidth(20)),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name",style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
              Text(widget.trackList?.track?.trackName ?? '',maxLines: 1 ,style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 17),),
              SizedBox(height: UIUtils().getProportionalHeight(10),),
              Text("Artist",style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
              Text(widget.trackList?.track?.artistName ?? '',maxLines: 1 ,style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 17),),
              SizedBox(height: UIUtils().getProportionalHeight(10),),
              Text("Album Name",style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
              Text(widget.trackList?.track?.albumName ?? '',maxLines: 1 ,style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 17),),
              SizedBox(height: UIUtils().getProportionalHeight(10),),
              Text("Explicit",style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
              Text(widget.trackList?.track?.explicitStatus.toString() ?? '',maxLines: 1 ,style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 17),),
              SizedBox(height: UIUtils().getProportionalHeight(10),),
              Text("Rating",style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
              Text(widget.trackList?.track?.trackRating.toString() ?? '',maxLines: 1 ,style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 17),),
              SizedBox(height: UIUtils().getProportionalHeight(10),),
              Visibility(visible: (this._bloc.lyrics?.lyricsBody ?? '') != "" ,child: Text("Lyrics",style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)),
              Visibility(visible: (this._bloc.lyrics?.lyricsBody ?? '') != "" ,child: Text(this._bloc.lyrics?.lyricsBody ?? '',style: UIUtils().getTextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 17),)),

            ],
          ),
        ),
      ),
    );
  }

  _getTrackDetailsData() {
    if (!UIUtils.isInternetAvailable(_key)) {
      UIUtils.showSnackBar(_key, "NO INTERNET AVAILABLE");
      return;
    } else {
      UIUtils.showSnackBar(_key, "INTERNET AVAILABLE");
    }
    UIUtils.showProgressDialog(_key.currentContext);
    this._bloc.callTrackDetailsAPI(trackID: widget.trackList?.track?.trackId);
  }
}
