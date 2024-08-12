import 'package:flutter/material.dart';

class UserLoginWidget extends StatelessWidget {
  const UserLoginWidget(
      {super.key, required this.name, required this.email, this.urlPhoto = ''});
  final String name;
  final String email;
  final String urlPhoto;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.asset(
              urlPhoto.isNotEmpty ? urlPhoto : 'assets/images/avatar-face.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          child: Text(
            name,
            style: const TextStyle(fontSize: 20, color: Colors.black87),
          ),
        ),
        Positioned(
          bottom: -3,
          child: Text(
            email,
            style: const TextStyle(
                fontSize: 14, color: Color.fromARGB(221, 97, 97, 97)),
          ),
        )
      ],
    );
  }
}
