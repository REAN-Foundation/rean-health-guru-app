import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetAllRecordResponse.dart';
import 'package:paitent/core/models/GetSharablePublicLink.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/models/UploadImageResponse.dart';
import 'package:paitent/core/viewmodels/views/common_config_model.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/ImageViewer.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/ui/views/home_view.dart';
import 'package:paitent/ui/views/pdfViewer.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:share/share.dart';

class MyReportsView extends StatefulWidget {
  @override
  _MyReportsViewState createState() => _MyReportsViewState();
}

class _MyReportsViewState extends State<MyReportsView> {
  var model = CommonConfigModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;
  String attachmentPath = "";
  List<Documents> documents = new List<Documents>();
  var dateFormat = DateFormat("dd MMM, yyyy");
  var renameControler = TextEditingController();
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  ImagePicker _picker = new ImagePicker();

  @override
  void initState() {
    getAllRecords();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(50.0);
      }
      //write or call your logic
      //code will run when widget rendering complete
    });
    super.initState();
  }

  getAllRecords() async {
    try {
      GetAllRecordResponse allRecordResponse = await model.getAllRecords();
      debugPrint("Records ==> ${allRecordResponse.toJson()}");
      if (allRecordResponse.status == 'success') {
        documents.clear();
        if (allRecordResponse.data.documents.length > 0) {
          documents.clear();
          documents.addAll(allRecordResponse.data.documents);
        }
        //showToast(startCarePlanResponse.message);
      } else {
        //showToast(startCarePlanResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  getDocumentPublicLink(Documents document, bool imageView) async {
    try {
      if (!imageView) {
        progressDialog.show();
      }
      GetSharablePublicLink getSharablePublicLink =
          await model.getDocumentPublicLink(document.id);
      debugPrint("Records ==> ${getSharablePublicLink.toJson()}");
      if (getSharablePublicLink.status == 'success') {
        progressDialog.hide();
        if (imageView) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageViewer(
                      getSharablePublicLink.data.link, document.fileName)));
        } else {
          progressDialog.hide();
          urlFileShare(getSharablePublicLink.data.link);
        }
        //showToast(startCarePlanResponse.message);
      } else {
        progressDialog.hide();
        showToast(getSharablePublicLink.message);
      }
    } catch (CustomException) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      progressDialog.hide();
      debugPrint(Exception.toString());
    }
  }

  renameDocument(String documentId, String newName) async {
    try {
      var body = new Map<String, String>();
      body['NewName'] = newName;

      BaseResponse baseResponse =
          await model.renameOfDocument(documentId, body);
      debugPrint("Records ==> ${baseResponse.toJson()}");
      if (baseResponse.status == 'success') {
        getAllRecords();
        showToast('Document renamed successfully.');
      } else {
        showToast(baseResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  deleteDocument(String documentId) async {
    try {
      BaseResponse baseResponse = await model.deleteDocument(documentId);
      debugPrint("Records ==> ${baseResponse.toJson()}");
      if (baseResponse.status == 'success') {
        getAllRecords();
        showToast(baseResponse.message);
      } else {
        showToast(baseResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context);

    // TODO: implement build
    return BaseWidget<CommonConfigModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          /*appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Text(
                  'My '+wi,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                iconTheme: new IconThemeData(color: Colors.black),
                actions: <Widget>[
                  */ /*IconButton(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 32.0,
                ),
                onPressed: () {
                  debugPrint("Clicked on profile icon");
                },
              )*/ /*
                ],
              ),*/
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                uploadWidget(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Records",
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat')),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: model.busy
                          ? Center(child: CircularProgressIndicator())
                          : documents.length == 0
                              ? noRecordsFound()
                              : listWidget()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noRecordsFound() {
    return Center(
      child: Text("No records found",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: Colors.deepPurple)),
    );
  }

  Widget uploadWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton.icon(
          onPressed: () async {
            /*String type = await _askForDocsType();
            debugPrint('File Type ${type}');
            if (type != null) {
              getFile(type);
            } else {
              showToast('Please select document type');
            }*/

            showMaterialModalBottomSheet(
                isDismissible: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                context: context,
                builder: (context) => _uploadImageSelector());

          },
          icon: Icon(
            Icons.file_upload,
            color: Colors.white,
            size: 24,
          ),
          label: Text(
            'Upload new records',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w700),
          ),
          color: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: primaryColor)),
        ),
      ],
    );
  }

  Widget listWidget() {
    return Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: ListView.separated(
          itemBuilder: (context, index) => _myReports(context, index),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8,
            );
          },
          itemCount: documents.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true),
    );
  }

  Widget _myReports(BuildContext context, int index) {
    Documents document = documents.elementAt(index);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: InkWell(
        onTap: () {
          progressDialog.show();
          //showToast(document.mimeType);
          if (document.mimeType.contains('pdf')) {
            //createFileOfPdfUrl(document.urlAuth, document.fileName);
            createFileOfPdfUrl(document.urlAuth, document.fileName).then((f) {
              progressDialog.hide();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PDFScreen(f.path)));
            });
          } else if (document.mimeType.contains('image')) {
            createFileOfPdfUrl(document.urlAuth, document.fileName).then((f) {
              progressDialog.hide();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ImageViewer(f.path, document.fileName)));
            });

            //getDocumentPublicLink(document, true);

          } else {
            showToast('Opps, something wents wrong!');
          }
        },
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8.0),
          decoration: new BoxDecoration(
              color: colorF6F6FF,
              border: Border.all(color: primaryLightColor),
              borderRadius: new BorderRadius.all(Radius.circular(4.0))),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(document.displayId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: textBlack)),
                      Text(dateFormat.format(document.createdAt.toLocal()),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: textBlack)),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(document.fileName,
                        semanticsLabel: document.fileName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textBlack)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Semantics(
                        child: InkWell(
                            onTap: () {
                              _renameDialog(document);
                            },
                            child: Container(
                              height: 30,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text('Rename',
                                      semanticsLabel: 'rename',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor)),
                                ],
                              ),
                            )),
                      ),
                      Container(
                        height: 12,
                        width: 1,
                        color: Colors.deepPurple,
                      ),
                      Semantics(
                        child: InkWell(
                            onTap: () {
                              _removeConfirmation(document);
                            },
                            child: Container(
                              height: 30,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_forever,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text('Delete',
                                      semanticsLabel: 'delete',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor)),
                                ],
                              ),
                            )),
                      ),
                      Container(
                        height: 12,
                        width: 1,
                        color: Colors.deepPurple,
                      ),
                      Semantics(
                        child: InkWell(
                            onTap: () {
                              if (document.mimeType != null) {
                                getDocumentPublicLink(document, false);
                              } else {
                                showToast('Opps, something wents wrong!');
                              }
                            },
                            child: Container(
                              height: 30,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text('Share',
                                      semanticsLabel: 'share',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor)),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [

  ],
  )*/

  Future<Null> urlFileShare(String shareLink) async {
    final RenderBox box = _scaffoldKey.currentContext.findRenderObject();
    if (Platform.isAndroid) {
      /*  var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;*/
      //File imgFile = new File(pathPDF);
      /*imgFile.writeAsBytesSync(response.bodyBytes);*/
      Share.share(shareLink,
          subject: 'Hello, check your shared file.',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share(shareLink,
          subject: 'Hello, check your shared file.',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  Future<File> createFileOfPdfUrl(String url, String fileName) async {
    debugPrint('Base Url ==> url');
    //final url = "http://africau.edu/images/default/sample.pdf";
    //final url = "https://www.lalpathlabs.com/SampleReports/Z614.pdf";
    //final filename = url.substring(url.lastIndexOf("/") + 1);
    var map = new Map<String, String>();
    //map["enc"] = "multipart/form-data";
    map["Authorization"] = 'Bearer ' + auth;

    var request = await HttpClient().getUrl(Uri.parse(url));
    request.headers.add("Authorization", 'Bearer ' + auth);
    var response = await request.close();

    debugPrint('Base Url ==> PUT ${request.uri}');
    debugPrint('Headers ==> ${request.headers.toString()}');

    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future getFile(String type) async {
    String result;
    try {
      result = await FlutterDocumentPicker.openDocument();
      debugPrint('File Result ==> ${result}');

      if (result != '') {
        File file = File(result);
        debugPrint(result);
        String fileName = file.path.split('/').last;
        print("File Name ==> ${fileName}");
        uploadProfilePicture(file, type);
      } else {
        showToast('Please select document');
      }
    } catch (e) {
      showToast('Please select document');
      print(e);
      result = 'Error: $e';
    }
  }

  /*Future getImage() async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      debugPrint(pickedFile.path);
      listFiles.add(pickedFile.path.toString());
      uploadFileProcess = true;
      //setTimerForProgress();
      uploadProfilePicture(_image, type);
    });
  }*/

  List<String> documentType = [
    'Medical Prescription',
    'Lab Prescription',
    'Lab Report',
    'Doctor Notes'
  ];

  Future<String> _askForDocsType() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please select document type'),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: documentType.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(documentType[index]),
                    onTap: () {
                      debugPrint("Document Type ==> ${documentType[index]}");
                      String documentTypeCode = "";
                      switch (index) {
                        case 0:
                          documentTypeCode = 'PATIENT_MED_PRESCRIPTIONS';
                          break;
                        case 1:
                          documentTypeCode = 'PATIENT_LAB_PRESCRIPTIONS';
                          break;
                        case 2:
                          documentTypeCode = 'PATIENT_LAB_REPORTS';
                          break;
                        case 3:
                          documentTypeCode = 'DOCTOR_NOTES';
                          break;
                      }

                      Navigator.pop(context, documentTypeCode);
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  uploadProfilePicture(File file, String type) async {
    progressDialog.show();
    try {
      var map = new Map<String, String>();
      map["enc"] = "multipart/form-data";
      map["Authorization"] = 'Bearer ' + auth;

      String _baseUrl = apiProvider.getBaseUrl();

      var postUri = Uri.parse(
          _baseUrl + "/patient/" + patientUserId + "/upload-document");
      var request = new http.MultipartRequest("POST", postUri);
      request.headers.addAll(map);
      request.files.add(http.MultipartFile(
          'name', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
      //request.files.add(new http.MultipartFile.fromBytes('name', await file.readAsBytes()), fileName);
      request.fields['DocumentType'] = type;

      request.send().then((response) async {
        if (response.statusCode == 200) {
          progressDialog.hide();
          print("Uploaded!");
          final respStr = await response.stream.bytesToString();
          debugPrint("Uploded " + respStr);
          GetAllRecordResponse uploadResponse =
              GetAllRecordResponse.fromJson(json.decode(respStr));
          if (uploadResponse.status == "success") {
            getAllRecords();
            showToast(uploadResponse.message);
          } else {
            showToast('Opps, something wents wrong!');
          }
        } else {
          progressDialog.hide();
          showToast('Opps, something wents wrong!');
          print("Upload Faild !");
        }
      }); // debugPrint("3");

    } catch (CustomException) {
      progressDialog.hide();
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    }
  }

  _removeConfirmation(Documents document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "Alert!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
                color: Colors.black),
          ),
          contentPadding: EdgeInsets.all(4.0),
          subtitle: Text(
            '\nAre you sure you want to delete this record?',
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 14.0,
                color: Colors.black),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              deleteDocument(document.id);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  _renameDialog(Documents document) async {
    renameControler.text = document.fileName;
    renameControler.selection = TextSelection.fromPosition(
      TextPosition(offset: renameControler.text.length - 4),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Semantics(
            label: 'renameText',
            child: new TextField(
              controller: renameControler,
              autofocus: true,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                  color: Colors.black),
              decoration: new InputDecoration(
                  labelText: 'Enter new file name', hintText: ''),
            ),
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              }),
          new FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                if(document.fileName == renameControler.text){
                  showToast('Document renamed successfully ');
                  Navigator.of(context, rootNavigator: true).pop();
                }else {
                  renameDocument(document.id, renameControler.text);
                  Navigator.of(context, rootNavigator: true).pop();
                }
              })
        ],
      ),
    );
  }

  Widget _uploadImageSelector() {
    return Container(
      height: 160,
      color: Colors.transparent,
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius:
          new BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              label: 'Camera',
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                  openCamera();
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: new BoxDecoration(
                          color: primaryLightColor,
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: Colors.deepPurple,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.camera_alt, color: Colors.deepPurple, size: 24,),
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text('Camera', style: TextStyle(fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ),
            Semantics(
              label: 'Gallery',
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                  openGallery();
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: new BoxDecoration(
                          color: primaryLightColor,
                          borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: Colors.deepPurple,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.image, color: Colors.deepPurple, size: 24,),
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text('Gallery', style: TextStyle(fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ),
            /*Semantics(
              label: 'Cancel',
              child: InkWell(
                onTap: (){

                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: new BoxDecoration(
                          color: primaryLightColor,
                          borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: Colors.deepPurple,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.close, color: Colors.deepPurple, size: 24,),
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text('Cancel', style: TextStyle(fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  openGallery() async {
    String type = await _askForDocsType();
    debugPrint('File Type ${type}');
    if (type != null) {
      getFile(type);
    } else {
      showToast('Please select document type');
    }
  }

  openCamera() async {
    String type = await _askForDocsType();
    debugPrint('File Type ${type}');

    var picture = await _picker.getImage(
      source: ImageSource.camera,
    );
    File file = File(picture.path);
    debugPrint(picture.path);
    String fileName = file.path.split('/').last;
    print("File Name ==> ${fileName}");
    uploadProfilePicture(file, type);
  }

}

/*setTimerForProgress(){
    Timer timerM =  new Timer.periodic(new Duration(seconds: 6), (time) {
      print('Something');
      setState(() {
        uploadFileProcess = false;
      });
      time.cancel();
    });
  }*/
