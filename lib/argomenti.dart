import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reapi.dart';
import 'fade_slide_transition.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';


class ArgomentiView extends StatefulWidget {
  List<Regclasse> regclasse;
  ArgomentiView(List<Regclasse> regclasse) {
    this.regclasse = regclasse;
  }

  @override
  _ArgomentiState createState() => _ArgomentiState(regclasse);
}

class _ArgomentiState extends State<ArgomentiView> with SingleTickerProviderStateMixin {
  List<Regclasse> regclasse;

  Brightness currentBrightness;

  _ArgomentiState(List<Regclasse> regclasse) {
    this.regclasse = regclasse;
  }

  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    _fadeSlideAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _appBarElevation =
          _scrollController.offset > _scrollController.initialScrollOffset
              ? 4.0
              : 0.0;
          _appBarTitleOpacity = _scrollController.offset >
              _scrollController.initialScrollOffset +
                  _preferredAppBarHeight / 2
              ? 1.0
              : 0.0;
        });
      });
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    if (currentBrightness == Brightness.light) FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentBrightness = Theme.of(context).brightness;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: "argomenti_background",
            child: Container(
              color: Color(0xFF5352ed),
            ),
          ),
          SafeArea(
            child: Column(children: <Widget>[
              FadeSlideTransition(
                controller: _fadeSlideAnimationController,
                slideAnimationTween: Tween<Offset>(
                  begin: Offset(0.0, 0.5),
                  end: Offset(0.0, 0.0),
                ),
                begin: 0.0,
                end: _listAnimationIntervalStart,
                child: PreferredSize(
                  preferredSize: Size.fromHeight(_preferredAppBarHeight),
                  child: AppBar(
                    title: AnimatedOpacity(
                      opacity: _appBarTitleOpacity,
                      duration: const Duration(milliseconds: 250),
                      child: Text("Argomenti", style: TextStyle(color: Colors.white)),
                    ),
                    backgroundColor: Color(0xFF5352ed),
                    elevation: _appBarElevation,
                    brightness: Brightness.dark,
                    leading: BackButton(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      20,
                    ),
                    child: Column(
                      children: <Widget>[
                        FadeSlideTransition(
                          controller: _fadeSlideAnimationController,
                          slideAnimationTween: Tween<Offset>(
                            begin: Offset(0.0, 0.5),
                            end: Offset(0.0, 0.0),
                          ),
                          begin: 0.0,
                          end: _listAnimationIntervalStart,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Argomenti",
                                style:
                                Theme.of(context).textTheme.title.copyWith(
                                  fontSize: 32.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FadeSlideTransition(
                          controller: _fadeSlideAnimationController,
                          slideAnimationTween: Tween<Offset>(
                            begin: Offset(0.0, 0.005),
                            end: Offset(0.0, 0.0),
                          ),
                          begin: _listAnimationIntervalStart - 0.15,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: generaGiornate(context)
                              )

                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  List<Widget> generaArgomenti(List<Argomento> argomenti, BuildContext context) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < argomenti.length; i++){
      list.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
                decoration: new BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1.0, color: Color(0xFFCCCCCC))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: <Widget>[
                      Text(
                          argomenti[i].materia,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                      ),
                      Text(
                          argomenti[i].descrizione,
                          style: TextStyle(fontSize: 16, color: Colors.white)
                      )
                    ],
                  ),
                )
            ),
          )
      );
    }
    return list;
  }

  List<Widget> generaGiornate(BuildContext context) {
    initializeDateFormatting('it');
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < regclasse.length; i++) {
      LineSplitter l = new LineSplitter();
      DateFormat format = new DateFormat("DD/MM/yyyy");
      var parsedDate = format.parse(l.convert(regclasse[i].data)[0]);
      String formattedDate = DateFormat('DD MMMM', 'it').format(parsedDate);
      list.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              formattedDate,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white),
            ),
          )
      );
      list += generaArgomenti(regclasse[i].argomenti, context);
    }
    return list;
  }
}