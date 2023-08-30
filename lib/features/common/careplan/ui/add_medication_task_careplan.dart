import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:patient/features/common/careplan/models/assesment_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/common/medication/models/drugs_library_pojo.dart';
import 'package:patient/features/common/medication/models/nih_medication_search_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';

import '../../../../infra/utils/common_utils.dart';

//ignore: must_be_immutable
class AddMedicationTaskView extends StatefulWidget {
  Next? next;

  AddMedicationTaskView(this.next);

  @override
  _AddMedicationTaskViewState createState() => _AddMedicationTaskViewState();
}

class _AddMedicationTaskViewState extends State<AddMedicationTaskView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> records = <String>[];
  bool searchForDrug = false;
  List<Items> drugs = [];
  List<String?> drugsList = [];
  final _typeAheadController = TextEditingController();

  @override
  void initState() {
    announceText(widget.next!.title.toString());
    /*if (widget.task!.action!.description != null) {
      _textController.text = widget.task!.action!.description.toString();
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              'Assessment',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
              /*IconButton(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 32.0,
                ),
                onPressed: () {
                  debugPrint("Clicked on profile icon");
                },
              )*/
            ],
          ),
          body: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    color: primaryColor,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: primaryColor,
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: body(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        questionText(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //headerText(),
                SizedBox(
                  height: 4,
                ),
                _drugName(),
                SizedBox(
                  height: 4,
                ),
                _listFieldForMedicationAdded(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        _submitButton(),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget headerText() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorF6F6FF,
      ),
      child: Center(
        child: Text(
          widget.next!.nodeType.toString(),
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget questionText() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: primaryLightColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12))),
      child: Center(
        child: Text(
          '\n' + widget.next!.title.toString(),
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _listFieldForMedicationAdded() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
          itemBuilder: (context, index) => Card(
            semanticContainer: false,
            elevation: 0.0,
            child: Container(
              height: 30,
              child: ListTile(
                title: Text(
                  records.elementAt(index),
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
          itemCount: records.length,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true),
    );
  }

  Widget _submitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Material(
          //Wrap with Material
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          elevation: 4.0,
          color: primaryColor,
          clipBehavior: Clip.antiAlias,
          // Add This
          child: MaterialButton(
            minWidth: 120,
            child: Text('Next',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              var stringList = records.join(", ");
              debugPrint("Medication Selected ==> $stringList");
              Navigator.pop(context, stringList);
            },
          ),
        ),
      ],
    );
  }

  Widget _drugName() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Drug Name',
              style: TextStyle(
                  fontSize: 16.0,
                  color: textBlack,
                  fontWeight: FontWeight.w600)),
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
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _typeAheadController,
                        onChanged: (text) {
                          debugPrint(text);
                          _getDrugsByName();
                        },
                        /*decoration: InputDecoration(
                                                  labelText: 'City'
                                              )*/
                      ),
                      suggestionsCallback: (pattern) {
                        return Future.delayed(
                          Duration(seconds: 4),
                          () => getDrugsSuggestions(pattern),
                        );
                      },
                      itemBuilder: (context, dynamic suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion,
                            semanticsLabel: suggestion,
                          ),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (dynamic suggestion) {
                        debugPrint(suggestion);
                        records.add(suggestion);
                        _typeAheadController.text = '';
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select a drug';
                        } else {
                          return '';
                        }
                      },
                      onSaved: (value) {
                        debugPrint(value);
                      },
                    ),
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
                          if (_typeAheadController.text.isNotEmpty) {
                            FocusScope.of(context).unfocus();
                            _addDrugConfirmDialog(context);
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
      ),
    );
  }

  List<String?> getDrugsSuggestions(String query) {
    final List<String?> matches = [];
    matches.addAll(drugsList);
    matches.retainWhere((s) => s!.toLowerCase().contains(query.toLowerCase()));
    return matches;
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
                      _typeAheadController.text +
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

      _sortDrugs(searchResponse);
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

  _sortDrugs(NihMedicationSearchResponse searchResponse) {
    drugsList.clear();
    for (int i = 0; i < searchResponse.nihMedicationList!.length; i++) {
      drugsList.add(searchResponse.nihMedicationList!.elementAt(i).name);
    }
    setState(() {});
  }

/*Widget _addMedicationButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Semantics(
          label: 'Search Medication',
          button: true,
          child: ExcludeSemantics(
            child: InkWell(
              onTap: () {
                showMaterialModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    context: context,
                    builder: (context) => SearchNihMedicationView(
                            submitButtonListner: (String medicationName) {
                          debugPrint(
                              'Added Medication List Name ==> $medicationName');
                          records.add(medicationName);
                          setState(() {});
                        }));
              },
              child: Container(
                height: 32,
                width: 180,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: primaryColor, width: 1),
                    color: primaryColor),
                child: Center(
                  child: Text(
                    'Search Medication',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }*/
}
