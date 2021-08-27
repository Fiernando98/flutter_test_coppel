import 'package:flutter/material.dart';

class VisualizeItemPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final int heroID;

  const VisualizeItemPage({Key? key, required this.item, required this.heroID})
      : super(key: key);

  @override
  _VisualizeItemPageState createState() => _VisualizeItemPageState();
}

class _VisualizeItemPageState extends State<VisualizeItemPage> {
  AppBar _appBar() {
    return AppBar(title: Text(widget.item["name"]));
  }

  Widget _imageItem() {
    return Hero(
        tag: widget.heroID,
        child: Container(
            height: 250.0,
            width: 250.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.item["imagePath"]),
                    fit: BoxFit.fill),
                shape: BoxShape.circle)));
  }

  Widget _nameItem() {
    return Text(widget.item["name"],
        textAlign: TextAlign.center, style: const TextStyle(fontSize: 20));
  }

  Widget _body() {
    return ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          _imageItem(),
          const SizedBox(height: 10),
          _nameItem(),
          const SizedBox(height: 10),
          const Divider(height: 0, thickness: 1, color: Colors.black),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: SafeArea(child: _body()));
  }
}
