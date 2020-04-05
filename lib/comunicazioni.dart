import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
//import 'reapi2.dart';
import 'package:url_launcher/url_launcher.dart';


class ComunicazioniView extends StatefulWidget {
  List<ComunicazioneStructure> comunicazioni;
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;

  ComunicazioniView({Key key, @required this.unifiedLoginStructure, @required this.apiInstance}) {
    this.comunicazioni = unifiedLoginStructure.comunicazioni;
  }

  @override
  _ComunicazioniView createState() => _ComunicazioniView();
}

class _ComunicazioniView extends State<ComunicazioniView> with AutomaticKeepAliveClientMixin<ComunicazioniView>{
  @override
  bool get wantKeepAlive => true;

  _ComunicazioniView(){}

  _launchURL(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }


  List<Widget> generaAllegati(List<AllegatoStructure> allegati){
    List<Widget> list = new List<Widget>();
    for (int i = 0; i<allegati.length; i++){
      list.add(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0,3)
            )
          ]
        ),
        child: ActionChip(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            _launchURL(allegati[i].url);
          },
          avatar: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(Icons.attach_file, color: Colors.white, size: 20),
          ),
          label: Text(allegati[i].nome, style: TextStyle(color: Colors.white),),
        ),
      ));
    }
    return list;
  }

  Widget _generaComunicazione(ComunicazioneStructure comunicazione){
    String realDestinatario = "Dirigente";
    if (comunicazione.mittente.toUpperCase() != "DIRIGENTE") realDestinatario = "Gianni Rossi";
    return Container(
        decoration: new BoxDecoration(
            //color: Theme.of(context).textTheme.body1.color.withAlpha(20),
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            //border: Border.all(width: 0.0, color: Color(0xFFCCCCCC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withAlpha(12),
              blurRadius: 10,
              spreadRadius: 10
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(50),
                                blurRadius: 10,
                                spreadRadius: 4,
                                offset: Offset(0, 2)
                            )
                          ]
                      ),
                      child: comunicazione.mittente.toUpperCase() == "DIRIGENTE" ?
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/rota.png"),
                        radius: 15,
                      ) :
                      CircleAvatar(
                        child: Text("GR", style: TextStyle(color: Colors.white)),
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(toBeginningOfSentenceCase(realDestinatario), style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Spacer(),
                    Text(comunicazione.data)
                  ],
                ),
              ),
              Wrap(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                      toBeginningOfSentenceCase(comunicazione.titolo),
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(comunicazione.contenuto,
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: generaAllegati(comunicazione.allegati)
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 900 ? 3 : columnCount;
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
                    'Tutte le comunicazioni',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                WaterfallFlow.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: widget.comunicazioni.length,
                  itemBuilder: (context, i){
                    return _generaComunicazione(widget.comunicazioni[i]);
                  },
                  gridDelegate: SliverWaterfallFlowDelegate(
                    crossAxisCount: columnCount,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    lastChildLayoutTypeBuilder: (index) => index == widget.comunicazioni.length
                        ? LastChildLayoutType.foot
                        : LastChildLayoutType.none,
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
        ));
  }
}
