import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:patient/features/common/medication/models/nih_medication_search_response.dart';
import 'package:patient/features/common/medication/view_models/patients_medication.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';

//ignore: must_be_immutable
class SearchNihMedicationView extends StatefulWidget {
  late Function _submitButtonListner;

  // ignore
  //AllergiesDialog(@required this._allergiesCategoryMenuItems,@required this._allergiesSeveretyMenuItems, @required Function this.submitButtonListner, this.patientId);

  SearchNihMedicationView({Key? key, required Function submitButtonListner})
      : super(key: key) {
    _submitButtonListner = submitButtonListner;
  }

  @override
  _SearchNihMedicationViewState createState() =>
      _SearchNihMedicationViewState();
}

class _SearchNihMedicationViewState extends State<SearchNihMedicationView> {
  var model = PatientMedicationViewModel();
  final _textController = TextEditingController();
  List<NihMedicationList>? _nihMedicationList = [];
  bool searchForDrug = false;
  List<String?> drugsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientMedicationViewModel?>(
        model: model,
        builder: (context, model, child) => searchMedicationList());
  }

  Widget searchMedicationList() {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  )),
              SizedBox(
                height: 8,
              ),
              _drugName(),
              _listFieldForMedicationSearched(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drugName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Drug Name',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          height: 48,
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
              color: Colors.white),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Semantics(
                  label: 'Drug Name',
                  focusable: true,
                  child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _textController,
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (term) {},
                      onChanged: (term) {
                        debugPrint('Medication Name ==> $term');
                        if (term.length > 1) {
                          _getDrugsByName();
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(0.0),
                height: 40.0,
                width: 40.0,
                child: Center(
                  child: Semantics(
                    label: 'Search new drug',
                    button: true,
                    child: InkWell(
                      onTap: () {
                        _getDrugsByName();
                      },
                      child: searchForDrug
                          ? CircularProgressIndicator()
                          : Icon(
                              Icons.search,
                              color: primaryColor,
                              size: 32.0,
                            ),
                    ),
                  ),
                ),
              ),
              /*Container(
                padding: const EdgeInsets.all(0.0),
                height: 40.0,
                width: 40.0,
                child: Center(
                  child: Semantics(
                    label: 'Add new drug',
                    button: true,
                    child: InkWell(
                      onTap: () {
                        if (_textController.text.isNotEmpty) {
                          */ /*FocusScope.of(context).unfocus();
                          _addDrugConfirmDialog(context);*/ /*
                        }
                      },
                      child: Icon(
                        Icons.add,
                        color: primaryColor,
                        size: 32.0,
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        )
      ],
    );
  }

  _getDrugsByName() async {
    setState(() {
      searchForDrug = true;
    });
    Map<String, String>? headers = <String, String>{};
    var responseJson;
    try {
      final response = await http
          .get(
              Uri.parse(
                  'https://nctr-crs.fda.gov/fdalabel/services/product/names-containing/' +
                      _textController.text +
                      '?l=10&t=TRADE'),
              headers: headers)
          .timeout(const Duration(seconds: 40));
      responseJson = json.decode('{ "data" :' + response.body.toString() + '}');

      debugPrint(
          'Nih Medication Response ==> ${'{ "data" :' + response.body.toString() + '}'}');

      NihMedicationSearchResponse searchResponse =
          NihMedicationSearchResponse.fromJson(responseJson);

      debugPrint(
          'Nih Medication List Lenght ==> ${searchResponse.nihMedicationList!.length.toString()}');

      setState(() {
        searchForDrug = false;
      });

      _nihMedicationList = searchResponse.nihMedicationList;
      _sortDrugs();
      /*if (baseResponse.status == 'success') {
        setState(() {
          searchForDrug = false;
        });
        drugs.clear();
        setState(() {
          drugs.addAll(baseResponse.data!.drugs!.items!);
        });
        _sortDrugs();
      } else {
        setState(() {
          searchForDrug = false;
        });
        showToast('Please try again', context);
      }*/
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      // A timeout occurred.
      throw FetchDataException('No Internet connection');
    } catch (CustomException) {
      setState(() {
        searchForDrug = false;
      });
      debugPrint('Error ' + CustomException.toString());
    }
  }

  _sortDrugs() {
    drugsList.clear();
    for (int i = 0; i < _nihMedicationList!.length; i++) {
      drugsList.add(_nihMedicationList!.elementAt(i).name);
    }
    setState(() {});
  }

  Widget _listFieldForMedicationSearched() {
    return Container(
      height: MediaQuery.of(context).size.height - 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => Card(
              semanticContainer: false,
              elevation: 0.0,
              child: Container(
                height: 40,
                child: ListTile(
                  onTap: () {
                    widget._submitButtonListner(
                        drugsList.elementAt(index).toString());
                    Navigator.pop(context);
                  },
                  title: Text(
                    drugsList.elementAt(index).toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: textBlack),
                  ),
                ),
              ),
            ),
            itemCount: drugsList.length,
          ),
        ),
      ),
    );
  }
}
