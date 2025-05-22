import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/presentation/pages/sign_in_screen.dart';
import 'package:my_app/presentation/view_model/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                child: Text(
                  "Thông tin của bạn",
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
              ),
              // Danh sách tùy chọn
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.logout_outlined,
                        color: Colors.white54,
                      ),
                      title: Text(
                        "Đăng xuất",
                        style: TextStyle(color: Colors.white54),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white54),
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _logout(BuildContext context) async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Đăng xuất"),
          content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Đóng popup, không đăng xuất
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Đóng popup, đăng xuất
              },
              child: Text("Đăng xuất", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      await Provider.of<ProfileViewmodel>(context, listen: false)
          .signOut(); // Đăng xuất khỏi Firebase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    }
  }
}
