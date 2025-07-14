import 'package:odontobb/constant.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/screens/children/components/children_body.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/custom_elements/custom_dialog_box.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

// ignore: must_be_immutable
class ChildrenCardSwiper extends StatefulWidget {
  List<PersonModel> items;
  ChildrenCardSwiper({super.key, required this.items});

  @override
  _ChildrenCardSwiperState createState() => _ChildrenCardSwiperState();
}

class _ChildrenCardSwiperState extends State<ChildrenCardSwiper> {
  ChildrenService childrenService = ChildrenService();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Utils.size(context).width,
        height: Utils.size(context).height * 0.4,
        padding: const EdgeInsets.only(top: 20.0),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Column(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: SizedBox(
                    height: Utils.size(context).height * 0.15,
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/images/boy.png'),
                      image: AssetImage(
                          'assets/images/${widget.items[index].sex == "male" ? "boy" : "girl"}.png'),
                      fit: BoxFit.cover,
                    ),
                  )),
              Align(
                child: NormalText(
                  text: widget.items[index].name!,
                  textColor: Utils.getColorMode(),
                  textSize: kNormalFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.edit_outlined,
                      color: Utils.isDarkMode ? kWhiteColor : kBlackFontColor,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ChildrenBody(personData: widget.items[index]);
                        }),
                      ).then((value) => {_loadChildrens()});
                    },
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.delete_outline,
                      color: Utils.isDarkMode ? kWhiteColor : kBlackFontColor,
                    ),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              title: Utils.translate("delete_beneficiary"),
                              descriptions: Utils.translate(
                                  "delete_beneficiary_description"),
                              textBtnAcept: Utils.translate("delete"),
                            );
                          }).then((value) async {
                        if (value) {
                          await childrenService.delete(widget.items[index]);
                          _loadChildrens();
                        }
                      });
                    },
                  )
                ],
              )
            ]);
          },
          itemCount: widget.items.length,
          viewportFraction: 0.5,
          scale: 0.9,
          loop: false,
        ));
  }

  _loadChildrens() async {
    widget.items = await childrenService.get();
    setState(() {});
  }
}
