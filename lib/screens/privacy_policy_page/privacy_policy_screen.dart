import 'package:flutter/material.dart';
import 'package:odontobb/widgets/base_scaffold.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/page_title.dart';

import '../../util.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageTitle(Utils.translate("privacy_policy")),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(Utils.translate('privacy_policy_title')),
                    _sectionText(
                        Utils.translate('privacy_policy_description1')),
                    _sectionText(
                        Utils.translate('privacy_policy_description2')),
                    _sectionText(Utils.translate('privacy_policy_conclusion')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: NormalText(
        text: text,
        textSize: 18.0,
        fontWeight: FontWeight.bold,
        textColor: Utils.getColorMode(),
      ),
    );
  }

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
