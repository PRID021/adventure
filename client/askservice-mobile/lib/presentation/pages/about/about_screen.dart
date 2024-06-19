import 'package:app_chat_proxy/dev/logger.dart';
import 'package:app_chat_proxy/presentation/pages/about/states.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_screen_state_notifier_provider.dart';

@RoutePage()
class AboutScreen extends StatefulHookConsumerWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  // Cookie manage

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future(() {
        ref.read(aboutScreenStateNotifierProvider.notifier).setUpCookie(
              uri: WebUri("https://example.com/"),
            );
      });
    }, const []);
    final state = ref.watch(aboutScreenStateNotifierProvider);
    logger.w(state);
    return Scaffold(
      appBar: AppBar(title: const Text("Official InAppWebView website")),
      body: SafeArea(
        child: Builder(builder: (context) {
          if (state is InitState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              TextField(
                decoration:
                    const InputDecoration(prefixIcon: Icon(Icons.search)),
                controller: urlController,
                keyboardType: TextInputType.url,
                onSubmitted: (value) {
                  var url = WebUri(value);
                  if (url.scheme.isEmpty) {
                    url = WebUri("https://www.google.com/search?q=$value");
                  }
                  webViewController?.loadUrl(urlRequest: URLRequest(url: url));
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(
                        url: WebUri("https://example.com/"),
                      ),
                      initialSettings: settings,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                        const html = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Cookie Property</title>
</head>
<body>

<script>
    // Function to get the value of a specific cookie
    function getCookieValue(cookieName) {
        // Split the cookie string into individual cookie key-value pairs
        var cookies = document.cookie.split(';');
        
        // Loop through each cookie to find the one with the specified name
        for (var i = 0; i < cookies.length; i++) {
            var cookie = cookies[i].trim(); // Trim any leading/trailing spaces
            
            // Check if this cookie has the specified name
            if (cookie.startsWith(cookieName + '=')) {
                // Return the value of the cookie (substring after the '=' character)
                return cookie.substring(cookieName.length + 1);
            }
        }
        
        // If the cookie with the specified name was not found, return null
        return null;
    }

    // Example usage: Get the value of a cookie named "username"
    var access_token = getCookieValue('access_token');
    var token_type = getCookieValue('token_type');
    console.log("Value of 'access_token' cookie:", access_token);
    console.log("Value of 'token_type' cookie:", token_type);
</script>

</body>
</html>
""";
                        final baseUrl = WebUri("https://example.com/");
                        webViewController!.loadData(
                            data: html, baseUrl: baseUrl, historyUrl: baseUrl);
                      },
                      onLoadStart: (controller, url) {
                        setState(
                          () {
                            this.url = url.toString();
                            urlController.text = this.url;
                          },
                        );
                      },
                      onPermissionRequest: (controller, request) async {
                        return PermissionResponse(
                            resources: request.resources,
                            action: PermissionResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;
                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                          return NavigationActionPolicy.CANCEL;
                        }
                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        // var result = await controller.evaluateJavascript(
                        //     source:
                        //         "new XMLSerializer().serializeToString(document);");
                        // logger.d(result.runtimeType); // String
                        // logger.d(result);
                        pullToRefreshController?.endRefreshing();
                        setState(
                          () {
                            this.url = url.toString();
                            urlController.text = this.url;
                          },
                        );
                      },
                      onReceivedError: (controller, request, error) {
                        pullToRefreshController?.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController?.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = url;
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
                        if (kDebugMode) {
                          print(consoleMessage);
                        }
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container()
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      webViewController?.goBack();
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      webViewController?.goForward();
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      webViewController?.reload();
                    },
                    child: const Icon(Icons.refresh),
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
