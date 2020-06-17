// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:mySobrero/common/expandedsection.dart';
import 'package:mySobrero/common/skeleton.dart';
import 'package:mySobrero/common/utilities.dart';

Widget CounterTile ({@required double aspectRatio, EdgeInsets padding, int flex, @required Function onTap, Color highColor, Color lowColor, Color textColor, String primaryText, String secondaryText, bool showImage = false, String imagePath}) {
  return Expanded(
    flex: flex,
    child: GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: 1,
        child: Padding(
          padding: padding,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              decoration: new BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: lowColor.withOpacity(0.4),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  gradient: LinearGradient(
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomRight,
                    colors: <Color>[
                      highColor, lowColor
                    ],
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showImage ? Image.asset(imagePath) : Text(
                      primaryText,
                      style: new TextStyle(
                          fontSize: 65,
                          color: textColor
                      ),
                    ),
                    AutoSizeText(
                      secondaryText,
                      style: new TextStyle(
                          color: textColor,
                          fontSize: 14
                      ),
                      maxLines: 2,
                      minFontSize: 7,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget DetailTile ({@required double aspectRatio, EdgeInsets padding, int flex, @required Function onTap, Color highColor, Color lowColor, Widget body}) {
  return Expanded(
    flex: flex,
    child: GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: new BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: lowColor.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(11)),
                gradient: LinearGradient(
                  begin: FractionalOffset.topRight,
                  end: FractionalOffset.bottomRight,
                  colors: <Color>[
                    highColor, lowColor
                  ],
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: body,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget NewsTile({BuildContext context, bool safeLeft = false, bool safeRight = false, String leadingImageUrl, String title, StatefulWidget detailView}) {
  return SafeArea(
    bottom: false,
    left: safeLeft,
    right: safeRight,
    top: false,
    child: Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 10,
                  spreadRadius: 5
              )
            ]
        ),
        width: 300,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: OpenContainer(
                closedColor: Theme.of(context).scaffoldBackgroundColor,
                openColor: Theme.of(context).scaffoldBackgroundColor,
                closedBuilder: (c, action) => Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: leadingImageUrl,
                        placeholder: (context, url) => Skeleton(),
                        errorWidget: (context, url, error) => Container(
                            color: Theme.of(context).textTheme.bodyText1.color.withAlpha(40),
                            width: 300,
                            child: Center(child: Icon(Icons.broken_image, size: 70))
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black87, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15,30,15,25),
                        child: Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                openBuilder: (c, action) => detailView,
                tappable: true
            )
        ),
      ),
    ),
  );
}

Widget UnconstrainedToggleTile({BuildContext context, Color highColor, Color lowColor, Widget body, EdgeInsets padding, bool openTile}){
  return Padding(
    padding: padding,
    child: Container(
      decoration: new BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: lowColor.withOpacity(0.4),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(11)),
          gradient: LinearGradient(
            begin: FractionalOffset.topRight,
            end: FractionalOffset.bottomRight,
            colors: <Color>[
              highColor, lowColor
            ],
          )
      ),
      child: ExpandedSection(
        expand: openTile,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: body,
        ),
      ),
    ),
  );
}

Widget ImageLinkTile({BuildContext context, Color highColor, Color lowColor, bool isWide, String title, String imageUrl, String body, String detailsText, String detailsUrl}){
  return SafeArea(
    top: false,
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Container(
        //height: isWide ? 200 : null,
        decoration: new BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: lowColor.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.4 : 0),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
            borderRadius: BorderRadius.all(Radius.circular(11)),
            gradient: LinearGradient(
              begin: FractionalOffset.topRight,
              end: FractionalOffset.bottomRight,
              colors: <Color>[
                highColor,
                lowColor
              ],
            )),
        child: isWide ? IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(11)),
                child: Container(
                  width: 300,
                  color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) => Skeleton(),
                          errorWidget: (context, url, error) => Container(
                              color: Theme.of(context).textTheme.body1.color.withAlpha(40),
                              height: 200,
                              child: Center(child: Icon(Icons.broken_image, size: 70, color: Colors.white,))
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          title,
                          style: new TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF)),
                        ),
                      ),
                      Text(
                        body,
                        style: new TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Text(detailsText, style: TextStyle(color: Colors.white),),
                            Icon(Icons.arrow_forward_ios, color: Colors.white,)
                          ],
                        ),
                        onPressed: () => openURL(context, detailsUrl),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(11)),
              child: Container(
                width: isWide ? 300 : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 200,
                      placeholder: (context, url) => Skeleton(),
                      errorWidget: (context, url, error) =>
                          Container(
                              color: Theme.of(context).textTheme.body1.color.withAlpha(40),
                              height: 200,
                              child: Center(child: Icon(Icons.broken_image, size: 70, color: Colors.white,))
                          ),
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Text(
                      title,
                      style: new TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  Text(
                    body,
                    style: new TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  FlatButton(
                    child: Row(
                      children: <Widget>[
                        Text(detailsText, style: TextStyle(color: Colors.white),),
                        Icon(Icons.arrow_forward_ios, color: Colors.white,)
                      ],
                    ),
                    onPressed: () => openURL(context, detailsUrl),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class IllustrationTile extends StatelessWidget{
  IllustrationTile({
    Key key,
    @required this.builder,
    @required this.tag,
    @required this.title,
    @required this.image,
    this.color = const Color(0xFFFF0000)
  }) :  assert(builder != null),
        assert(color != null),
        assert(title != null),
        assert(image != null),
        super(key: key);

  /// Route builder passed to the Navigator when the [IllustrationTile] is
  /// tapped
  final Function(BuildContext) builder;

  /// Background color of the tile
  final Color color;

  /// Hero tag for [IllustrationTile] to animate the tile body during
  /// Navigator.push transition
  final String tag;

  /// The title for [IllustrationTile]
  final String title;

  /// Relative path to the leading image of the [IllustrationTile]
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: builder,
          fullscreenDialog: true,
        ),
      ),
      child: Hero(
        tag: tag,
        child: Container(
          height: 150,
          width: double.infinity,
          //margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.4),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            clipBehavior: Clip.antiAlias,
            // TODO: rimuovere ingradimento immagine durante hero
            // TODO: provare le nuove animazioni con tiles
            // TODO: implementare colore automatico testo
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  alignment: Alignment.centerRight,
                  fit: BoxFit.contain,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color.computeLuminance() > 0.45 ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          )
        )
      ),
    );
  }
}

class GenericTile extends StatelessWidget{
  GenericTile({
    Key key,
    @required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.stretch
  }) :  assert(crossAxisAlignment != null),
        assert(children != null),
        super(key: key);

  CrossAxisAlignment crossAxisAlignment;
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            ...children,
          ],
        ),
      ),
    );
  }
}
