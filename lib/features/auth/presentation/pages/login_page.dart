import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_internship_task/core/utils/component.dart';
import 'package:flutter_internship_task/core/utils/enum/enum.dart';
import 'package:flutter_internship_task/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_internship_task/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_internship_task/features/auth/presentation/pages/signup_page.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var fromLoginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Navigate to home screen and pass user data
            Navigator.pushReplacementNamed(context, '/', arguments: state.user);
          } else if (state is AuthFailure) {
            showToast(message: state.message, state: ToastStates.ERROR);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: fromLoginKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'login now to browse our hot offers',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                defaultFormField(
                  controller: emailController,
                  type: TextInputType.emailAddress,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'pleas enter your email';
                    }
                  },
                  label: 'Email',
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 20),
                defaultFormField(
                  suffixIcon: Icon(
                    context.read<AuthBloc>().ispassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  suffixFunction: () {
                    context.read<AuthBloc>().add(
                      PasswordVisibilityEvent(
                        isPasswordVisible: !context.read<AuthBloc>().ispassword,
                      ),
                    );
                  },
                  onSubmit: (v) {
                    if (fromLoginKey.currentState!.validate()) {}
                  },
                  isPassword: context.read<AuthBloc>().ispassword,
                  controller: passwordController,
                  type: TextInputType.visiblePassword,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'pleas enter your password';
                    }
                  },
                  label: 'Password',
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(height: 30),
                ConditionalBuilder(
                  condition: context.watch<AuthBloc>().state is! AuthLoading,
                  builder:
                      (context) => defaultButton(
                        function: () {
                          if (fromLoginKey.currentState!.validate()) {
                            print('teeeeeeeeee');
                            context.read<AuthBloc>().add(
                              LoginEvent(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                          }
                        },
                        text: 'Login',
                        isUpperCase: true,
                      ),
                  fallback:
                      (context) =>
                          const Center(child: CircularProgressIndicator()),
                ),
                Row(
                  children: [
                    const Text('Don\'t have an account?'),
                    defaultTextButton(
                      function: () {
                        navigateTo(context, SignupPage(), replace: true);
                      },
                      text: 'signup',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
