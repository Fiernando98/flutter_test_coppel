import 'package:flutter/material.dart';
import 'package:flutter_test_coppel/pages/visualize_item_page.dart';
import 'package:flutter_test_coppel/utilities/search_appbar.dart';

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
      {required final String imagePath, final double size = 100}) {
    return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imagePath), fit: BoxFit.fill),
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
          height: 150,
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
                                child:
                                    _imageItem(imagePath: item["imagePath"])),
                            Text(item["name"])
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
                              imagePath: _listFilter[index]["imagePath"],
                              size: 70))),
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
      _listItems = [
        {
          "name": "Super man",
          "imagePath":
              "https://www.tomosygrapas.com/wp-content/uploads/2021/02/Portada-co%CC%81mic-Superman-78-de-Reeves-copia.jpg"
        },
        {
          "name": "Batman",
          "imagePath":
              "https://dam.smashmexico.com.mx/wp-content/uploads/2020/04/ayuda-a-tu-pequeno-a-hacer-el-cinturon-de-batman-cover.jpg"
        },
        {
          "name": "Flash",
          "imagePath":
              "https://img.europapress.es/fotoweb/fotonoticia_20210121145702_420.jpg"
        },
        {
          "name": "Hulk",
          "imagePath":
              "https://i.pinimg.com/originals/3e/2f/6a/3e2f6a9ce186fe59b4a7d392e1c96764.jpg"
        },
        {
          "name": "Thanos",
          "imagePath":
              "https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/media/image/2019/04/thanos_0.jpg"
        }
      ];
      setState(() {});
    } catch (error) {}
  }

  Future<void> _selectItem(
      {required Map<String, dynamic> item, required final int heroID}) async {
    try {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => VisualizeItemPage(item: item, heroID: heroID)));
    } catch (error) {}
  }
}
