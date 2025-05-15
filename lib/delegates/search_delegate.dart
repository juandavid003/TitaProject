import 'package:odontobb/models/tip.dart';
import 'package:odontobb/screens/item_detail_page/item_detail_screen.dart';
import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/services/tips_service.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:flutter/material.dart';
import '../constant.dart';
import '../util.dart';

class TipsSerachDelegate extends SearchDelegate {
  TipsService tipsService = TipsService();

  final bool? client;

  @override
  TipsSerachDelegate({this.client = false});

  @override
  String get searchFieldLabel => 'Buscar';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("buildResults");
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(
        Icons.question_answer_outlined,
        color: Colors.black38,
        size: 130,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty || !client!) {
      return _emptyContainer();
    }

    tipsService.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: tipsService.suggestionStream,
      builder: (BuildContext context, AsyncSnapshot<List<TipModel>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final tips = snapshot.data;
        return ListView.builder(
            itemCount: tips!.length,
            itemBuilder: (_, int index) => _TipItem(tips[index]));
      },
    );
  }
}

class _TipItem extends StatelessWidget {
  final TipModel tip;

  const _TipItem(this.tip);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: NormalText(
        textOverflow: TextOverflow.ellipsis,
        text: tip.title!,
        textColor: Utils.getColorMode(),
        textSize: kSmallFontSize,
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.left,
      ),
      subtitle: NormalText(
        textOverflow: TextOverflow.ellipsis,
        text: tip.description!,
        textColor: Utils.getColorMode(),
        textSize: kMicroFontSize,
        textAlign: TextAlign.left,
      ),
      leading: _getImage(context, tip.image!),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ItemDetailScreen(
                title: tip.title!,
                description: tip.description,
                imageUrl: tip.imageUrl);
          }),
        );
      },
    );
  }

  Widget _getImage(BuildContext context, String imageName) {
    if (tip.imageUrl != null) {
      return Image.network(tip.imageUrl!,
          fit: BoxFit.fitWidth, width: 50.0, height: 50.0);
    } else {
      return FutureBuilder(
        future: FileService.loadImage('tips/$imageName'),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            tip.imageUrl = snapshot.data!;
            return Image.network(tip.imageUrl!,
                fit: BoxFit.fitWidth, width: 50.0, height: 50.0);
          } else {
            return ShimmerWidget(
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: kWhiteColor,
                ),
              ),
            );
          }
        },
      );
    }
  }
}
