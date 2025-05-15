import 'package:odontobb/models/diagnosis_model.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/screens/diagnosis_page/widgets/diagnosis_builder.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/services/diagnosis_service.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constant.dart';
import '../../../util.dart';

class DiagnosisBody extends StatefulWidget {
  final PersonModel? personModel;

  const DiagnosisBody({Key? key, this.personModel}) : super(key: key);

  @override
  _DiagnosisBodyState createState() => _DiagnosisBodyState();
}

class _DiagnosisBodyState extends State<DiagnosisBody> {
  final ChildrenService childrenService = ChildrenService();
  final storage = const FlutterSecureStorage();

  List<DiagnosisModel> _diagnosisList = [];
  List<PersonModel> childrens = [];
  PersonModel? _selectChildren;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadInit();
  }

Future<void> loadInit() async {
  setState(() => _isLoading = true);
  try {
    final childrenList = await childrenService.get();
    if (childrenList.isNotEmpty) {
      // Usar el hijo recibido si existe, si no, el primero de la lista
      _selectChildren = widget.personModel != null
          ? childrenList.firstWhere(
              (c) => c.id == widget.personModel!.id,
              orElse: () => childrenList.first,
            )
          : childrenList.first;

      await _loadDiagnosis(_selectChildren);
      if (mounted) {
        setState(() {
          childrens = childrenList;
        });
      }
    }
  } catch (e) {
    debugPrint("Error en loadInit: $e");
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  Future<void> _loadDiagnosis(PersonModel? child) async {
    if (child == null || child.id == null) return;
    try {
      final diagnosisList = await DiagnosisService.getDiagnosisData(child.id!);
      if(diagnosisList.isEmpty){
         _isLoading = false;
      }
      if (mounted) {
        setState(() {
          _diagnosisList = diagnosisList;
        });
      }
    } catch (e) {
      debugPrint("Error cargando diagnósticos: $e");
    }
  }

  @override
Widget build(BuildContext context) {
  final firebaseUser = context.watch<User?>();

  return Scaffold(
    backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
    appBar: AppBar(
      title: NormalText(
        text: "Historial",
        textSize: kTitleFontSize,
        fontWeight: FontWeight.w400,
      ),
    ),
    body: Column(
      children: [
        const SizedBox(height: 10.0),
        NormalText(
          text: "Selecciona un usuario",
          textSize: kNormalFontSize,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: _dropdownButton(),
        ),
        const SizedBox(height: 10.0),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _diagnosisList.isEmpty
                  ? const Center(child: Text(
                          "No se encontraron diagnósticos",
                          style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w400,),
                        ))
                  : DiagnosisBuilder(
                      key: ValueKey(_selectChildren?.id), // Evita problemas con claves duplicadas
                      diagnosisList: _diagnosisList,
                      limit: 10,
                      isScroll: true,
                    ),
        ),
      ],
    ),
  );
}
Widget _dropdownButton() {
  return DropdownButton<PersonModel>(
    value: childrens.contains(_selectChildren) ? _selectChildren : null,
    icon: Icon(Icons.arrow_drop_down, color: Utils.getColorMode()),
    isExpanded: true,
    onChanged: (PersonModel? newValue) async {
      if (newValue == null || newValue == _selectChildren) return;
      setState(() => _selectChildren = newValue);
      await _loadDiagnosis(newValue);
    },
    items: childrens.isNotEmpty
        ? childrens.map<DropdownMenuItem<PersonModel>>((PersonModel value) {
            return DropdownMenuItem<PersonModel>(
              value: value,
              child: Text('${value.name} ${value.lastNames}'),
            );
          }).toList()
        : [DropdownMenuItem<PersonModel>(value: null, child: Text('No children available'))],
  );
}
}
