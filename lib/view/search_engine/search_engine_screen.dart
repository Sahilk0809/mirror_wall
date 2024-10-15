import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import '../../provider/search_engine_provider.dart';
import 'history_screen.dart';

class SearchEngineScreen extends StatefulWidget {
  const SearchEngineScreen({super.key});

  @override
  State<SearchEngineScreen> createState() => _SearchEngineScreenState();
}

class _SearchEngineScreenState extends State<SearchEngineScreen> {
  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<SearchEngineProvider>(context);
    var providerFalse =
        Provider.of<SearchEngineProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              providerTrue.txtSearch.clear();
              Navigator.pop(context);
            },
            child: const Icon(Icons.home_outlined)),
        title: const Text('Search Engine'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Consumer<SearchEngineProvider>(
                builder: (context, value, child) {
              return TextField(
                controller: value.txtSearch,
                cursorColor: Colors.black,
                onSubmitted: (value) {
                  final searchUrl = providerTrue.selectedEngineUrl + value;
                  providerTrue.webViewController?.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri(searchUrl),
                    ),
                  );
                  providerFalse.addToHistory(searchUrl);
                  providerFalse.updateNavigationButtons();
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: 'Search',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: Column(
        children: [
          if (providerTrue.isLoading)
            const Center(
              child: LinearProgressIndicator(),
            ),
          Expanded(
            child: Consumer<SearchEngineProvider>(
                builder: (context, value, child) {
              return InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(value.selectedEngineUrl),
                ),
                onWebViewCreated: (controller) {
                  value.webViewController = controller;
                },
                onLoadStop: (controller, url) async {
                  if (url != null) {
                    value.setLoader(false);
                    value.addToHistory(url.toString());
                    await value.updateNavigationButtons();
                  }
                },
                onLoadStart: (controller, url) {
                  providerFalse.setLoader(true);
                },
              );
            }),
          ),
          _buildNavigationControls(providerTrue, providerFalse),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(
      SearchEngineProvider providerTrue, SearchEngineProvider providerFalse) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: providerTrue.canGoBack ? providerFalse.goBack : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed:
                providerTrue.canGoForward ? providerFalse.goForward : null,
          ),
          IconButton(
            onPressed: () {
              providerTrue.webViewController!.reload();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
