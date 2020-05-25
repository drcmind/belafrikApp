import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PageAjoutDilemme extends StatefulWidget {
  @override
  _PageAjoutDilemmeState createState() => _PageAjoutDilemmeState();
}

class _PageAjoutDilemmeState extends State<PageAjoutDilemme> {

  static const nationalitEitems = <String>[
    'malienne', 'marocaine', 'mauritanienne', 'tunisienne', 'mauricienne',
    'nigérienne', 'centrafricaine', 'congolaise', 'togolaise', 'rwandaise'
  ];

  final List<DropdownMenuItem<String>> _dropdownNationalite = nationalitEitems
      .map(
          (String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      )
  ).toList();

  String nomBella1 = '';
  String nomBella2 = '';
  String urlImgB1, urlImgB2;
  String nationalitB1, nationalitB2;
  bool _enProcessus = false;
  File _fichierSelectionEB1;
  File _fichierSelectionEB2;

  final _formKey = GlobalKey<FormState>();

  Widget imageBella1() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _fichierSelectionEB1 != null
                ? GestureDetector(
              onTap: () {
                obtenirImageBella1(ImageSource.gallery);
              },
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                        image: FileImage(
                          _fichierSelectionEB1,
                        ))),
              ),
            )
                : GestureDetector(
              onTap: () {
                obtenirImageBella1(ImageSource.gallery);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.add_photo_alternate,
                        size: 100,
                        color: Colors.grey[700],
                      ),
                      Text('Photo bella 1',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: OutlineButton.icon(
                label: Text(
                  'Camera',
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  obtenirImageBella1(ImageSource.camera);
                },
                borderSide: BorderSide(color: Colors.white, width: 2),
                icon: Icon(Icons.add_a_photo, color: Colors.grey[700]),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageBella2() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _fichierSelectionEB2 != null
                ? GestureDetector(
              onTap: () {
                obtenirImageBella2(ImageSource.gallery);
              },
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                        image: FileImage(
                          _fichierSelectionEB2,
                        ))),
              ),
            )
                : GestureDetector(
              onTap: () {
                obtenirImageBella2(ImageSource.gallery);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.add_photo_alternate,
                        size: 100,
                        color: Colors.grey[700],
                      ),
                      Text('Photo bella 2',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: OutlineButton.icon(
                label: Text(
                  'Camera',
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  obtenirImageBella2(ImageSource.camera);
                },
                borderSide: BorderSide(color: Colors.white, width: 2),
                icon: Icon(Icons.add_a_photo, color: Colors.grey[700]),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  obtenirImageBella1(ImageSource source) async {
    setState(() => _enProcessus = true);
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      File croppE = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.png,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarTitle: 'Rognez l\'image',
          statusBarColor: Colors.white,
          backgroundColor: Colors.black
        )
      );
      this.setState((){
        _fichierSelectionEB1 = croppE;
        _enProcessus = false;
      });
    }else{
      this.setState(() => _enProcessus = false);
    }
  }

  obtenirImageBella2(ImageSource source) async {
    setState(() => _enProcessus = true);
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      File croppE = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.png,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.white,
              toolbarTitle: 'Rognez l\'image',
              statusBarColor: Colors.white,
              backgroundColor: Colors.black
          )
      );
      this.setState((){
        _fichierSelectionEB2 = croppE;
        _enProcessus = false;
      });
    }else{
      this.setState(() => _enProcessus = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final utilisateur = Provider.of<Utilisateur>(context);
    final donnEeUtil = Provider.of<DonnEesUtil>(context);

    Future<void> enregistrerDilemme() async {

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => SimpleDialog(
            title: Text('Envoi de dilemme...'),
            shape: CircleBorder(),
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: AssetImage('assets/logo.jpg'),
                    ),
                    SizedBox(height: 20.0,),
                    Padding(
                      padding: EdgeInsets.only(left: 130, right: 130),
                      child: LinearProgressIndicator(),
                    )
                  ],
                ),
              )
            ],
          ));

      //Eregistrer image bella1 sur Cloud Storage
      StorageReference reference =
      FirebaseStorage.instance.ref().child('$nomBella1$nationalitB1.png');
      StorageUploadTask uploadTask = reference.putFile(_fichierSelectionEB1);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      this.urlImgB1 = await taskSnapshot.ref.getDownloadURL();

      //la mme chose pour bella B2
      StorageReference reference2 =
      FirebaseStorage.instance.ref().child('$nomBella2$nationalitB2');
      StorageUploadTask uploadTask2 = reference2.putFile(_fichierSelectionEB2);
      StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
      this.urlImgB2 = await taskSnapshot2.ref.getDownloadURL();

      ServiceBDD serviceBDD = ServiceBDD(idUtil: utilisateur.idUtil);

      dynamic result = serviceBDD.ajoutPost(
          context, nomBella1, nationalitB1, urlImgB1,
          nomBella2, nationalitB2, urlImgB2,
          donnEeUtil.nomUtil, donnEeUtil.photoUrl, donnEeUtil.emailUtil);

      if(result == null){
        setState(() => _enProcessus = false);
        Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Oups! Quelque chose s\'est mal passé'),
            )
        );
      }else{
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/accueil');
      }
    }

    return  SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Nouveau dilemme',
              style: TextStyle(color : Colors.black),
            ),
            floating: true,
            actions: <Widget>[
              MaterialButton(
                onPressed: () async {
                  dynamic statusDeConnexion = await Connectivity().checkConnectivity();
                  if(statusDeConnexion == ConnectivityResult.none){
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Verifier votre connexion internet'),
                      )
                    );
                  }else{
                    if((_formKey.currentState.validate())
                    && (_fichierSelectionEB1 != null) && (_fichierSelectionEB2 != null)
                    &&(nationalitB1 != null) && (nationalitB2 != null)){
                      enregistrerDilemme();
                    }else{
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vous venez fournir correctement '
                              'toutes les informations'),
                        )
                      );
                    }
                  }
                },
                child: Text(
                  'Dilemme',
                  style: Theme.of(context).textTheme.title.copyWith(color:Colors.white),
                ),
                color: Colors.redAccent,
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
                [
                  Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[imageBella1(), imageBella2()],
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.words,
                                    validator: (val) =>
                                    val.isEmpty ? 'Vous devez entrer un nom' : null,
                                    onChanged: (val) => nomBella1 = val,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        filled: true,
                                        hintText: 'Comment appele-t-on la 1érè bella ?',
                                        labelText: 'Nom de la bella 1'),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.words,
                                    onChanged: (val) => nomBella2 = val,
                                    validator: (val) => nomBella1 == nomBella2
                                        ? 'Entrez un nom different'
                                        : val.isEmpty ? 'Vous devez entrer un nom' : null,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        filled: true,
                                        hintText: 'Comment appele-t-on la 2iéme bella ?',
                                        labelText: 'Nom de la bella 2'),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    color: Colors.black38,
                                    child: ListTile(
                                      title: Text('La nationalité B1', style: TextStyle(color:Colors.white),),
                                      trailing: DropdownButton(
                                        value: nationalitB1,
                                        hint: Text('Choisir', style: TextStyle(color:Colors.white),),
                                        onChanged: (val) => setState(() => nationalitB1 = val),
                                        items: _dropdownNationalite,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey[600],
                                    child: ListTile(
                                      title: Text('nationalite B2', style: TextStyle(color:Colors.white),),
                                      trailing: DropdownButton(
                                        value: nationalitB2,
                                        hint: Text('Choisir', style: TextStyle(color:Colors.white),),
                                        onChanged: (val) => setState(() => nationalitB2 = val),
                                        items: _dropdownNationalite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      (_enProcessus) ? Container(
                        color: Colors.grey[200],
                        height: MediaQuery.of(context).size.height * 0.95,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ):Container()
                    ],
                  ),
                ]
            ),
          )
        ],
      ),
    );
  }
}
