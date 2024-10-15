import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../../provider/search_engine_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<SearchEngineProvider>(context);
    var providerFalse =
        Provider.of<SearchEngineProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              providerTrue.clearHistory();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: providerTrue.history.length,
        itemBuilder: (context, index) {
          final url = providerTrue.history[index];
          return ListTile(
            title: Text(url),
            onTap: () {
              providerTrue.webViewController!.loadUrl(
                urlRequest: URLRequest(
                  url: WebUri(url),
                ),
              );
              providerFalse.addUrlToController(url);
              Navigator.pop(context);
            },
            trailing: Consumer<SearchEngineProvider>(
              builder: (context, value, child) {
                return IconButton(
                  onPressed: () {
                    value.deleteHistory(index);
                  },
                  icon: const Icon(Icons.delete),
                );
              }
            ),
          );
        },
      ),
    );
  }
}
