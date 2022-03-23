import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paitent/features/misc/models/BaseResponse.dart';
import 'package:paitent/features/misc/models/GetAllRecordResponse.dart';
import 'package:paitent/features/misc/models/GetSharablePublicLink.dart';
import 'package:paitent/features/misc/models/UploadDocumentResponse.dart';
import 'package:paitent/features/misc/ui/ImageViewer.dart';
import 'package:paitent/features/misc/ui/base_widget.dart';
import 'package:paitent/features/misc/ui/pdfViewer.dart';
import 'package:paitent/features/misc/view_models/common_config_model.dart';
import 'package:paitent/infra/networking/ApiProvider.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';

class MyReportsView extends StatefulWidget {
  @override
  _MyReportsViewState createState() => _MyReportsViewState();
}

class _MyReportsViewState extends State<MyReportsView> {
  var model = CommonConfigModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;
  String attachmentPath = '';
  List<Items> documents = <Items>[];

  var dateFormat = DateFormat('MMM dd, yyyy');
  var renameControler = TextEditingController();
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  final ImagePicker _picker = ImagePicker();
  String _api_key = '';

  @override
  void initState() {
    _api_key = dotenv.env['Patient_API_KEY'];
    progressDialog = ProgressDialog(context, isDismissible: false);
    getAllRecords();
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
      final GetAllRecordResponse allRecordResponse =
          await model.getAllRecords();
      debugPrint('Records ==> ${allRecordResponse.toJson()}');
      if (allRecordResponse.status == 'success') {
        documents.clear();
        if (allRecordResponse.data.patientDocuments.items.isNotEmpty) {
          documents.clear();
          documents.addAll(allRecordResponse.data.patientDocuments.items);
        }
        //showToast(startCarePlanResponse.message);
      } else {
        //showToast(startCarePlanResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  getDocumentPublicLink(Items document, bool imageView) async {
    try {
      if (!imageView) {
        progressDialog.show();
      }
      final GetSharablePublicLink getSharablePublicLink =
          await model.getDocumentPublicLink(document.id);
      debugPrint('Records ==> ${getSharablePublicLink.toJson()}');
      if (getSharablePublicLink.status == 'success') {
        progressDialog.hide();
        if (imageView) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageViewer(
                      getSharablePublicLink.data.patientDocumentLink,
                      document.fileName)));
        } else {
          progressDialog.hide();
          urlFileShare(getSharablePublicLink.data.patientDocumentLink);
        }
        //showToast(startCarePlanResponse.message);
      } else {
        progressDialog.hide();
        showToast(getSharablePublicLink.message, context);
      }
    } catch (CustomException) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  renameDocument(String documentId, String newName) async {
    try {
      final body = <String, String>{};
      body['NewName'] = newName;

      final BaseResponse baseResponse =
          await model.renameOfDocument(documentId, body);
      debugPrint('Records ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        getAllRecords();
        showToast('Document renamed successfully.', context);
      } else {
        showToast(baseResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  deleteDocument(String documentId) async {
    try {
      final BaseResponse baseResponse = await model.deleteDocument(documentId);
      debugPrint('Records ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        getAllRecords();
        showToast(baseResponse.message, context);
      } else {
        showToast(baseResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      fontWeight: FontWeight.w600),
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
                  child: Text('Records',
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
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
                          : documents.isEmpty
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
      child: Text('No records found',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget uploadWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
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
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
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
                fontWeight: FontWeight.w600),
          ),
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(primaryLightColor),
              backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: primaryColor)))),
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
    final Items document = documents.elementAt(index);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: InkWell(
        onTap: () {
          progressDialog.show();
          //showToast(document.mimeType);
          if (document.mimeType.contains('pdf')) {
            //createFileOfPdfUrl(document.urlAuth, document.fileName);

            createFileOfPdfUrl(document.authenticatedUrl, document.fileName)
                .then((f) {
              progressDialog.hide();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PDFScreen(f.path)));
            });
          } else if (document.mimeType.contains('image')) {
            createFileOfPdfUrl(document.authenticatedUrl, document.fileName)
                .then((f) {
              progressDialog.hide();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ImageViewer(f.path, document.fileName)));
            });

            //getDocumentPublicLink(document, true);

          } else {
            showToast('Opps, something went wrong!', context);
          }
        },
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: colorF6F6FF,
              border: Border.all(color: primaryLightColor),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
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
                      Text(dateFormat.format(document.uploadedDate.toLocal()),
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
                            fontWeight: FontWeight.w600,
                            color: textBlack)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Semantics(
                        button: true,
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
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor)),
                                ],
                              ),
                            )),
                      ),
                      Container(
                        height: 12,
                        width: 1,
                        color: primaryColor,
                      ),
                      Semantics(
                        button: true,
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
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor)),
                                ],
                              ),
                            )),
                      ),
                      Container(
                        height: 12,
                        width: 1,
                        color: primaryColor,
                      ),
                      Semantics(
                        button: true,
                        child: InkWell(
                            onTap: () {
                              if (document.mimeType != null) {
                                getDocumentPublicLink(document, false);
                              } else {
                                showToast(
                                    'Opps, something went wrong!', context);
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
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
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

  urlFileShare(String shareLink) async {
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
    //debugPrint('Base Url ==> ${url}');
    //final url = "http://africau.edu/images/default/sample.pdf";
    //final url = "https://www.lalpathlabs.com/SampleReports/Z614.pdf";
    //final filename = url.substring(url.lastIndexOf("/") + 1);
    final map = <String, String>{};
    //map["enc"] = "multipart/form-data";
    map['Authorization'] = 'Bearer ' + auth;

    final request = await HttpClient().getUrl(Uri.parse(url));
    request.headers.add('Authorization', 'Bearer ' + auth);
    request.headers.add('x-api-key', _api_key);
    final response = await request.close();

    debugPrint('Base Url ==> ${request.uri}');
    debugPrint('Headers ==> ${request.headers.toString()}');

    final bytes = await consolidateHttpClientResponseBytes(response);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = File('$dir/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future getFile(String type) async {
    String result;
    try {
      final FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedMimeTypes: [
            'application/pdf',
            'application/docs',
            'application/ppt'
          ],
          allowedFileExtensions: [
            'pdf',
            'docs',
            'ppt'
          ]);

      result = await FlutterDocumentPicker.openDocument(params: params);
      debugPrint('File Result ==> $result');

      if (result != '') {
        final File file = File(result);
        debugPrint(result);
        final String fileName = file.path.split('/').last;
        debugPrint('File Name ==> $fileName');
        uploadProfilePicture(file, type);
      } else {
        showToast('Please select valid document', context);
      }
    } catch (e) {
      showToast('Please select correct document', context);
      debugPrint(e);
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
                      debugPrint('Document Type ==> ${documentType[index]}');
                      String documentTypeCode = '';
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
      final map = <String, String>{};
      map['enc'] = 'multipart/form-data';
      map['Authorization'] = 'Bearer ' + auth;
      map['x-api-key'] = _api_key;

      final String _baseUrl = apiProvider.getBaseUrl();

      final postUri = Uri.parse(_baseUrl + '/patient-documents/');
      final request = http.MultipartRequest('POST', postUri);
      request.headers.addAll(map);
      request.files.add(http.MultipartFile(
          'Name', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
      //request.files.add(new http.MultipartFile.fromBytes('name', await file.readAsBytes()), fileName);
      request.fields['DocumentType'] = type;
      request.fields['PatientUserId'] = patientUserId;

      debugPrint('Base Url ==> MultiPart ${request.url}');
      debugPrint('Request Body ==> ${json.encode(request.fields).toString()}');
      debugPrint('Headers ==> ${json.encode(request.headers).toString()}');

      request.send().then((response) async {
        if (response.statusCode == 201) {
          progressDialog.hide();
          debugPrint('Uploaded!');
          final respStr = await response.stream.bytesToString();
          debugPrint('Uploded ' + respStr);
          final UploadDocumentResponse uploadResponse =
              UploadDocumentResponse.fromJson(json.decode(respStr));
          if (uploadResponse.status == 'success') {
            getAllRecords();
            showToast(uploadResponse.message, context);
          } else {
            showToast('Opps, something went wrong!', context);
          }
        } else {
          final respStr = await response.stream.bytesToString();
          progressDialog.hide();
          showToast('Opps, something went wrong!', context);
          debugPrint('Upload Faild ! ==> $respStr');
        }
      }); // debugPrint("3");

    } catch (CustomException) {
      progressDialog.hide();
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  _removeConfirmation(Items document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            'Alert!',
            style: TextStyle(
                fontWeight: FontWeight.w600,
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
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
          TextButton(
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

  _renameDialog(Items document) async {
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
            child: TextField(
              controller: renameControler,
              autofocus: true,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                  color: Colors.black),
              decoration: InputDecoration(
                  labelText: 'Enter new file name', hintText: ''),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              }),
          TextButton(
              child: const Text('Ok'),
              onPressed: () {
                final String enteredFileName = renameControler.text;
                final String fileExtention = enteredFileName.split('.').last;
                final String newFileName =
                    renameControler.text.replaceAll('.' + fileExtention, '');

                debugPrint('New FileName ==> $newFileName');
                debugPrint('fileExtention ==> $fileExtention');
                debugPrint('enteredFileName ==> $enteredFileName');

                if (document.fileName == renameControler.text) {
                  showToastMsg('Document renamed successfully ', context);
                  Navigator.of(context, rootNavigator: true).pop();
                } else if (newFileName == '') {
                  showToastMsg('Please enter valid file name', context);
                } else {
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
      height: 180,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Camera',
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      openCamera();
                    },
                    child: Container(
                      child: ExcludeSemantics(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: primaryLightColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Camera',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Semantics(
                  label: 'Gallery',
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      openGallery();
                    },
                    child: Container(
                      child: ExcludeSemantics(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: primaryLightColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  color: primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Gallery',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Semantics(
                  label: 'Files',
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      final String type = await _askForDocsType();
                      debugPrint('File Type $type');
                      if (type != null) {
                        getFile(type);
                      } else {
                        showToast('Please select document type', context);
                      }
                    },
                    child: Container(
                      child: ExcludeSemantics(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: primaryLightColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.file_copy,
                                  color: primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Files',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Note: Files formats supported include  .docx, .pdf, .ppt.',
                  style: TextStyle(fontSize: 12, color: textGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  openGallery() async {
    final String type = await _askForDocsType();
    debugPrint('File Type $type');
    if (type != null) {
      final picture = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      final File file = File(picture.path);
      debugPrint(picture.path);
      final String fileName = file.path.split('/').last;
      debugPrint('File Name ==> $fileName');
      uploadProfilePicture(file, type);
    } else {
      showToast('Please select correct document type', context);
    }
  }

  openCamera() async {
    final String type = await _askForDocsType();
    debugPrint('File Type $type');

    final picture = await _picker.pickImage(
      source: ImageSource.camera,
    );
    final File file = File(picture.path);
    debugPrint(picture.path);
    final String fileName = file.path.split('/').last;
    debugPrint('File Name ==> $fileName');
    uploadProfilePicture(file, type);
  }
}

/*setTimerForProgress(){
    Timer timerM =  new Timer.periodic(new Duration(seconds: 6), (time) {
      debugPrint('Something');
      setState(() {
        uploadFileProcess = false;
      });
      time.cancel();
    });
  }*/
