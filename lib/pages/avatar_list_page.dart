import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_coppel/pages/visualize_item_page.dart';
import 'package:flutter_test_coppel/utilities/methods/public.dart';
import 'package:flutter_test_coppel/utilities/search_appbar.dart';
import 'package:http/http.dart' as http;

class AvatarListPage extends StatefulWidget {
  const AvatarListPage({Key? key}) : super(key: key);

  @override
  _AvatarListPageState createState() => _AvatarListPageState();
}

class _AvatarListPageState extends State<AvatarListPage> {
  List<dynamic>? _listItems;
  String _searchQuery = "";

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  AppBar _appBar() {
    return SearchAppBar(
        title: const Text("Avatares"),
        searchText: "Buscar",
        onTextChange: (newText) {
          setState(() {
            _searchQuery = newText;
          });
        });
  }

  Widget _imageItem(
      {required final String? imagePath, final double size = 100}) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            image: (imagePath != null)
                ? DecorationImage(
                    image: NetworkImage(imagePath), fit: BoxFit.fill)
                : null,
            shape: BoxShape.circle));
  }

  Widget _body() {
    if (_listItems == null) {
      return const Center(child: CircularProgressIndicator());
    }

    List<dynamic> _listFilter = _listItems!.toList();
    if (_searchQuery.isNotEmpty) {
      _listFilter.removeWhere((final dynamic item) => ![
            item["name"].toString().toLowerCase()
          ].any((element) => element.contains(_searchQuery.toLowerCase())));
    }

    if (_listFilter.isNotEmpty != true) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(15), child: Text("No hay elementos")));
    }

    return ListView(children: [
      SizedBox(
          height: 130,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: _listFilter
                  .map((item) => InkWell(
                      onTap: () => _selectItem(
                          item: item, heroID: _listFilter.indexOf(item)),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(children: [
                            Hero(
                                tag: _listFilter.indexOf(item),
                                child: _imageItem(
                                    imagePath: item["images"]?["sm"], size: 80)),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(item["name"], maxLines: 1))
                          ]))))
                  .toList())),
      ListView.separated(
          itemCount: _listFilter.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 0, thickness: 1, color: Colors.grey),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () => _selectItem(
                    item: _listFilter[index],
                    heroID: index + _listFilter.length),
                child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Hero(
                          tag: index + _listFilter.length,
                          child: _imageItem(
                              imagePath: _listFilter[index]["images"]?["sm"],
                              size: 80))),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(_listFilter[index]["name"])])))
                ]));
          })
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: SafeArea(child: _body()));
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration.zero);
    try {
      final http.Response response = await http.get(
          Uri.parse(
              "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/all.json"),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 30),
          onTimeout: () => throw "Se acabó el tiempo");
      if (response.statusCode == 200) {
        _listItems = await json.decode(utf8.decode(response.bodyBytes));
        setState(() {});
      } else {
        throw await PublicMethods.getErrorFromServer(
            response: response, context: context);
      }
    } catch (error) {
      PublicMethods.snackMessage(
          message: error.toString(), context: context, isError: true);
    }
  }

  Future<void> _selectItem(
      {required Map<String, dynamic> item, required final int heroID}) async {
    try {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => VisualizeItemPage(item: item, heroID: heroID)));
    } catch (error) {
      PublicMethods.snackMessage(
          message: error.toString(), context: context, isError: true);
    }
  }
}
