import 'package:comment_system/feature/home/cubit/home_cubit.dart';
import 'package:comment_system/feature/home/cubit/home_state.dart';
import 'package:comment_system/product/components/app_textformfield.dart';
import 'package:comment_system/product/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 0.01.sh,
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
                      context.push('/profile');
                    },
                    child: Icon(Icons.person, color: whiteColor, size: 0.1.sw)),
                Text(
                  "Rooms",
                  style: TextStyle(color: whiteColor, fontSize: 24.sp),
                ),
                GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (contextt) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[200],
                            title: Text("Add Room"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppTextFormField(
                                  validator: (value) {
                                    return value!.isEmpty ? "Name cannot be empty" : null;
                                  },
                                  controller: context.read<HomeCubit>().roomNameController,
                                  hintText: "Name",
                                ),
                                AppTextFormField(
                                  validator: (value) {
                                    return value!.isEmpty ? "Description cannot be empty" : null;
                                  },
                                  controller: context.read<HomeCubit>().roomDescriptionController,
                                  hintText: "Description",
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                  context.read<HomeCubit>().roomNameController.clear();
                                  context.read<HomeCubit>().roomDescriptionController.clear();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: lightBlackColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<HomeCubit>()
                                      .addRoom(context.read<HomeCubit>().roomNameController.text, context.read<HomeCubit>().roomDescriptionController.text);
                                  context.pop();
                                  context.read<HomeCubit>().roomNameController.clear();
                                  context.read<HomeCubit>().roomDescriptionController.clear();
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(color: lightBlackColor),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.add, color: whiteColor, size: 0.1.sw))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
            child: Text("Room List", style: TextStyle(fontSize: 20.sp, color: lightBlackColor)),
          ),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.status == HomeStatus.loading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state.status == HomeStatus.error) {
                return Center(child: Text(state.errorMessage));
              }
              if (state.status == HomeStatus.completed) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
                  separatorBuilder: (context, index) {
                    return Divider(color: lightBlackColor);
                  },
                  shrinkWrap: true,
                  itemCount: state.rooms.length,
                  itemBuilder: (context, index) {
                    final room = state.rooms[index];

                    return GestureDetector(
                      onTap: () {
                        context.push('/home_detail', extra: {
                          'cubit': context.read<HomeCubit>(),
                          'roomId': room['id'],
                        });
                        context.read<HomeCubit>().selectRoom(room['id']);
                        print('room id: ${state.selectedRoomId}');
                        print('room: ${room['id']}');
                      },
                      child: Row(
                        children: [
                          Icon(Icons.room_preferences_rounded, size: 0.2.sw, color: lightBlueColor),
                          SizedBox(width: 0.04.sw),
                          Column(
                            spacing: 0.01.sh,
                            children: [
                              Text(
                                room['name'],
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              Text(room['description'], style: TextStyle(color: lightBlackColor)),
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right_rounded, color: lightBlackColor, size: 0.1.sw)
                        ],
                      ),
                    );
                  },
                );
              }
              return SizedBox();
            },
          )
        ],
      ),
    );
  }
}
