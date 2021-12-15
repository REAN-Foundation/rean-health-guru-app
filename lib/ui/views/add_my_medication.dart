import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/DrugsLibraryPojo.dart';
import 'package:paitent/core/models/GetMedicationStockImages.dart';
import 'package:paitent/core/models/MedicationDosageUnitsPojo.dart';
import 'package:paitent/core/models/MedicationDurationUnitsPojo.dart';
import 'package:paitent/core/models/MedicationFrequenciesPojo.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';

class AddMyMedicationView extends StatefulWidget {
  @override
  _AddMyMedicationViewState createState() => _AddMyMedicationViewState();
}

class _AddMyMedicationViewState extends State<AddMyMedicationView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var model = PatientMedicationViewModel();
  final _instructionController = TextEditingController();
  final _instructionFocus = FocusNode();
  final _unitFocus = FocusNode();
  final _sharedPrefUtils = SharedPrefUtils();

  String _dosageUnit = '';
  String _frequencyUnit = '';
  String startOn = '';

  final _unitController = TextEditingController();
  final _durationController = TextEditingController();
  final _typeAheadController = TextEditingController();

  bool searchForDrug = false;
  List<Items> drugs = [];

  List<String> drugsList = [];
  List<DropdownMenuItem<String>> _dosageUnitMenuItems;
  List<DropdownMenuItem<String>> _frequencyUnitMenuItems;

  bool morningCheck = false;
  bool afternoonCheck = false;
  bool eveningCheck = false;
  bool nightCheck = false;

  List<MedicationStockImages> medicationStockImagesList =
      <MedicationStockImages>[];

  String medcationResourceId = '';

  @override
  void initState() {
    loadSharedPrefs();
    _getMedicaionStockImages();
    /*if (widget._visitInformation.drugOrderId == "") {
      _addPatientMedicationOrderId();
    }*/
    super.initState();
  }

  loadSharedPrefs() async {
    try {
      final MedicationDosageUnitsPojo dosageUnitsPojo =
          MedicationDosageUnitsPojo.fromJson(
              await _sharedPrefUtils.read('MedicationDosageUnits'));
      debugPrint(
          'Dosage = ${dosageUnitsPojo.data.medicationDosageUnits.length.toString()}');
      final MedicationDurationUnitsPojo durationUnitsPojo =
          MedicationDurationUnitsPojo.fromJson(
              await _sharedPrefUtils.read('MedicationDurationUnits'));
      debugPrint(
          'Duration = ${durationUnitsPojo.data.medicationDurationUnits.length.toString()}');
      final MedicationFrequenciesPojo frequenciesPojo =
          MedicationFrequenciesPojo.fromJson(
              await _sharedPrefUtils.read('MedicationFrequencies'));
      debugPrint(
          'Frequency = ${frequenciesPojo.data.medicationFrequencyUnits.length.toString()}');

      setState(() {
        _frequencyUnitMenuItems = buildDropDownMenuItemsForFrequency(
            frequenciesPojo.data.medicationFrequencyUnits);
        _dosageUnitMenuItems = buildDropDownMenuItemsForDosageUnit(
            dosageUnitsPojo.data.medicationDosageUnits);
      });
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
    }
    /*catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }*/
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItemsForDosageUnit(
      List<String> allergenCategories) {
    final List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < allergenCategories.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(allergenCategories.elementAt(i)),
        value: allergenCategories.elementAt(i),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItemsForDurationUnit(
      List<String> allergenCategories) {
    final List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < allergenCategories.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(allergenCategories.elementAt(i)),
        value: allergenCategories.elementAt(i),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItemsForFrequency(
      List<String> allergenCategories) {
    final List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < allergenCategories.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(allergenCategories.elementAt(i)),
        value: allergenCategories.elementAt(i),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientMedicationViewModel>(
        model: model,
        builder: (context, model, child) => Container(
                /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              backgroundColor: colorF6F6FF,*/
                child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Text(
                  'My Medication',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                iconTheme: IconThemeData(color: Colors.black),
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
              body: addOrEditMedicationDialog(context),
            )));
  }

  addOrEditMedicationDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _drugName(),
                const SizedBox(
                  height: 16,
                ),
                _drugFrequency(),
                const SizedBox(
                  height: 16,
                ),
                if (_frequencyUnit == '')
                  Container()
                else
                  _frequencyUnit == 'Daily'
                      ? _drugTimeScheduledCheck()
                      : Container(),
                _drugDuration(),
                const SizedBox(
                  height: 16,
                ),
                _drugUnit(),
                const SizedBox(
                  height: 16,
                ),
                _startDate(),
                const SizedBox(
                  height: 16,
                ),
                _entryInstructionField(),
                const SizedBox(
                  height: 16,
                ),
                _makeMedicationStockImageGridView(),
                const SizedBox(
                  height: 32,
                ),
                if (model.busy)
                  Center(child: CircularProgressIndicator())
                else
                  _submitButton(context),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ],
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
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w700)),
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
                    itemBuilder: (context, suggestion) {
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
                    onSuggestionSelected: (suggestion) {
                      debugPrint(suggestion);
                      _typeAheadController.text = suggestion;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
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
                    label: 'Add new drug',
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
              Container(
                padding: const EdgeInsets.all(0.0),
                height: 40.0,
                width: 40.0,
                child: Center(
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
            ],
          ),
        )
      ],
    );
  }

  Widget _drugUnit() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Unit',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w700)),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 100,
              height: 48,
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                  color: Colors.white),
              child: Semantics(
                label: 'units',
                child: TextFormField(
                    controller: _unitController,
                    maxLines: 1,
                    focusNode: _unitFocus,
                    enabled: true,
                    enableInteractiveSelection: false,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: primaryColor),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[\\,|\\+|\\-]')),
                    ],
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: primaryColor),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 14, top: 11, right: 0),
                    )),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: primaryColor, width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Select Unit',
                  button: true,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _dosageUnit == '' ? null : _dosageUnit,
                    items: _dosageUnitMenuItems,
                    hint: Text('Select Unit'),
                    onChanged: (data) {
                      _unitFocus.unfocus();
                      FocusScope.of(context).requestFocus(FocusNode());
                      debugPrint(data);
                      setState(() {
                        _dosageUnit = data;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _drugFrequency() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frequency',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w700)),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: primaryColor, width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Frequency of medicine',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _frequencyUnit == '' ? null : _frequencyUnit,
                    items: _frequencyUnitMenuItems,
                    hint: Text('Select Frequency'),
                    onChanged: (data) {
                      debugPrint(data);
                      setState(() {
                        _frequencyUnit = data;
                      });
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _drugDuration() {
    debugPrint(_frequencyUnit);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Duration',
            style: TextStyle(
                fontSize: 18.0, color: textBlack, fontWeight: FontWeight.w500),
            children: <TextSpan>[
              TextSpan(
                  text: ' ' + _frequencyUnit == ''
                      ? ''
                      : _frequencyUnit == 'Weekly'
                          ? ' (number of weeks)'
                          : _frequencyUnit == 'Monthly'
                              ? ' (number of months)'
                              : _frequencyUnit == 'Daily'
                                  ? ' (number of days)'
                                  : '',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        /*Text('Duration'+_frequencyUnit == 'Daily' ? ' (in days)',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w700)),*/
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.white),
                child: Semantics(
                  label: 'Duration of dose',
                  child: TextFormField(
                      controller: _durationController,
                      maxLines: 1,
                      enabled: true,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: primaryColor),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp('[\\,|\\+|\\-]')),
                      ],
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: primaryColor),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 14, top: 11, right: 0),
                      )),
                ),
              ),
            ),
            /*const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: primaryColor, width: 0.80),
                    color: Colors.white),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _durationUnit == "" ? null : _durationUnit,
                  items: _durationUnitMenuItems,
                  hint: new Text("Select Duration"),
                  onChanged: (data) {
                    debugPrint(data);
                    setState(() {
                      _durationUnit = data;
                    });
                  },
                ),
              ),
            ),*/
          ],
        )
      ],
    );
  }

  Widget _makeMedicationStockImageGridView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'select shape and size of the medicine',
          readOnly: true,
          child: Text('How does it look?',
              style: TextStyle(
                  fontSize: 16.0,
                  color: textBlack,
                  fontWeight: FontWeight.w700)),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          child: medicationStockImagesList.isEmpty
              ? Container()
              : GridView.builder(
                  itemCount: medicationStockImagesList.length,
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 16 / 16),
                  itemBuilder: (BuildContext context, int index) =>
                      _makeImageSlot(context, index)),
        ),
      ],
    );
  }

  _makeImageSlot(BuildContext context, int index) {
    final MedicationStockImages images =
        medicationStockImagesList.elementAt(index);

    Color selcetedColor = Colors.white;
    //debugPrint("isAvailable ${slot.isAvailable} isSelected ${slot.isSelected}, Time Slot ${slot.slotStart.substring(0,5)+" - "+slot.slotEnd.substring(0,5)}");
    if (images.isSelected) {
      selcetedColor = Colors.green;
    } else {
      selcetedColor = Colors.white;
    }

    debugPrint(
        'Medication Name ==> ${images.code.replaceAll(new RegExp("[0-9]"), "").replaceAll('_', ' ').trimLeft()}');

    return Semantics(
      label: images.code
          .replaceAll(new RegExp("[0-9]"), "")
          .replaceAll('_', ' ')
          .trimLeft(),
      image: true,
      child: InkWell(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: selcetedColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Container(
            child: Stack(
              children: [
                Center(
                    child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CachedNetworkImage(
                    imageUrl: images.publicUrl,
                  ),
                )),
                if (images.isSelected)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(
                          color: Colors.green,
                          width: 1.0,
                        ),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(6)),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Container(),
              ],
            ),
          ),
        ),
        onTap: () {
          selectStockImage(index);
          //selectTimeSlot(index);
        },
      ),
    );
  }

  selectStockImage(int index) {
    debugPrint('index click $index');
    for (int i = 0; i < medicationStockImagesList.length; i++) {
      if (i == index) {
        medicationStockImagesList.elementAt(i).isSelected = true;
        medcationResourceId = medicationStockImagesList.elementAt(i).resourceId;
      } else {
        medicationStockImagesList.elementAt(i).isSelected = false;
      }
    }
    setState(() {});
  }

  Widget _startDate() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Start On',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w700)),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Semantics(
                label: 'startOn',
                child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48.0,
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        color: primaryColor,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              startOn,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                              height: 32,
                              width: 32,
                              child: Image.asset('res/images/ic_calender.png')),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now().subtract(Duration(days: 1)),
                        onChanged: (date) {
                          debugPrint('change $date');
                    }, onConfirm: (date) {
                          setState(() {
                        final List<String> dateArra =
                            date.toString().split(' ');
                        startOn = dateArra.elementAt(0);
                        debugPrint(startOn);
                      });
                      debugPrint('confirm $date');
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 160,
          height: 40,
          child: Semantics(
            label: 'Save',
            child:
                /*RaisedButton(
              onPressed: () {
                if (_typeAheadController.text == '') {
                  showToast('Please select drug', context);
                } else if (_unitController == '') {
                  showToast('Please enter unit qty', context);
                } else if (_dosageUnit == '') {
                  showToast('Please Select dosage unit', context);
                } else if (_frequencyUnit == '') {
                  showToast('Please select frequency', context);
                }
                */ /* else if(_frequencyUnit ? "Daily" : ){

                } */ /*
                else if (_durationController.text == '') {
                  showToast('Please enter duration', context);
                } else if (startOn == '') {
                  showToast('Please select start date', context);
                }
                */ /*else if (_durationController.text == "") {
                  showToast("Please enter comment");
                } */ /*
                else {
                  _addPatientMedication(context);
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0))),
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              color: primaryColor,
            )*/
                ElevatedButton(
                    child: Text("Save",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(primaryLightColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: BorderSide(color: primaryColor)))),
                    onPressed: () {
                      int frequency = 0;

                      if (_frequencyUnit == 'Daily') {
                        if (morningCheck) {
                          frequency = frequency + 1;
                        }
                        if (afternoonCheck) {
                          frequency = frequency + 1;
                        }
                        if (eveningCheck) {
                          frequency = frequency + 1;
                        }
                        if (nightCheck) {
                          frequency = frequency + 1;
                        }
                      }
                      if (_typeAheadController.text == '') {
                        showToast('Please select drug', context);
                      } else if (_frequencyUnit == '') {
                        showToast('Please select frequency', context);
                      } else if (_frequencyUnit == 'Daily' && frequency == 0) {
                        showToast('Please select daily time schedule', context);
                      } else if (_durationController.text == '') {
                        showToast('Please enter duration', context);
                      } else if (_unitController.text == '') {
                        showToast('Please enter unit qty', context);
                      } else if (_dosageUnit == '') {
                        showToast('Please Select dosage unit', context);
                      } else if (startOn == '') {
                        showToast('Please select start date', context);
                      } else {
                        _addPatientMedication(context);
                      }
                    }),
          ),
        ),
      ],
    );
  }

  /*Widget _textFeilds(String hint, TextEditingController editingController, FocusNode focusNode, FocusNode nextFocusNode){
    return TextFormField(
      controller: editingController,
      focusNode: focusNode,
      textAlign: TextAlign.left,
      textInputAction: nextFocusNode == _obstetricHistoryFocus ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: (term){
        _fieldFocusChange(context, focusNode, nextFocusNode);
      },
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }*/

  Widget _entryInstructionField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Additional Comments',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w700)),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.white),
                child: TextFormField(
                    controller: _instructionController,
                    focusNode: _instructionFocus,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    enabled: true,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: primaryColor),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: primaryColor),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 14, top: 11, right: 0),
                    )),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _drugTimeScheduledCheck() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Time Scheduled',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w700)),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Checkbox(
                    value: morningCheck,
                    onChanged: (newValue) {
                      setState(() {
                        morningCheck = newValue;
                      });
                    }, //  <-- leading Checkbox
                  ),
                ),
                Text('Morning',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: textBlack,
                        fontWeight: FontWeight.w700))
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Checkbox(
                    value: afternoonCheck,
                    onChanged: (newValue) {
                      setState(() {
                        afternoonCheck = newValue;
                      });
                    }, //  <-- leading Checkbox
                  ),
                ),
                Text('Afternoon',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: textBlack,
                        fontWeight: FontWeight.w700))
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Checkbox(
                    value: eveningCheck,
                    onChanged: (newValue) {
                      setState(() {
                        eveningCheck = newValue;
                      });
                    }, //  <-- leading Checkbox
                  ),
                ),
                Text('Evening',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: textBlack,
                        fontWeight: FontWeight.w700))
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Checkbox(
                    value: nightCheck,
                    onChanged: (newValue) {
                      setState(() {
                        nightCheck = newValue;
                      });
                    }, //  <-- leading Checkbox
                  ),
                ),
                Text('Night',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: textBlack,
                        fontWeight: FontWeight.w700))
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }


  List<String> getDrugsSuggestions(String query) {
    final List<String> matches = [];
    matches.addAll(drugsList);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  _getDrugsByName() async {
    try {
      setState(() {
        searchForDrug = true;
      });
      final DrugsLibraryPojo baseResponse =
          await model.getDrugsByKeyword(_typeAheadController.text);

      if (baseResponse.status == 'success') {
        setState(() {
          searchForDrug = false;
        });
        drugs.clear();
        setState(() {
          drugs.addAll(baseResponse.data.drugs.items);
        });
        _sortDrugs();
      } else {
        setState(() {
          searchForDrug = false;
        });
        showToast('Please try again', context);
      }
    } catch (CustomException) {
      setState(() {
        searchForDrug = false;
      });
      debugPrint('Error ' + CustomException.toString());
    }
  }

  _sortDrugs() {
    drugsList.clear();
    for (int i = 0; i < drugs.length; i++) {
      drugsList.add(drugs.elementAt(i).drugName);
    }
  }

  _addPatientMedication(BuildContext context) async {
    try {
      final timeShedule = <String>[];
      int frequency = 0;

      if (_frequencyUnit == 'Daily') {
        if (morningCheck) {
          frequency = frequency + 1;
          timeShedule.add('Morning');
        }
        if (afternoonCheck) {
          frequency = frequency + 1;
          timeShedule.add('Afternoon');
        }
        if (eveningCheck) {
          frequency = frequency + 1;
          timeShedule.add('Evening');
        }
        if (nightCheck) {
          frequency = frequency + 1;
          timeShedule.add('Night');
        }
      } else {
        frequency = frequency + 1;
        //timeShedule = _timeScheduledController.text;
        timeShedule.add('Afternoon');
      }

      String durationUnitValue = '';

      if (_frequencyUnit == 'Daily') {
        durationUnitValue = 'Days';
      } else if (_frequencyUnit == 'Monthly') {
        durationUnitValue = 'Months';
      } else if (_frequencyUnit == 'Weekly') {
        durationUnitValue = 'Weeks';
      }

      final map = <String, dynamic>{};
      //map["DrugOrderId"] = widget._visitInformation.drugOrderId;
      map['PatientUserId'] = patientUserId;
      //map["DoctorUserId"] = doctorUserId;
      //map["VisitId"] = widget._visitInformation.visitInfo.id;
      map['DrugName'] = _typeAheadController.text;
      map['Dose'] = int.parse(_unitController.text);
      map['DosageUnit'] = _dosageUnit;
      map['TimeSchedules'] = timeShedule;
      map['Frequency'] = frequency;
      map['FrequencyUnit'] = _frequencyUnit;
      map['Route'] = ' ';
      map['Duration'] = int.parse(_durationController.text);
      map['DurationUnit'] = durationUnitValue;
      map['StartDate'] = startOn;
      map['RefillNeeded'] = false;
      map['Instructions'] = _instructionController.text;
      map['ImageResourceId'] = medcationResourceId;

      final BaseResponse baseResponse = await model.addMedicationforVisit(map);

      if (baseResponse.status == 'success') {
        //widget._submitButtonListner();
        Navigator.of(context).pop();
        //_getPatientAllergies("4c47a191-9cb6-4377-b828-83eb9ab48d0a");
      } else {
        showToast('Please try again', context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }

  Future _addDrugConfirmDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to add ' +
              _typeAheadController.text.toString() +
              ' to drug library.'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _addDrugTolibrary();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  _addDrugTolibrary() async {
    try {
      FocusScope.of(context).unfocus();
      final map = <String, String>{};
      map['DrugName'] = _typeAheadController.text;

      final BaseResponse baseResponse = await model.addDrugToLibrary(map);

      if (baseResponse.status == 'success') {
        FocusScope.of(context).unfocus();
        showToast(baseResponse.message, context);
      } else {
        showToast('Please try again', context);
      }
    } catch (CustomException) {
      debugPrint('Error ' + CustomException.toString());
    }
  }

  _getMedicaionStockImages() async {
    try {
      final GetMedicationStockImages getMedicationStockImages =
          await model.getMedicationStockImages();
      if (getMedicationStockImages.status == 'success') {
        medicationStockImagesList.clear();
        medicationStockImagesList
            .addAll(getMedicationStockImages.data.medicationStockImages);
        setState(() {});
      } else {
        showToast('Please try again', context);
      }
    } catch (CustomException) {
      debugPrint('Error ' + CustomException.toString());
    }
  }
}
