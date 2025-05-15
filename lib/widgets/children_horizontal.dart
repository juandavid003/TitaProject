import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';

typedef StringCallback = void Function(List<PersonModel> val);

class ChildrenHorizontal extends StatefulWidget {
  final List<PersonModel> items;
  final String? image;
  final StringCallback? callback;
  const ChildrenHorizontal(
      {super.key, required this.items, this.image, this.callback});

  @override
  _ChildrenHorizontalState createState() => _ChildrenHorizontalState();
}

class _ChildrenHorizontalState extends State<ChildrenHorizontal> {
  final List<PersonModel> _childrensSelected = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.0,
      width: Utils.size(context).width,
      decoration: BoxDecoration(
        color: Colors.transparent, // Fondo transparente
        border: Border.all(
          color: kDarkItemColor, // Borde sutil
          width: 0.2,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: kDarkItemColor.withOpacity(0.05), // Sombra sutil
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: PageView(
          pageSnapping: false,
          controller: PageController(
            initialPage: 1,
            viewportFraction: 0.32,
          ),
          clipBehavior: Clip.antiAlias,
          children: _cards(context),
        ),
      ),
    );
  }

  List<Widget> _cards(BuildContext context) {
    return widget.items.map((item) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent, // Diseño limpio y moderno
        ),
        child: GestureDetector(
          // onTap: () {
          //   item.check = !item.check;
          //   _childrensSelected.add(item);
          //   widget.callback!(_childrensSelected);
          //   setState(() {});
          // },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  // Ícono dinámico en lugar de imagen
                  Container(
                    padding: EdgeInsets.all(6), // Espaciado sutil
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: item.check ? kDarkAppColor : kButtonColor,
                          width: 1),
                    ),
                    child: Icon(
                      item.sex == "male" ? Icons.boy : Icons.girl,
                      size: kPriceFontSize, // Tamaño optimizado
                      color: item.check ? kDarkAppColor : kButtonColor,
                    ),
                  ),
                  // Indicador de selección moderno
                  if (item.check)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kDarkAppColor,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4)
                        ],
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.check,
                          color: Colors.white, size: kExtraExtraMicroFontSize),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              // Nombre estilizado
              NormalText(
                text: item.name!,
                textSize: kSubTitleFontSize,
                fontWeight: FontWeight.w500,
                textColor: item.check ? kDarkAppColor : kButtonColor,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
