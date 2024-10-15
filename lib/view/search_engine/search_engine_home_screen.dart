import 'package:flutter/material.dart';
import 'package:mirror_wall/view/search_engine/search_engine_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/search_engine_provider.dart';

class SearchEngineHomeScreen extends StatelessWidget {
  const SearchEngineHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<SearchEngineProvider>(context);
    var providerFalse =
        Provider.of<SearchEngineProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.white,
      ),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: providerTrue.searchEngineList.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            providerFalse
                .setSearchEngine(providerTrue.searchEngineList[index].url);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchEngineScreen(),
              ),
            );
          },
          child: Container(
            height: height * 0.1,
            width: width * 0.4,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(providerTrue.searchEngineList[index].logo),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
