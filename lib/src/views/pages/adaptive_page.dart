import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AdaptivePage extends StatefulWidget {
  AdaptivePage({required this.setFAB});

  final Function(FloatingActionButton fab) setFAB;
}
