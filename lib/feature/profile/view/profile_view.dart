import 'package:comment_system/feature/profile/cubit/profile_cubit.dart';
import 'package:comment_system/product/constant/color_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: context.read<ProfileCubit>().getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User information not found.'));
          }

          final userData = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 1.sw,
                height: 0.12.sh,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: darkBlueColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Icon(Icons.chevron_left_rounded, color: whiteColor, size: 0.1.sw),
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(color: whiteColor, fontSize: 24.sp),
                    ),
                    SizedBox(width: 0.1.sw)
                  ],
                ),
              ),
              SizedBox(height: 0.01.sh),
              Center(
                child: CircleAvatar(
                  radius: 48.r,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 36.r, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 0.02.sh),
              Card(
                color: Colors.grey[200],
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(0.02.sw),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.grey[300],
                        child: ListTile(
                          title: Text('Username'),
                          subtitle: Text(userData['username']),
                        ),
                      ),
                      Card(
                        color: Colors.grey[300],
                        child: ListTile(
                          title: Text('E-mail'),
                          subtitle: Text(userData['email']),
                        ),
                      ),
                      Card(
                        color: Colors.grey[300],
                        child: ListTile(
                          title: Text("Created At"),
                          subtitle: Text(context.read<ProfileCubit>().formatDate(userData['createdAt'])),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    context.pushReplacement('/auth');
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: whiteColor, fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
