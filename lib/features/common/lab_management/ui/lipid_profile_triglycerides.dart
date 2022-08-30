import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/lab_management/models/lipid_profile_history_response.dart';
import 'package:patient/features/common/lab_management/view_models/patients_lipid_profile.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/get_health_data.dart';
import 'package:patient/infra/utils/simple_time_series_chart.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

//ignore: must_be_immutable
class LipidProfileTriglyceridesView extends StatefulWidget {
  bool allUIViewsVisible = false;

  LipidProfileTriglyceridesView(bool allUIViewsVisible) {
    this.allUIViewsVisible = allUIViewsVisible;
  }

  @override
  _LipidProfileTriglyceridesViewState createState() =>
      _LipidProfileTriglyceridesViewState();
}

class _LipidProfileTriglyceridesViewState
    extends State<LipidProfileTriglyceridesView> {
  var model = PatientLipidProfileViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  final _controller = TextEditingController();
  List<Items> records = <Items>[];
  var dateFormatStandard = DateFormat('MMM dd, yyyy');
  late ProgressDialog progressDialog;
  GetHealthData getHealthData = GetIt.instance<GetHealthData>();

  @override
  void initState() {
    getVitalsHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientLipidProfileViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: widget.allUIViewsVisible
            ? Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  title: Text(
                    'Triglycerides',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: primaryColor,
                        fontWeight: FontWeight.w600),
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
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 16,
                        ),
                        _feilds(),
                        const SizedBox(
                          height: 16,
                        ),
                        _historyListFeilds(),
                        const SizedBox(
                          height: 16,
                        ),
                        if (records.isEmpty) Container() else graph(),
                        //allGoal(),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _historyListFeilds(),
                    const SizedBox(
                      height: 16,
                    ),
                    if (records.isEmpty) Container() else graph(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _feilds() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter your triglycerides:',
                style: TextStyle(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 8,
              ),
              InfoScreen(
                  tittle: 'Triglycerides Information',
                  description:
                      'Triglycerides are the most common type of fat in your body. They come from food, and your body also makes them.\n\nNormal triglyceride levels vary by age and sex.',
                  height: 240),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: textGrey, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'Triglycerides measures in mg/dl',
                    child: TextFormField(
                        controller: _controller,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (term) {},
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        decoration: InputDecoration(
                            //hintText: '(65 to 95)',
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: '    mg/dl    ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textBlack,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ]),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Semantics(
              label: "Save",
              button: true,
              child: InkWell(
                onTap: () {
                  if (_controller.text.toString().isEmpty) {
                    showToast('Please enter your total triglycerides', context);
                  } else {
                    addvitals();
                  }
                },
                child: ExcludeSemantics(
                  child: Container(
                      height: 40,
                      width: 120,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: primaryColor, width: 1),
                        color: primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyListFeilds() {
    return Container(
      color: colorF6F6FF,
      constraints: BoxConstraints(
          minHeight: 160, minWidth: double.infinity, maxHeight: 200),
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 16),
      //height: 160,
      child: model.busy
          ? Center(
        child: CircularProgressIndicator(),
      )
          : (records.isEmpty
          ? noHistoryFound()
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Ratio\n%',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ExcludeSemantics(
                    child: SizedBox(
                      height: 32,
                      width: 32,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                    itemBuilder: (context, index) =>
                        _makeList(context, index),
                    separatorBuilder:
                        (BuildContext context, int index) {
                      return SizedBox(
                        height: 0,
                      );
                    },
                    itemCount: records.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget noHistoryFound() {
    return Center(
      child: Text('No vital history found',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget _makeList(BuildContext context, int index) {
    final Items record = records.elementAt(index);
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: colorF6F6FF,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                dateFormatStandard.format(DateTime.parse(record.recordedAt!)),
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Semantics(
                label: 'Triglyceride ',
                child: Text(
                  record.primaryValue.toString(),
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  ConfirmationBottomSheet(
                      context: context,
                      height: 180,
                      onPositiveButtonClickListner: () {
                        //debugPrint('Positive Button Click');
                        deleteVitals(record.id.toString());
                      },
                      onNegativeButtonClickListner: () {
                        //debugPrint('Negative Button Click');
                      },
                      question: 'Are you sure you want to delete this record?',
                      tittle: 'Alert!');
                },
                icon: Icon(
                  Icons.delete_rounded,
                  color: primaryColor,
                  size: 24,
                  semanticLabel: 'Triglyceride Delete',
                ))
          ],
        ),
      ),
    );
  }

  Widget graph() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Semantics(
        label: 'making graph of ',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [primaryLightColor, colorF6F6FF]),
                  border: Border.all(color: primaryLightColor),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              padding: const EdgeInsets.all(16),
              height: 200,
              child: Center(
                child: SimpleTimeSeriesChart(_createSampleData()),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Triglycerides',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final List<TimeSeriesSales> data = <TimeSeriesSales>[];
    /*[
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];*/

    for (int i = 0; i < records.length; i++) {
      data.add(TimeSeriesSales(
          DateTime.parse(records.elementAt(i).recordedAt!).toLocal(),
          double.parse(records.elementAt(i).primaryValue.toString())));
    }

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'HDL',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  Widget allGoal() {
    return MergeSemantics(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              color: primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  ImageIcon(
                    AssetImage('res/images/ic_dart_goal.png'),
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Your progress with goals',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Initial',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '85',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Target',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '65',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Latest',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '74',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      height: 10,
                      color: primaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 10,
                      color: primaryLightColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  addvitals() async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');
      final map = <String, dynamic>{};
      map['TypeName'] = 'Cholesterol';
      map['DisplayName'] = 'Triglyceride Level';
      map['PrimaryValue'] = _controller.text.toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "%";
      //map['RecordedByUserId'] = null;

      final BaseResponse baseResponse = await model.addlipidProfile(map);

      if (baseResponse.status == 'success') {
        progressDialog.close();
        showToast(baseResponse.message!, context);
        _controller.clear();
        //Navigator.pop(context);
        getVitalsHistory();
        model.setBusy(true);
      } else {
        progressDialog.close();
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  getVitalsHistory() async {
    try {
      final LipidProfileHistoryResponse lipidProfileHistoryResponse =
      await model.getLabRecordHistory('Triglyceride Level');
      if (lipidProfileHistoryResponse.status == 'success') {
        records.clear();
        records.addAll(lipidProfileHistoryResponse.data!.labRecordRecords!.items!.toList());
      } else {
        showToast(lipidProfileHistoryResponse.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  deleteVitals(String recordId) async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');

      final BaseResponse baseResponse =
      await model.deleteLabRecord(recordId);

      if (baseResponse.status == 'success') {
        if (progressDialog.isOpen()) {
          progressDialog.close();
        }
        showToast(baseResponse.message!, context);
        //Navigator.pop(context);
        getVitalsHistory();
        model.setBusy(true);
      } else {
        progressDialog.close();
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
