import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

import '../../../../../../../../../../../main.dart';

class NewView extends StatefulWidget {
  const NewView({super.key});

  @override
  State<NewView> createState() => _NewViewState();
}

class _NewViewState extends State<NewView> {
  InAppWebViewController? webViewController;

  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  late ContextMenu contextMenu;

  PullToRefreshController? pullToRefreshController;

  // String currentUrl = "";
  double progress = 0;
  final urlController = TextEditingController();

  final searchBarController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  String placeHolderText = "Search";

  @override
  void initState() {
    super.initState();
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              id: 1,
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = contextMenuItemClicked.id;
          print("onContextMenuActionItemClicked: $id ${contextMenuItemClicked.title}");
        });

    pullToRefreshController = kIsWeb || ![TargetPlatform.iOS, TargetPlatform.android].contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // appBar: AppbarView(),
      body: Padding(
        padding: const EdgeInsets.only(top: 13),
        child: SuperScaffold(
          scrollController: ScrollController(),
          physics: NeverScrollableScrollPhysics(),
          appBar: SuperAppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            height: 0,
            // title: null,
            title: Text("Hello SuperScaffold"),
            largeTitle: SuperLargeTitle(
              enabled: false,
              largeTitle: "Welcome",
            ),
            searchBar: SuperSearchBar(
              placeholderText: placeHolderText,
              //TextAlign.center
              placeholderTextStyle: TextStyle(
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: Colors.grey,
              ),
              searchController: searchBarController,
              searchFocusNode: searchFocusNode,

              enabled: true,
              scrollBehavior: SearchBarScrollBehavior.pinned,
              onFocused: (focus) {
                print("Focused: $focus");
                if (focus) {
                  setState(() {
                    if (urlController.text != "" && urlController.text != "about:blank") {
                      searchBarController.text = urlController.text;
                      searchBarController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: searchBarController.text.length,
                      );
                    }
                  });
                }
              },
              onChanged: (query) {
                print("Query: $query");
              },
              onSubmitted: (query) async {
                print("Submitted: $query");
                if (query.isNotEmpty && query.startsWith("http")) {
                  urlController.text = query;
                  if (urlController.text != "" && urlController.text != "about:blank") {
                    placeHolderText = urlController.text;
                  } else {
                    placeHolderText = "Search";
                  }

                  webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(urlController.text)));

                  searchBarController.clear();
                  searchFocusNode.unfocus();
                } else {
                  final googleSearchUrl = generateGoogleSearchUrl(query);
                  urlController.text = googleSearchUrl;
                  if (urlController.text != "" && urlController.text != "about:blank") {
                    placeHolderText = urlController.text;
                  } else {
                    placeHolderText = "Search";
                  }

                  webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(urlController.text)));

                  searchBarController.clear();
                  searchFocusNode.unfocus();
                }
              },
              actions: [
                // back forward
                SuperAction(
                  behavior: SuperActionBehavior.visibleOnUnFocus,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ).gestures(onTap: () {
                    webViewController?.goBack();
                  }),
                ),
                SuperAction(
                  behavior: SuperActionBehavior.visibleOnUnFocus,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ).gestures(onTap: () {
                    webViewController?.goForward();
                  }),
                ),
                // const SuperAction(
                //   behavior: SuperActionBehavior.visibleOnUnFocus,
                //   child: Padding(
                //     padding: EdgeInsets.only(left: 20.0),
                //     child: Icon(
                //       Icons.refresh,
                //       color: Colors.grey,
                //       size: 28,
                //     ),
                //   ),
                // ),
                const SuperAction(
                  behavior: SuperActionBehavior.visibleOnUnFocus,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ),
                ),
              ],
              // searchResult: /* ... */,
              // Add other search bar properties as needed
            ),
            // bottom: SuperAppBarBottom(
            //   enabled: true,
            //   height: 40,
            //   child: Container(color: Colors.red),
            // ),
          ),
          body: InAppWebView(
            // key: webViewKey,
            // webViewEnvironment: webViewEnvironment,
            initialUrlRequest: URLRequest(url: WebUri('https://docs.flutter.dev')),
            // initialUrlRequest:
            // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
            // initialFile: "assets/index.html",
            initialUserScripts: UnmodifiableListView<UserScript>([]),
            initialSettings: settings,
            contextMenu: contextMenu,
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) async {
              webViewController = controller;
            },
            onLoadStart: (controller, url) async {
              print("onLoadStart: $url");
              setState(() {
                urlController.text = url.toString();
                if (urlController.text != "" && urlController.text != "about:blank") {
                  placeHolderText = urlController.text;
                }
              });
            },
            onPermissionRequest: (controller, request) async {
              return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;

              if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                // if (await canLaunchUrl(uri)) {
                //   // Launch the App
                //   await launchUrl(
                //     uri,
                //   );
                //   // and cancel the request
                //   return NavigationActionPolicy.CANCEL;
                // }
              }

              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {
              print("onLoadStop: $url");
              pullToRefreshController?.endRefreshing();
              setState(() {
                urlController.text = url.toString();
                if (urlController.text != "" && urlController.text != "about:blank") {
                  placeHolderText = urlController.text;
                }
              });
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
              });
            },
            onUpdateVisitedHistory: (controller, url, isReload) {
              print("onUpdateVisitedHistory: $url");
              setState(() {
                urlController.text = url.toString();
                if (urlController.text != "" && urlController.text != "about:blank") {
                  placeHolderText = urlController.text;
                }
              });
            },
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButtonKit(
        button1: (context) {
          searchFocusNode.unfocus();
        },
      ),
    );
  }
}

String generateGoogleSearchUrl(String keyword) {
  const String baseUrl = 'https://www.google.com/search?q=';
  final String encodedKeyword = Uri.encodeComponent(keyword);
  return '$baseUrl$encodedKeyword';
}
main() async {
  return buildApp(home: NewView());
}
