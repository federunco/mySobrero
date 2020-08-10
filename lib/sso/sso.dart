// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/cloud_connector/cloud2.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/localization/localization.dart';

import 'package:mySobrero/sso/authentication_qr.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/dialogs.dart';
import 'package:mySobrero/ui/toggle.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SSOProvider extends StatefulWidget {
  String session;
  SSOProvider ({
    @required this.session
  });

  @override
  _SSOProviderState createState() => _SSOProviderState();
}

class _SSOProviderState extends State<SSOProvider> {

  QRViewController controller;

  void authorizeApp(String data){
    AuthenticationQR _req;
    controller.pauseCamera();
    try {
      var json = jsonDecode(data);
      _req = AuthenticationQR.fromJson(json);
      showDialog(
        context: context,
        builder: (context) => SobreroDialogAbort(
          headingWidget: Icon(
            LineIcons.unlock_alt,
            size: 40,
            color: Colors.green,
          ),
          title: AppLocalizations.of(context).translate("askAuthorize"),
          okButtonText: AppLocalizations.of(context).translate("authorize"),
          abortButtonText: AppLocalizations.of(context).translate("deny"),
          okButtonCallback: () {
            CloudConnector.authorizeApp(
              guid: _req.session,
              token: widget.session,
            );
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) => SobreroDialogSingle(
                headingWidget: Icon(
                  LineIcons.check,
                  size: 40,
                  color: Colors.green,
                ),
                title: AppLocalizations.of(context).translate("ssoAuthorized"),
                buttonText: "Ok",
                buttonCallback: () {
                  Navigator.of(context).pop();
                  controller.resumeCamera();
                },
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        AppLocalizations.of(context).translate("ssoSuccess"),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          abortButtonCallback: () {
            Navigator.of(context).pop();
            controller.resumeCamera();
          },
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Manrope',
                    ),
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .translate("ssoDialog1"),
                      ),
                      TextSpan(
                          text: _req.domain,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .translate("ssoDialog2"),
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context)
                              .translate("ipAddress"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextSpan(
                        text: _req.clientIp,
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context)
                              .translate("location"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.asset(
                            'icons/flags/png/${_req.clientCountry.toLowerCase()}.png',
                            package: 'country_icons',
                            height: 15,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: _req.clientCity,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  AppLocalizations.of(context).translate("ssoSharedData"),
                ),
              )
            ],
          ),
        ),
      );
    } on FormatException catch (e){
      showDialog(
        context: context,
        builder: (context) => SobreroDialogSingle(
          headingWidget: Icon(
            LineIcons.qrcode,
            size: 40,
            color: Colors.red,
          ),
          title: AppLocalizations.of(context).translate("ssoNotAuthorized"),
          buttonText: "Ok",
          buttonCallback: () => Navigator.of(context).pop(),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  AppLocalizations.of(context).translate("ssoInvalidRequest"),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  int _currentPage = 0;

  Widget scanView() => Column(
    key: ValueKey<int>(10),
    children: [
      SizedBox(
        width: 1,
        height: 20,
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 300,
          height: 300,
          child: QRView(
              key: GlobalKey(debugLabel: 'QR'),
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).primaryColor,
                borderRadius: 15,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 200,
              ),
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  authorizeApp(scanData);
                });
                controller.resumeCamera();
              }
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          AppLocalizations.of(context).translate("no"),
        ),
      ),
      Container(
        width: double.infinity,
      )
    ],
  );

  Widget historyView() => Column(
    key: ValueKey<int>(11),
    children: [
      SobreroEmptyState(
        emptyStateKey: "ssoNoHistory",
      ),
      Container(
        width: double.infinity,
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: AppLocalizations.of(context).translate("authorizeApp"),
      child: Column(
        children: [
          SobreroToggle(
            margin: EdgeInsets.only(top: 10),
            values: [
              AppLocalizations.of(context).translate("scan"),
              AppLocalizations.of(context).translate("loginHistory"),
            ],
            width: 300,
            selectedItem: _currentPage,
            onToggleCallback: (s) => setState((){
              _currentPage = s;
            }),
          ),
          PageTransitionSwitcher2(
            reverse: _currentPage == 0,
            layoutBuilder: (_entries) => Stack(
              children: _entries
                  .map<Widget>((entry) => entry.transition)
                  .toList(),
              alignment: Alignment.topLeft,
            ),
            duration: Duration(milliseconds: 700),
            transitionBuilder: (c, p, s) => SharedAxisTransition(
              fillColor: Colors.transparent,
              animation: p,
              secondaryAnimation: s,
              transitionType: SharedAxisTransitionType.horizontal,
              child: c,
            ),
            child: _currentPage == 0 ? scanView() : historyView(),
          )
        ],
      ),
    );
  }
}