import 'package:flutter/material.dart';
import 'package:mySobrero/carriera.dart';
import 'package:mySobrero/pagelle.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/ricercaaule.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
//import 'reapi2.dart';
import 'assenze.dart';
import 'argomenti.dart';
import 'materiale.dart';

class AltroView extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;

  AltroView({Key key, @required this.unifiedLoginStructure, @required this.apiInstance}) : super(key: key);

  @override
  _AltroView createState() => _AltroView();
}

class _AltroView extends State<AltroView> with AutomaticKeepAliveClientMixin<AltroView>{
  @override
  bool get wantKeepAlive => true;

  Widget _generaTile({@required Function(BuildContext) builder, @required String heroTag, @required String titolo, @required String immagine, @required Color sfondo, @required Color dettagli}){
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: builder,
                fullscreenDialog: true
            )
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          decoration: new BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: sfondo.withOpacity(0.4),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
              margin: EdgeInsets.only(bottom: 10),
              clipBehavior: Clip.antiAlias,
              color: sfondo,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(titolo,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: dettagli)),
                  ),
                  Spacer(),
                  Image.asset(
                    immagine,
                    height: 150,
                  )
                ],
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    return SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Altro',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                WaterfallFlow.count(
                  primary: false,
                  shrinkWrap: true,
                  crossAxisCount: columnCount,
                  children: <Widget>[
                    /*
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MaterialeView(reMateriale: response.materiale, userID: response.session,),
                              fullscreenDialog: true
                          ),
                        );
                      },
                      child: Hero(
                        tag: "materiale_background",
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xffe55039).withOpacity(0.4),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(bottom: 10),
                              clipBehavior: Clip.antiAlias,
                              color: Color(0xffe55039),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text("Materiale didattico",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/images/material.png",
                                    height: 150,
                                    width: 150,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RicercaAuleView(),
                            fullscreenDialog: true
                          ),
                        );
                      },
                      child: Hero(
                        tag: "ricercaaule_background",
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xffF86925).withOpacity(0.2),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(bottom: 10),
                              clipBehavior: Clip.antiAlias,
                              color: Color(0xffF86925),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text("Ricerca aule",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/images/ricercaaule.png",
                                    height: 150,
                                    width: 170,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PagelleView(response.pagelle),
                              fullscreenDialog: true
                          ),
                        );
                      },
                      child: Hero(
                        tag: "pagelle_background",
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xff38ada9).withOpacity(0.4),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(bottom: 10),
                              clipBehavior: Clip.antiAlias,
                              color: Color(0xff38ada9),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text("Pagelle",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/images/pagelle.png",
                                    height: 150,
                                    fit: BoxFit.fitWidth,
                                    width: 200,
                                  )
                                ],
                              )),
                        ),
                      ),
                    )*/
                    _generaTile(
                        builder: (_) => AssenzeView(apiInstance: widget.apiInstance),
                        heroTag: "assenze_background",
                        titolo: "Assenze",
                        immagine: "assets/images/assenze.png",
                        sfondo: Color(0xffff9692),
                        dettagli: Colors.black
                    ),
                    _generaTile(
                        builder: (_) => ArgomentiView(apiInstance: widget.apiInstance),
                        heroTag: "argomenti_background",
                        titolo: "Argomenti",
                        immagine: "assets/images/argomenti.png",
                        sfondo: Color(0xFF5352ed),
                        dettagli: Colors.white
                    ),
                    _generaTile(
                        builder: (_) => RicercaAuleView(),
                        heroTag: "ricercaaule_background",
                        titolo: "Ricerca aule",
                        immagine: "assets/images/ricercaaule.png",
                        sfondo: Color(0xffF86925),
                        dettagli: Colors.white
                    ),
                    _generaTile(
                        builder: (_) => CarrieraView(unifiedLoginStructure: widget.unifiedLoginStructure),
                        heroTag: "carriera_background",
                        titolo: "Carriera scolastica",
                        immagine: "assets/images/carriera.png",
                        sfondo: Color(0xff45BF6D),
                        dettagli: Colors.white
                    )
                  ],
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                )

              ],
            ),
          ),
      ],
    ),
        ));
  }
}
