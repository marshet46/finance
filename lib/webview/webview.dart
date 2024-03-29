import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../check_internet.dart';
class WebviewTwo extends StatefulWidget {
  final String url;
  WebviewTwo({Key? key, required this.url}) : super(key: key);

  @override
  _WebviewTwoState createState() => _WebviewTwoState();
}
class _WebviewTwoState extends State<WebviewTwo> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? _webViewController;
  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();
  double progress = 0;
  String url = '';
  bool _isConnected = true;
  int checkInt = 1;
  final oneSignalAppId = '140e43b6-ca07-4606-b70a-5a284a23f6af';
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      javaScriptEnabled: true,
      useShouldOverrideUrlLoading: true,
      useOnDownloadStart: true,
      allowFileAccessFromFileURLs: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      initialScale: 100,
      allowFileAccess: true,
      useShouldInterceptRequest: true,
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.green),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController?.reload();
        } else if (Platform.isIOS) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );

    // disableCapture();
    configOneSignel();
    Future<int> a = CheckInternet().checkInternetConnection();
    a.then((value) {
      if (value == 0) {
        setState(() {
          checkInt = 0;
        });
        print('No internet connection');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'No internet connection!',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ));
      } else {
        setState(() {
          checkInt = 1;
        });
        print('Internet connected');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Connected to the internet Page is loading...',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ));
      }
    });
  }

  Future<void> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
          'https://dabidrinkmasstrade.abyssiniasoftware.com/');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  WillPopScope(
                    onWillPop: () async {
                      if (_webViewController != null &&
                          await _webViewController!.canGoBack()) {
                        _webViewController!.goBack();
                        return false;
                      } else {
                        return true;
                      }
                    },
                    child: checkInt == 1
                        ? InAppWebView(
                            key: webViewKey,
                            initialUrlRequest: URLRequest(
                              url: Uri.parse(
                                  'https://dabidrinkmasstrade.abyssiniasoftware.com/'),
                              headers: {},
                            ),
                            onLoadError: (InAppWebViewController controller,
                                Uri? url, int code, String message) {
                              if (message
                                      .contains("net::ERR_NAME_NOT_RESOLVED") ||
                                  message.contains(
                                      "net::ERR_CONNECTION_TIMED_OUT") ||
                                  message.contains(
                                      "net::ERR_SSL_PROTOCOL_ERROR") ||
                                  message.contains(
                                      "net::ERR_INTERNET_DISCONNECTED")) {
                              showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                      "Failed to load. Please check your internet connection.Try Again",
                                       style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 0, 0),
                                              fontSize: 24.0,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                              ),
                                      textAlign: TextAlign.center),
                                  SizedBox(
                                    width: 100.0,
                                    height: 100.0,
                                    child:    TextButton(
                                   onPressed: () {
                                        _webViewController?.reload();
                                         Navigator.of(context).pop();
                                      },
                                  child: const Text("Reload",style:TextStyle(color:Colors.white,fontSize: 24)),

                                )
                                  )

                                ],
                              ),
                            ));
                            },
                          );

                              }
                                  else {
                               showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                      "Failed to load. Please checknn your internet connection.",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 0, 0),
                                              fontSize: 24.0,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                              ),
                                      textAlign: TextAlign.center),
                                  SizedBox(

                                    child:
                                   TextButton(
                                   onPressed: () {
                                        _webViewController?.reload();
                                         Navigator.of(context).pop();
                                      },
                                  child: const Text("Reload",style:TextStyle(color:Colors.white,fontSize: 24)),

                                )

                                  )
                                ],
                              ),
                            ));
                            },
                          );

                              }
                            }, // "https://unsplash.com/photos/odxB5oIG_iA"
                            initialOptions: options,
                            pullToRefreshController: pullToRefreshController,
                            onDownloadStart: (controller, url) async {
                              // downloading a file in a webview application
                              print("onDownloadStart $url");
                              await FlutterDownloader.enqueue(
                                url: url.toString(), // url to download
                                savedDir:
                                    (await getExternalStorageDirectory())!.path,
                                // the directory to store the download
                                fileName: 'downloads',
                                headers: {},
                                showNotification: true,
                                openFileFromNotification: true,
                              );
                            },
                            onWebViewCreated: (controller) {
                              _webViewController = controller;
                            },
                            onLoadStart: (controller, url) {
                              setState(() {
                                this.url = url.toString();
                                urlController.text = this.url;
                              });
                            },
                            androidOnPermissionRequest:
                                (controller, origin, resources) async {
                              return PermissionRequestResponse(
                                  resources: resources,
                                  action:
                                      PermissionRequestResponseAction.GRANT);
                            },
                            onLoadStop: (controller, url) async {
                              pullToRefreshController.endRefreshing();
                              setState(() {
                                this.url = url.toString();
                                urlController.text = this.url;
                                _checkInternetConnection();
                              });
                            },

                            onProgressChanged: (controller, progress) {
                              if (progress == 100) {
                                pullToRefreshController.endRefreshing();
                              }
                              setState(() {
                                this.progress = progress / 100;
                                urlController.text = this.url;
                              });
                            },
                            onUpdateVisitedHistory:
                                (controller, url, androidIsReload) {
                              setState(() {
                                this.url = url.toString();
                                urlController.text = this.url;
                              });
                            },
                            onConsoleMessage: (controller, consoleMessage) {
                              print(consoleMessage);
                            },
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                      "Failed to load. Please check your internet connection.",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 0, 0),
                                              fontSize: 24.0,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                              ),
                                      textAlign: TextAlign.center),
                                  SizedBox(
                                    width: 100.0,
                                    height: 100.0,
                                    child:     TextButton(
                                   onPressed: () {
                                        _webViewController?.reload();
                                         Navigator.of(context).pop();
                                      },
                                  child: const Text("Reload",style:TextStyle(color:Colors.white,fontSize: 24)),

                                )
                                  )
                                ],
                              ),
                            )),
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(
                          value: progress,
                           minHeight: 12,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 235, 5, 81)!),
                        )
                      : Center(),
                ],
              ),
            ),
            ButtonBar(
              buttonAlignedDropdown: true,
              buttonPadding: EdgeInsets.all(0),
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    _webViewController?.goBack();
                  },
                ),
                TextButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    _webViewController?.reload();
                  },
                ),
                TextButton(
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    _webViewController?.goForward();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  void configOneSignel() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId(oneSignalAppId);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      Navigator.pushReplacementNamed(context, '/notification',
          arguments: {'url': result.notification.additionalData?['customURL']});
    });
  }
}
