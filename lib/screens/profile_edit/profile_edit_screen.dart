import 'package:flutter/material.dart';
import 'components/profile_edit_body.dart';

class ProfileEditScreen extends StatefulWidget {
  static const routeName = "/profile_edit";

  const ProfileEditScreen({super.key});
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProfileEditBody());
  }
}
