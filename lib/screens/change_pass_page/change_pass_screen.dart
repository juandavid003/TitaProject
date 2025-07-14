import 'package:flutter/material.dart';
import 'package:odontobb/screens/change_pass_page/components/change_pass_body.dart';
import 'package:odontobb/widgets/base_scaffold.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: ChangePasswordBody(),
    );
  }
}
