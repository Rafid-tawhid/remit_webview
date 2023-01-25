
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:new_version_plus/new_version_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double prog = 0;
  late WebViewController _webViewController;
  String release = "";

  @override
  void initState() {
    _checkVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          if (await _webViewController.canGoBack()) {
            _webViewController.goBack();
            return false;
          } else {
            _webViewController.clearCache();

            print('Called..........');
            return true;
          }
        },
        child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: prog,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  Expanded(
                    child: WebView(
                      onProgress: (progress) => setState(() {
                        prog = progress / 100;
                        print("HELLO ....$progress");
                      }),
                      initialUrl: 'https://remit.daneshexchange.com',
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        // _controller.complete(webViewController);
                        _webViewController = webViewController;

                      },

                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
  void _checkVersion() async {
    final newVersion = NewVersionPlus(
        // iOSId: 'com.google.Vespa',
        androidId: 'com.remit.danesh_exchange',
        // androidPlayStoreCountry: "es_ES" //support country code
    );

    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.

    const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    }

  }
  basicStatusCheck(NewVersionPlus newVersion) async {
    final version = await newVersion.getVersionStatus();
    if (version != null) {
      release = version.releaseNotes ?? "";
      setState(() {});
    }
    newVersion.showAlertIfNecessary(
      context: context,
      launchModeVersion: LaunchModeVersion.external,
    );

    print('Latest version is $version');
    print('Latest release String is $release');
  }

}

