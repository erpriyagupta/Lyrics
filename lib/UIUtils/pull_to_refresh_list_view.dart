import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Widget ListBuilderCallBack(BuildContext context, int index);

class PullToRefreshListView extends StatefulWidget {
  final int itemCount;
  final VoidCallback onRefresh;
  final ScrollPhysics physics;
  final ListBuilderCallBack builder;
  final EdgeInsets padding;
  final ScrollController controller;

  PullToRefreshListView(
      {this.itemCount,
      this.padding = const EdgeInsets.only(bottom: 5.0),
      this.controller,
      this.builder,
      this.onRefresh,
      this.physics});

  @override
  _PullToRefreshListViewState createState() => _PullToRefreshListViewState();
}

class _PullToRefreshListViewState extends State<PullToRefreshListView> {

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      final silverlistChildDelegate = SliverChildBuilderDelegate(
        this.widget.builder,
        childCount: this.widget.itemCount,
      );

      final scollView = CustomScrollView(
        controller: this.widget.controller,
        physics: this.widget.physics,
        slivers: <Widget>[

          CupertinoSliverRefreshControl(
            onRefresh: this.widget.onRefresh,
            refreshIndicatorExtent: 50.0,
            refreshTriggerPullDistance: 100.0,
          ),

          SliverPadding(
            padding: this.widget.padding,
            sliver: SliverSafeArea(
                bottom: true,
                top:false,
                sliver: SliverList(
              delegate: silverlistChildDelegate,
            )),
          ),

        ],
      );
      return scollView;
    } else {
      final listView = ListView.builder(
        physics: this.widget.physics,
        padding: this.widget.padding,
        scrollDirection: Axis.vertical,
        itemCount: this.widget.itemCount,
        itemBuilder: this.widget.builder,
        controller: this.widget.controller,
      );

      final refreshIndicator = RefreshIndicator(child: listView, onRefresh: this.widget.onRefresh);

      final listViewPullToRefresh = Container(
        child: refreshIndicator,
        alignment: Alignment.center,
      );

      return listViewPullToRefresh;
    }
  }
}
