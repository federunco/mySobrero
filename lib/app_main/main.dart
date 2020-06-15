import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:mySobrero/altro.dart';
import 'package:mySobrero/app_main/sobrero_appbar.dart';
import 'package:mySobrero/comunicazioni.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/custom_icons_icons.dart';
import 'package:mySobrero/app_main/home.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/app_main/votes.dart';
import 'package:mySobrero/app_main/sobrero_appbar.dart';
import 'package:mySobrero/voti.dart';

class AppMain extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  SobreroFeed feed;
  String profileUrl;
  bool isBeta = false;

  AppMain({
    Key key,
    @required this.unifiedLoginStructure,
    @required this.feed,
    @required this.profileUrl,
    @required this.isBeta,
    @required this.apiInstance}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  String _profileUrl;
  double _globalScroll = 0;

  int _scrollThreshold = 100;

  HomePage _homePageInstance;
  VotiView _votiViewInstance;
  VotesPage _votesPageInstance;
  ComunicazioniView _comunicazioniViewInstance;
  AltroView _altroViewInstance;

  PageController pageController = PageController();

  void switchPage(bool needToSwitch, int page){
    if (needToSwitch){
      pageController.animateToPage(
          page,
          duration: Duration(milliseconds: 200), curve: Curves.ease
      );
    }
    setState(() {
      _globalScroll = 0;
      _currentPageIndex = page;
    });
  }

  Future<bool> _handleBackButton() async {
    if (_currentPageIndex != 0) {
      switchPage(true, 0);
      return false;
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  void _updateProfilePicture(String url) {
    setState(() {
      _profileUrl = url;
    });
  }

  @override
  void initState(){
    super.initState();
    _profileUrl = widget.profileUrl;
    print(_profileUrl);
    _homePageInstance = HomePage(
        unifiedLoginStructure: widget.unifiedLoginStructure,
        apiInstance: widget.apiInstance,
        feed: widget.feed,
        callback: (page) => switchPage(true, page),
    );
    _votesPageInstance = VotesPage(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
    _comunicazioniViewInstance = ComunicazioniView(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
    _altroViewInstance = AltroView(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
  }

  bool elaboraScroll(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      double oldScroll = _globalScroll;
      _globalScroll = scrollNotification.metrics.pixels;
      if (_globalScroll < 0)
        _globalScroll = 0;
      else if (_globalScroll > _scrollThreshold)
        _globalScroll = 1;
      else
        _globalScroll /= _scrollThreshold;
      if (oldScroll - _globalScroll != 0) setState(() {});
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Theme.of(context).brightness
        ),
        child: Scaffold(
          appBar: SobreroAppBar(
              context: context,
              isBeta: widget.isBeta,
              profilePicUrl: _profileUrl,
              scroll: _globalScroll,
              loginStructure: widget.unifiedLoginStructure,
              setProfileCallback: _updateProfilePicture
          ),
          body: PageView.builder(
            controller: pageController,
            onPageChanged: (index) => switchPage(false, index),
            itemCount: 4,
            itemBuilder: (context, i) {
              var schermata;
              if (i == 0) schermata = _homePageInstance;
              if (i == 1) schermata = _votesPageInstance;
              if (i == 2) schermata = _comunicazioniViewInstance;
              if (i == 3) schermata = _altroViewInstance;
              return NotificationListener<ScrollNotification>(
                onNotification: elaboraScroll,
                child: schermata,
              );
            },
          ),
          bottomNavigationBar: Container(
            decoration:
            BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 10,
                spreadRadius: 10,
              )
            ]),
            child: SafeArea(
              bottom: true,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: GNav(
                    gap: 8,
                    color: Theme.of(context).disabledColor,
                    activeColor: Theme.of(context).primaryColor,
                    iconSize: 24,
                    tabBackgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    duration: Duration(milliseconds: 300),
                    tabs: [
                      GButton(
                        icon: Icons.home,
                        text: 'Home',
                      ),
                      GButton(
                        icon: CustomIcons.chart,
                        text: 'Voti',
                      ),
                      GButton(
                        icon: Icons.list,
                        text: 'Comunicazioni',
                      ),
                      GButton(
                        icon: CustomIcons.dot,
                        text: 'Altro',
                      )
                    ],
                    selectedIndex: _currentPageIndex,
                    onTabChange: (index) => switchPage(true, index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}