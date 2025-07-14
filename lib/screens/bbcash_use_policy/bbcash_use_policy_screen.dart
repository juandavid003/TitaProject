import 'package:flutter/material.dart';
import 'package:odontobb/widgets/base_scaffold.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/page_title.dart';

import '../../util.dart';

class BbCashPolicyPage extends StatefulWidget {
  const BbCashPolicyPage({super.key});

  @override
  _BbCashPolicyPageState createState() => _BbCashPolicyPageState();
}

class _BbCashPolicyPageState extends State<BbCashPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageTitle(Utils.translate("bbcash_use_policy")),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionText(Utils.translate('bbcash_use_policy_definition')),
                    _sectionText(Utils.translate('bbcash_use_policy_conversion')),
                    _sectionText(Utils.translate('bbcash_use_policy_expiration')),
                    _sectionText(Utils.translate('bbcash_use_policy_benefits')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _sectionTitle(String text) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 10.0),
  //     child: NormalText(
  //       text: text,
  //       textSize: 18.0,
  //       fontWeight: FontWeight.bold,
  //       textColor: Utils.getColorMode(),
  //     ),
  //   );
  // }

  Widget _sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: NormalText(
        text: text,
        textSize: 16.0,
        textColor: Utils.getColorMode().withOpacity(0.8),
        textOverflow: TextOverflow.visible,
      ),
    );
  }
}
