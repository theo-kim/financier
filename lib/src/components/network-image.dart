import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkImage extends StatefulWidget {
  NetworkImage({required this.src});

  final String src;

  @override
  _NetworkImageState createState() => _NetworkImageState();
}

class _NetworkImageState extends State<NetworkImage> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    http.Response res = await http.get(Uri.parse(widget.src),
        headers: {"Referrer-Policy": "no-referrer"});
    if (res.statusCode == 200)
      _bytes = res.bodyBytes;
    else
      throw "Error fetching image";

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _bytes != null ? Image.memory(_bytes!) : Container();
  }
}
