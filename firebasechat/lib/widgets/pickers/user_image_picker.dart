import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function selectedImage;
  UserImagePicker(this.selectedImage);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 200);
    if(pickedFile!=null){

      setState(() {
      _image = File(pickedFile.path);

      });
      widget.selectedImage(_image);

    }

    
    
    
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            getImage();
          },
          child: CircleAvatar(
            child: CircleAvatar(
              backgroundImage:_image!=null?FileImage(_image): NetworkImage(
                  'https://stickyguide.imgix.net/product_photos/1686114/original-1553659347.jpg?auto=format&fm=jpg&q=85&dpr=3&w=200&h=200'),
              radius: 40,
            ),
            radius: 42,
          ),
        ),
      ],
    );
  }
}
