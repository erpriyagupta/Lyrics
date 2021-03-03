import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lyrics_track/UIUtils/ui_utils.dart';
import 'package:lyrics_track/apiProvider/Modal/all_tracks_data.dart';

class TrackAdapter extends StatelessWidget {
  TrackList trackList;
  TrackAdapter({this.trackList});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: UIUtils().getProportionalHeight(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.library_music,color: Colors.blueGrey,),
              SizedBox(width: UIUtils().getProportionalWidth(20),),
              Container(
                width: UIUtils().getProportionalWidth(180),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this.trackList?.track?.albumName ?? '',maxLines : 1,style: UIUtils().getTextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                    Text(this.trackList?.track?.trackName ?? '',maxLines : 2,style: UIUtils().getTextStyle(fontSize: 12,color: Colors.black54,fontWeight: FontWeight.normal),),
                  ],
                ),
              ),
              Spacer(),
              Container(width: UIUtils().getProportionalWidth(100),child: Text(this.trackList?.track?.artistName ?? '',maxLines: 3,style: UIUtils().getTextStyle(fontSize: 12,color: Colors.black54,fontWeight: FontWeight.normal),)),

            ],
          ),

          Container(color: Colors.black38,height: 1,margin: EdgeInsets.only(top: UIUtils().getProportionalHeight(20)),)
        ],
      ),
    );
  }
}
