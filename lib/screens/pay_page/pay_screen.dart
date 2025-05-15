import 'package:flutter/material.dart';
import 'package:odontobb/widgets/base_scaffold.dart';

import 'components/pay_body.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: PayPage());
  }
}
