import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(FirebaseAuth.instance.currentUser?.email.toString() ??
              'не удалось загрузить пользователя', style: TextStyle( fontWeight: FontWeight.bold),),
          
          const Text('\nВаша Роль:', style: TextStyle( fontWeight: FontWeight.bold, fontFamily: "PricedownBl", fontSize: 20)),
          
          Text(context.watch<String?>().toString(), style: TextStyle( fontWeight: FontWeight.bold, fontFamily: "PricedownBl", fontSize: 20)),
        ],
      ),
    );
  }
}
