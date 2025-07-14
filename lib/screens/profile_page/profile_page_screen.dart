import 'package:flutter/material.dart';
import 'package:odontobb/widgets/base_scaffold.dart';
import 'components/profile_page_body.dart';

class ProfilePageScreen extends StatelessWidget {
  static const routeName = "/profile_page";

  const ProfilePageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: ProfilePageBody());
  }
}
