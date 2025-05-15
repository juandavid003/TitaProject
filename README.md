# odontobb

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



To generate icons laucher - flutter packages pub run flutter_launcher_icons:main

To depploy IOs 
1- flutter build ios --release 
2- Xcode / Products / Archive

To depploy Android 
1- android / app / src / build.gradle : versionCode 
2- flutter build appbundle --release


Quick Clean Cache https://gist.github.com/minhcasi/2362b8ed369738cea2bf10a57ac569e1

SHA

View
keytool -list -v -keystore odontobb-release-key.jks -alias odontobb-release-key

keytool -printcert -jarfile app-release.aab

