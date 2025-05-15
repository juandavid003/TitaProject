import 'package:flutter/material.dart';
import 'package:odontobb/widgets/base_scaffold.dart';
import 'package:odontobb/screens/stats_page/components/stats_body.dart';

class StatsScreen extends StatelessWidget {
  static const routeName = "/stats_page";

  const StatsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: StatsBody());
  }
}
