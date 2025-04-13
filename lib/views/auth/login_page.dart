import 'package:collabhub/components/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:collabhub/views/auth/signup_page.dart';
import 'package:collabhub/services/auth.dart';
import 'package:collabhub/views/project_listings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  
  // Animation controller and animation
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  // Validation functions
  bool _isValidAshesiEmail(String email) {
    return email.isNotEmpty && email.toLowerCase().endsWith('@ashesi.edu.gh');
  }

  void _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate fields
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => PopupDialog(
              title: 'Missing Information',
              message: 'Please enter both email and password',
              icon: Icons.error_outline,
              color: Colors.orange,
            ),
      );
      return;
    }

    // Validate email format
    if (!_isValidAshesiEmail(email)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => PopupDialog(
              title: 'Invalid Email',
              message:
                  'Please enter a valid Ashesi email address (@ashesi.edu.gh)',
              icon: Icons.email_outlined,
              color: Colors.red,
            ),
      );
      return;
    }

    // Start loading animation
    setState(() {
      _isLoading = true;
    });
    _animationController.repeat(reverse: true);

    try {
      await _authService.signInWithEmailAndPassword(email, password);
      
      // Stop animation
      _animationController.stop();
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        // Show success dialog with simpler implementation
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => PopupDialog(
            title: 'Success',
            message: 'Login successful. Welcome back!',
            icon: Icons.check_circle_outline,
            color: Colors.green,
            onDismiss: () {
              // Navigate after dialog is dismissed
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ProjectListingsScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
          ),
        );
      }
    } catch (e) {
      // Stop animation
      _animationController.stop();
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        String errorMessage = 'Login failed';
        IconData errorIcon = Icons.error_outline;

        // Handle specific error cases
        if (e.toString().contains('network')) {
          errorMessage =
              'Network error. Please check your internet connection and try again.';
          errorIcon = Icons.signal_wifi_off;
        } else if (e.toString().contains('auth credential is incorrect')) {
          errorMessage = 'Incorrect email or password';
          errorIcon = Icons.access_time;
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PopupDialog(
            title: 'Login Failed',
            message: errorMessage,
            icon: errorIcon,
            color: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo with animation
                Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isLoading ? 1.0 + (_scaleAnimation.value - 0.95) * 0.1 : 1.0,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                child: Container(
                                  width: 50,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 173, 155, 238),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                child: Container(
                                  width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade300,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 10,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 10,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Sign In Text with animation
                AnimatedOpacity(
                  opacity: _isLoading ? 0.7 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Text(
                    "Let's Sign In.",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),

                // Ready to Collaborate Text
                const Text(
                  "Ready to Collaborate",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email Label
                const Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),

                // Email Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'youremail@ashesi.edu.gh',
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.deepPurple,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(height: 24),

                // Password Label
                const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),

                // Password Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: '***************',
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.deepPurple,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.deepPurple,
                        ),
                        onPressed: _isLoading 
                            ? null 
                            : () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(height: 32),

                // Sign In Button with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: _isLoading 
                      ? (Matrix4.identity()..scale(0.98))
                      : Matrix4.identity(),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: _isLoading ? 0 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign Up Text
                AnimatedOpacity(
                  opacity: _isLoading ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  // Navigate to sign up screen with animation
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => const SignupScreen(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        var begin = const Offset(1.0, 0.0);
                                        var end = Offset.zero;
                                        var curve = Curves.easeInOut;
                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                      transitionDuration: const Duration(milliseconds: 500),
                                    ),
                                  );
                                },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: Colors.deepPurple,
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}