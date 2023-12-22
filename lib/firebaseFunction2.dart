import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices2 {
  static saveUser(String fullmessname,String address,String role,String name, email, uid) async {
    await FirebaseFirestore.instance
        .collection('messvala')
        .doc(uid)
        .set({'email': email, 'name': name,'role':role,'address':address,'mess_name':fullmessname});

    CollectionReference collRef = FirebaseFirestore.instance.collection('messvala').doc('messlist').collection('messlistcol');
    collRef.doc(fullmessname.trim()).set({
      //'messName': messNameController.text,
     'url':'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80',
      'name':fullmessname.trim(),

    });

  }

}
