import 'package:comment_system/feature/home/cubit/home_cubit.dart';
import 'package:comment_system/feature/home/cubit/home_state.dart';
import 'package:comment_system/product/components/app_textformfield.dart';
import 'package:comment_system/product/constant/color_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeDetailView extends StatelessWidget {
  final String roomId;
  const HomeDetailView({
    super.key,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  "Comment Page",
                  style: TextStyle(color: whiteColor, fontSize: 24.sp),
                ),
                SizedBox(width: 0.1.sw),
              ],
            ),
          ),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Column(
                children: [
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: context.read<HomeCubit>().getComments(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('There are no comments yet.'));
                      }

                      final comments = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final likedBy = List<String>.from(comments[index]['likedBy'] ?? []);

                          final isLiked = likedBy.contains(FirebaseAuth.instance.currentUser?.uid);
                          return ListTile(
                            title: Text(comment['username']),
                            subtitle: Column(
                              children: [
                                Text(comment['comment']),
                                Text('${comment['likes']} Beğeni'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : null,
                              ),
                              onPressed: () async {
                                final commentId = comment['commentId'];
                                final likerUserId = FirebaseAuth.instance.currentUser?.uid;
                                final commentOwnerId = comment['userId'];
                                print("commentId: ${comment['commentId']}");
                                print("likerUserId: $likerUserId");
                                print("commentOwnerId: $commentOwnerId");

                                if (likerUserId != null) {
                                  await context.read<HomeCubit>().likeComment(roomId, commentId, likerUserId, commentOwnerId);
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppTextFormField(
                        width: 0.82.sw,
                        hintText: 'Enter your comment',
                        validator: (value) {
                          return value!.isEmpty ? 'Comment cannot be empty' : null;
                        },
                        controller: context.read<HomeCubit>().commentController,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 0.08.sw,
                        ),
                        onPressed: () async {
                          context.read<HomeCubit>().submitComment();
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
