import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movies_app/Models/social_user_model.dart';
import 'package:movies_app/Shared/Components/Components.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Shared/Styles/colors.dart';


class EditProfileScreen extends StatefulWidget {
  final UserDataModel? model ;
  const EditProfileScreen({super.key, required this.model});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false ;

  var userNameController = TextEditingController() ;
  void userName(){
    userNameController.text = widget.model!.username! ;
  }
  File? fileImage ;
  String? imageUrl ;

  Future pickImage() async {

   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

   if (pickedFile != null) {
     setState(() {
       fileImage = File(pickedFile.path);
       if (kDebugMode) {
         print(fileImage);
       }
     });
   } else {
     if (kDebugMode) {
       print('No image selected.');
     }
   }
  }

  Future<void> uploadImage() async {
    setState(() {
      isLoading = true ;
    });
    if(fileImage != null ){
      await Supabase.instance
          .client
          .storage
          .from('all_images')
          .upload('images/${Uri.file(fileImage!.path).pathSegments.last}', fileImage!)
          .then((onValue){
            if (kDebugMode) {
              print('image uploaded successfully');
            }})
          .catchError((onError){
        if (kDebugMode) {
          print(onError.toString());
          print('image not uploaded');
        }
      }) ;

      imageUrl = Supabase.instance
              .client
              .storage
              .from('all_images')
              .getPublicUrl('images/${Uri.file(fileImage!.path).pathSegments.last}');

          if (imageUrl!.isNotEmpty) {
            FirebaseFirestore
                .instance
                .collection('users')
                .doc(widget.model!.uId)
                .set({
              'email':widget.model!.email,
              'image': imageUrl,
              'uId':widget.model!.uId,
              'username':userNameController.text,
            });
          }

    }else{
      FirebaseFirestore
          .instance
          .collection('users')
          .doc(widget.model!.uId)
          .set({
        'email':widget.model!.email,
        'image':widget.model!.image,
        'uId':widget.model!.uId,
        'username':userNameController.text,
      });
    }
    setState(() {
      isLoading = false ;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Edit Profile'),
          titleSpacing: 0.5,
          actions: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: MaterialButton(
                focusColor: defaultColor,
                color: Colors.blueAccent,
                onPressed: (){
                  uploadImage();
                },
                child: const Text('Edit',style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 18.0,color: Colors.white),),
              ),
            )
            ,
            const SizedBox(width: 10,)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 , horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(isLoading)
              const LinearProgressIndicator(),
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  CircleAvatar(
                    radius: 60.0 ,
                    backgroundImage: fileImage != null ? Image.file(fileImage!).image : NetworkImage('${widget.model?.image}'),
                  ),
                  CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt , color: Colors.white,),
                      onPressed: (){
                        pickImage();
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0,),
              defaultTextField
                (
                  valdate: (){},
                  isShow: false,
                  type: TextInputType.text,
                prefixIcon: Icons.person,
                hintText: 'User Name',
                titleController: userNameController,
              )
            ],
          ),
        )
    );
  }
}
