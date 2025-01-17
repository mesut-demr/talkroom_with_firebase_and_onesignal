import 'package:comment_system/feature/auth/cubit/auth_cubit.dart';
import 'package:comment_system/feature/auth/cubit/auth_state.dart';
import 'package:comment_system/product/components/app_textformfield.dart';
import 'package:comment_system/product/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 0.4.sh,
                width: 1.sw,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      darkBlueColor,
                      lightBlueColor,
                    ],
                  ),
                ),
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return Column(
                      spacing: 0.02.sh,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 0.02.sh),
                        state.isLoginPage
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Welcome! \n',
                                    style: TextStyle(color: whiteColor, fontSize: 36.sp),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Log in to access your account, participate in discussions, and stay connected with the community.',
                                        style: TextStyle(color: whiteColor, fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Hello, \n',
                                    style: TextStyle(color: whiteColor, fontSize: 36.sp),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Create an account to join our forum, share posts, and interact with other users. Signing up is quick and easy!',
                                        style: TextStyle(color: whiteColor, fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                height: 0.6.sh,
                width: 1.sw,
                color: whiteColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<AuthCubit>().signInWithGoogle(context);
                          },
                          child: Card(
                            shadowColor: darkBlueColor,
                            color: whiteColor,
                            elevation: 10,
                            shape: CircleBorder(),
                            child: Image.asset(
                              "assets/img/google.png",
                              height: 0.06.sh,
                              cacheWidth: 0.1.sw.toInt(),
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: darkBlueColor,
                          color: whiteColor,
                          elevation: 10,
                          shape: CircleBorder(),
                          child: Icon(Icons.facebook, size: 0.14.sw, color: darkBlueColor),
                        ),
                        Card(
                          shadowColor: darkBlueColor,
                          color: whiteColor,
                          elevation: 10,
                          shape: CircleBorder(),
                          child: Image.asset(
                            "assets/img/twitter.png",
                            height: 0.06.sh,
                            cacheWidth: 0.1.sw.toInt(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.1.sh)
                  ],
                ),
              ),
            ],
          ),
          Center(
              child: SizedBox(
            height: 0.6.sh,
            width: 0.9.sw,
            child: Card(
              elevation: 10,
              color: whiteColor,
              shadowColor: darkBlueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(height: 0.02.sh),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 0.2.sw,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<AuthCubit>().isLoginPage(true);
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    color: state.isLoginPage ? darkBlueColor : lightBlackColor,
                                    fontSize: 24.sp,
                                  ),
                                ),
                                state.isLoginPage
                                    ? Container(
                                        width: 0.2.sw,
                                        height: 1,
                                        decoration: BoxDecoration(
                                          color: state.isLoginPage ? darkBlueColor : lightBlueColor,
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<AuthCubit>().isLoginPage(false);
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Signup",
                                  style: TextStyle(
                                    color: state.isLoginPage ? lightBlackColor : darkBlueColor,
                                    fontSize: 24.sp,
                                  ),
                                ),
                                !state.isLoginPage
                                    ? Container(
                                        width: 0.2.sw,
                                        height: 1,
                                        decoration: BoxDecoration(
                                          color: darkBlueColor,
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      state.isLoginPage
                          ? Column(
                              spacing: 0.02.sh,
                              children: [
                                SizedBox(height: 0.02.sh),
                                AppTextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  width: 0.8.sw,
                                  validator: (value) {
                                    return value!.isEmpty ? "Email is required" : null;
                                  },
                                  controller: context.read<AuthCubit>().emailController,
                                  prefixIcon: Icon(Icons.email),
                                  labelText: "Email Address",
                                ),
                                AppTextFormField(
                                  width: 0.8.sw,
                                  validator: (value) {
                                    return value!.isEmpty ? "Password is required" : null;
                                  },
                                  controller: context.read<AuthCubit>().passwordController,
                                  prefixIcon: Icon(Icons.lock),
                                  labelText: "Password",
                                  obscureText: true,
                                  maxLines: 1,
                                  suffixIcon: Icon(Icons.remove_red_eye),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      shape: CircleBorder(),
                                      activeColor: darkBlueColor,
                                      value: true,
                                      onChanged: (value) {},
                                    ),
                                    Text("Remember me", style: TextStyle(color: lightBlackColor, fontSize: 14.sp)),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(color: darkBlueColor, fontSize: 14.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.04.sh),
                                if (state.errorMessage.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      state.errorMessage,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<AuthCubit>().checkLogin(context);
                                  },
                                  child: Container(
                                    height: 0.2.sw,
                                    width: 0.2.sw,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          darkBlueColor,
                                          lightBlueColor,
                                        ],
                                      ),
                                    ),
                                    child: Icon(Icons.arrow_forward, color: whiteColor, size: 0.1.sw),
                                  ),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(height: 0.02.sh),
                                AppTextFormField(
                                  width: 0.8.sw,
                                  validator: (value) {
                                    return value!.isEmpty ? "Username is required" : null;
                                  },
                                  controller: context.read<AuthCubit>().registerUsernameController,
                                  prefixIcon: Icon(Icons.person),
                                  labelText: "Username",
                                ),
                                AppTextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  width: 0.8.sw,
                                  validator: (value) {
                                    return value!.isEmpty ? "Email is required" : null;
                                  },
                                  controller: context.read<AuthCubit>().registerEmailController,
                                  prefixIcon: Icon(Icons.email),
                                  labelText: "Email Address",
                                ),
                                AppTextFormField(
                                  width: 0.8.sw,
                                  validator: (value) {
                                    return value!.isEmpty ? "Password is required" : null;
                                  },
                                  controller: context.read<AuthCubit>().registerPasswordController,
                                  prefixIcon: Icon(Icons.lock),
                                  labelText: "Password",
                                  obscureText: true,
                                  maxLines: 1,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text("Terms of Service", style: TextStyle(color: darkBlueColor, fontSize: 12.sp)),
                                ),
                                SizedBox(
                                  width: 0.72.sw,
                                  child: Text(
                                    "By signing up, you agree to our Terms of Service and Privacy Policy",
                                    style: TextStyle(color: lightBlackColor, fontSize: 10.sp),
                                  ),
                                ),
                                SizedBox(height: 0.06.sh),
                                if (state.errorMessage.isNotEmpty)
                                  Text(
                                    state.errorMessage,
                                    style: TextStyle(color: redColor, fontSize: 12.sp),
                                  ),
                                SizedBox(height: 0.02.sh),
                                GestureDetector(
                                  onTap: () {
                                    context.read<AuthCubit>().addRegister();
                                  },
                                  child: Container(
                                    height: 0.2.sw,
                                    width: 0.2.sw,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          darkBlueColor,
                                          lightBlueColor,
                                        ],
                                      ),
                                    ),
                                    child: Icon(Icons.arrow_forward, color: whiteColor, size: 0.1.sw),
                                  ),
                                )
                              ],
                            )
                    ],
                  );
                },
              ),
            ),
          )),
        ],
      ),
    );
  }
}
