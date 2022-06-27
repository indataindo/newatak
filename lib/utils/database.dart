import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('amarta');
final CollectionReference _tambah = _firestore.collection('listuser');
final CollectionReference _location = _firestore.collection('location');

class Database {
  static String userUid;
  static String idku;

  static Future<void> addItem({
     String title,
     String description,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('daftaruser').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> adduser({
     String email,
     String nama,
     String password,
  }) async {
    _tambah.add({
      "nama":nama,
      "email":email,
      "password":password
    });
  }

  static Future<void> updateItem({
     String title,
     String description,
     String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }



  static readLocation() {
    CollectionReference itemlocation =
        _location.doc(idku).collection('location');

    return itemlocation.snapshots();
  }
  static readItems() {
    CollectionReference notesItemCollection =
        _mainCollection.doc(userUid).collection('daftaruser');

    return notesItemCollection.snapshots();
  }


    static readUser() {
    CollectionReference notesItemCollection =
        _mainCollection.doc(userUid).collection('listuser');

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
     String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
