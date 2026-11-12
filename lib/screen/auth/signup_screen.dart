import 'package:exppence_tracker/core/constant/app_colors.dart';
import 'package:exppence_tracker/services/auth_service.dart';
import 'package:exppence_tracker/widgets/auth/auth_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/auth/primary_gradient_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignUpPressed() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      final result = await context.read<AuthClassProvider>().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      if (!mounted) return;

      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).maybePop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.errorMessage ??
                  'Failed to create account. Please try again.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthClassProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Badge
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.cardGradientStart,
                          AppColors.cardGradientEnd,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardGradientStart.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title & Subtitle
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign up to track, manage, and optimize your expenses.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textGrey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Full Name Field
                  AuthTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    hintText: 'John Doe',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Email Address Field
                  AuthTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    hintText: 'name@example.com',
                    prefixIcon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final bool emailValid = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ).hasMatch(value.trim());
                      if (!emailValid) {
                        return 'Enter a valid email format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Password Field
                  AuthTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Create a password',
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    isPasswordVisible: !_obscurePassword,
                    onTogglePasswordVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Confirm Password Field
                  AuthTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    prefixIcon: Icons.lock_reset_rounded,
                    isPassword: true,
                    isPasswordVisible: !_obscureConfirmPassword,
                    onTogglePasswordVisibility: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // Submit Sign Up Button
                  PrimaryGradientButton(
                    text: 'Sign Up',
                    isLoading: isLoading,
                    onPressed: _onSignUpPressed,
                  ),
                  const SizedBox(height: 24),

                  // Already Have an Account Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppColors.cardGradientStart,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:exppence_tracker/core/constant/app_colors.dart';
// import 'package:exppence_tracker/services/auth_service.dart';
// import 'package:exppence_tracker/widgets/auth/auth_textfeild.dart';
// import 'package:flutter/material.dart';
// import '../../widgets/auth/primary_gradient_button.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   late final TextEditingController _nameController;
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;
//   late final TextEditingController _confirmPasswordController;

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isSubmitting = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     _confirmPasswordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//  Future<void> _onSignUpPressed(String name, String email, String password) async {
//     FocusScope.of(context).unfocus();

//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isSubmitting = true;
//       });

//       // Firebase registration logic will be integrated here
//       await AuthServiceClass().signUpWithEmailAndPassword(
//         email,
//         password,
//         name,
//       );
//       Future.delayed(const Duration(seconds: 2), () {
//         if (mounted) {
//           setState(() {
//             _isSubmitting = false;
//           });
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 24.0,
//               vertical: 20.0,
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header Badge
//                   Container(
//                     width: 58,
//                     height: 58,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [
//                           AppColors.cardGradientStart,
//                           AppColors.cardGradientEnd,
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.cardGradientStart.withValues(
//                             alpha: 0.3,
//                           ),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.person_add_alt_1_rounded,
//                       color: AppColors.white,
//                       size: 30,
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // Title & Subtitle
//                   const Text(
//                     'Create Account',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textDark,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Sign up to track, manage, and optimize your expenses.',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: AppColors.textGrey,
//                       height: 1.4,
//                     ),
//                   ),
//                   const SizedBox(height: 28),

//                   // Full Name Field
//                   AuthTextField(
//                     controller: _nameController,
//                     labelText: 'Full Name',
//                     hintText: 'John Doe',
//                     prefixIcon: Icons.person_outline_rounded,
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please enter your full name';
//                       }
//                       if (value.trim().length < 3) {
//                         return 'Name must be at least 3 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 18),

//                   // Email Address Field
//                   AuthTextField(
//                     controller: _emailController,
//                     labelText: 'Email Address',
//                     hintText: 'name@example.com',
//                     prefixIcon: Icons.alternate_email_rounded,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       final bool emailValid = RegExp(
//                         r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//                       ).hasMatch(value.trim());
//                       if (!emailValid) {
//                         return 'Enter a valid email format';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 18),

//                   // Password Field
//                   AuthTextField(
//                     controller: _passwordController,
//                     labelText: 'Password',
//                     hintText: 'Create a password',
//                     prefixIcon: Icons.lock_outline_rounded,
//                     isPassword: true,
//                     isPasswordVisible: !_obscurePassword,
//                     onTogglePasswordVisibility: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please enter a password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 18),

//                   // Confirm Password Field
//                   AuthTextField(
//                     controller: _confirmPasswordController,
//                     labelText: 'Confirm Password',
//                     hintText: 'Re-enter your password',
//                     prefixIcon: Icons.lock_reset_rounded,
//                     isPassword: true,
//                     isPasswordVisible: !_obscureConfirmPassword,
//                     onTogglePasswordVisibility: () {
//                       setState(() {
//                         _obscureConfirmPassword = !_obscureConfirmPassword;
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please confirm your password';
//                       }
//                       if (value != _passwordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 28),

//                   // Submit Sign Up Button
//                   PrimaryGradientButton(
//                     text: 'Sign Up',
//                     isLoading: _isSubmitting,
//                     onPressed: () async {
//                       await _onSignUpPressed(
//                         _nameController.text.trim(),
//                         _emailController.text.trim(),
//                         _passwordController.text.trim(),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 24),

//                   // Already Have an Account Link
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Already have an account? ',
//                         style: TextStyle(
//                           color: AppColors.textGrey,
//                           fontSize: 14,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => Navigator.of(context).maybePop(),
//                         child: const Text(
//                           'Sign In',
//                           style: TextStyle(
//                             color: AppColors.cardGradientStart,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
