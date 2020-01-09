import 'package:flutter/material.dart';
import 'reapi.dart';
import 'SobreroFeed.dart';
import 'mainview.dart';
import 'voti.dart';
import 'comunicazioni.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  reAPI response;
  SobreroFeed feed;

  HomeScreen(reAPI response, SobreroFeed feed) {
    this.response = response;
    this.feed = feed;
  }

  @override
  State<StatefulWidget> createState() {
    return _HomeState(response, feed);
  }
}

class _HomeState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController pageController = PageController();
  reAPI response;
  SobreroFeed feed;

  _HomeState(reAPI response, SobreroFeed feed) {
    this.response = response;
    this.feed = feed;
  }

  BottomNavigationBarItem barIcon(String title, IconData icon) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      icon: Icon(
        icon,
        color: Theme.of(context).textTheme.body1.color,
      ),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      activeIcon: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  void progChange() {
    print("DIO");
  }

  void onTabTapped(int index) {
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset('assets/images/logo_sobrero_grad.png',
                          scale: 1.1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "mySobrero",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0360e7)),
                      ),
                    ),
                    Spacer(), // use Spacer
                    Transform.scale(
                      scale: 0.8,
                      child: IconButton(
                        icon: new Image.asset(
                          'assets/images/ic_settings_grad.png',
                        ),
                        tooltip: 'Apri le impostazioni dell\'App',
                        iconSize: 14,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                floating: true,
                forceElevated: innerBoxIsScrolled,
              ),
            ];
          },
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: <Widget>[
              Mainview(response, feed, (int page){
                onTabTapped(page);
              }),
              VotiView(response.voti),
              ComunicazioniView(response.comunicazioni),
              Container(
                color: Colors.cyan,
              ),

            ],
          ),
        ),
        /*onTap: onTabTapped,
          currentIndex: _currentIndex,
      */
        /*bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            barIcon("Home", Icons.home),
            barIcon("Voti", Icons.trending_up),
            barIcon("Argomenti", Icons.book),
            barIcon("Comunicazioni", Icons.format_list_bulleted),
            barIcon("Altro", Icons.more_horiz),
          ],
        ));*/
        bottomNavigationBar: CubertoBottomBar(
          inactiveIconColor: Theme.of(context).textTheme.body1.color,
          tabStyle: CubertoTabStyle.STYLE_FADED_BACKGROUND, // By default its CubertoTabStyle.STYLE_NORMAL
          selectedTab: _currentIndex, // By default its 0, Current page which is fetched when a tab is clickd, should be set here so as the change the tabs, and the same can be done if willing to programmatically change the tab.
          tabs: [
            TabData(
              iconData: Icons.home,
              title: "Home",
              tabColor: Theme.of(context).primaryColor,
            ),
            TabData(
              iconData: Icons.trending_up,
              title: "Valutazioni",
              tabColor: Colors.pink,
            ),
            TabData(
              iconData: Icons.format_list_bulleted,
              title: "Comunicazioni",
              tabColor: Colors.amber),
            TabData(
              iconData: Icons.more_horiz,
              title: "Altro",
              tabColor: Colors.teal),
          ],
          onTabChangedListener: (position, title, color) {
            setState(() {
              pageController.animateToPage(position,
                  duration: Duration(milliseconds: 200), curve: Curves.ease);
              setState(() {
                _currentIndex = position;
              });
            });
          },
        ),);
  }
}
