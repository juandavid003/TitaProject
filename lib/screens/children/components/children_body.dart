import 'package:intl/intl.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/models/sex_model.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/line_widget.dart';
import 'package:odontobb/widgets/textFileld_builder.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:provider/provider.dart';
import '../../../util.dart';

class ChildrenBody extends StatefulWidget {
  final PersonModel? personData;

  const ChildrenBody({super.key, this.personData});

  @override
  _ChildrenBodyState createState() => _ChildrenBodyState();
}

class _ChildrenBodyState extends State<ChildrenBody> {
  ChildrenService childrenService = ChildrenService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNamesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late String _personId;
  SexModel? _selectSex;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    initializeFields();
    getInfo();
  }

  void initializeFields() {
    final person = widget.personData;

    _nameController.text = person?.name ?? '';
    _lastNamesController.text = person?.lastNames ?? '';
    _personId = person?.id ?? '';
    _selectSex = sexes.firstWhere(
      (element) => element.value == person?.sex,
      orElse: () => sexes.first,
    );

    if (person?.dateOfbirth != null) {
      _selectedDate = person!.dateOfbirth!;
      _dateController.text = DateFormat("dd/MM/yyyy").format(_selectedDate!);
    } else {
      _selectedDate = DateTime.now();
    }
  }

  getInfo() async {
    await Future.delayed(Duration(seconds: Utils.loadingTime));
    if (mounted) setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    // if (_nameController.text.isEmpty) {
    //   _nameController.text = widget.personData?.name?.isNotEmpty == true
    //       ? widget.personData!.name!
    //       : '';
    // }
    // if (_lastNamesController.text.isEmpty) {
    //   _lastNamesController.text =
    //       widget.personData?.lastNames?.isNotEmpty == true
    //           ? widget.personData!.lastNames!
    //           : '';
    // }
    // _personId =
    //     widget.personData?.id?.isNotEmpty == true ? widget.personData!.id! : '';

    // if (widget.personData?.sex?.isNotEmpty == true && _selectSex == null) {
    //   _selectSex = sexes
    //       .firstWhere((element) => element.value == widget.personData?.sex);
    // } else {
    //   _selectSex ??= sexes.first;
    // }
    // try {
    //   String birthdayString =
    //       "${widget.personData!.dateOfbirth?.day.toString().padLeft(2, '0')}/"
    //       "${widget.personData!.dateOfbirth?.month.toString().padLeft(2, '0')}/"
    //       "${widget.personData!.dateOfbirth?.year}";

    //   _selectedDate = DateFormat("dd/MM/yyyy").parse(birthdayString);
    //   _dateController.text = birthdayString;
    // } catch (e) {
    //   _selectedDate = DateTime.now();
    // }

    return Scaffold(
      appBar: AppBar(
          title: NormalText(
        text: Utils.translate("add_beneficiary"),
        textSize: kPriceFontSize,
        fontWeight: FontWeight.w400,
      )),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 30.0,
                  bottom: 0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            InputTextField(
                              placeHolder: Utils.translate("name"),
                              icon: Icons.person,
                              controller: _nameController,
                            ),
                            LineWidget(),
                            InputTextField(
                                placeHolder: Utils.translate("lastnames"),
                                icon: Icons.family_restroom_sharp,
                                controller: _lastNamesController),
                            LineWidget(),
                            _selectSexAction(),
                            LineWidget(),
                            _selectDateAction(),
                            LineWidget(),
                            Center(
                              child: DefaultButton(
                                width: 170,
                                buttonTitle: Utils.translate("save"),
                                  onPress: () async {
                                    String name = _nameController.text.trim();
                                    String lastNames = _lastNamesController.text.trim();
                                    String? sex = _selectSex?.value;

                                    // Validaciones
                                    if (name.isEmpty || lastNames.isEmpty || sex == null || sex.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Todos los campos son obligatorios')),
                                      );
                                      return;
                                    }

                                    final nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');

                                    if (!nameRegex.hasMatch(name)) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('El nombre no debe contener números ni caracteres especiales')),
                                      );
                                      return;
                                    }

                                    if (!nameRegex.hasMatch(lastNames)) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Los apellidos no deben contener números ni caracteres especiales')),
                                      );
                                      return;
                                    }

                                    PersonModel newPerson = PersonModel();
                                    newPerson.name = name;
                                    newPerson.lastNames = lastNames;
                                    newPerson.sex = sex;
                                    newPerson.dateOfbirth = _selectedDate;

                                    if (_personId.isNotEmpty) {
                                      newPerson.id = _personId;
                                    }

                                    newPerson.parent = firebaseUser.uid;

                                    await childrenService.save(newPerson);
                                    Navigator.pop(context);
                                  },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectSexAction() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
        top: 0,
        bottom: 0,
      ),
      child: DropdownButton<SexModel>(
        value: _selectSex,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Utils.getColorMode(),
        ),
        iconSize: 30,
        style: TextStyle(
            color: Utils.getColorMode(),
            fontWeight: FontWeight.w400,
            fontSize: 18.0),
        underline: Container(),
        isExpanded: true,
        onChanged: (SexModel? newValue) {
          setState(() {
            _selectSex = newValue!;
          });
        },
        items: sexes.map<DropdownMenuItem<SexModel>>((SexModel value) {
          return DropdownMenuItem<SexModel>(
            value: value,
            child: Text(Utils.translate(value.name!)),
          );
        }).toList(),
      ),
    );
  }

  Widget _selectDateAction() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: InputTextField(
          placeHolder: Utils.translate("date_of_birth"),
          icon: Icons.calendar_today,
          controller: _dateController,
        ),
      ),
    );
  }

  // Widget _selectDateAction() {
  //   return GestureDetector(
  //     onTap: () async {
  //       DateTime? pickedDate = await showDatePicker(
  //         context: context,
  //         initialDate: _selectedDate ?? DateTime.now(),
  //         firstDate: DateTime(1900),
  //         lastDate: DateTime(2100),
  //       );
  //       if (pickedDate != null) {
  //         setState(() {
  //           _selectedDate = pickedDate;
  //           _dateController.text =
  //               "${pickedDate.day.toString().padLeft(2, '0')}/"
  //               "${pickedDate.month.toString().padLeft(2, '0')}/"
  //               "${pickedDate.year}";
  //         });
  //       }
  //     },
  //     child: AbsorbPointer(
  //       child: InputTextField(
  //         placeHolder: Utils.translate("date_of_birth"),
  //         icon: Icons.calendar_today,
  //         controller: _dateController,
  //       ),
  //     ),
  //   );
  // }
}
