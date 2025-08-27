import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 실제 폰 테스트용 서버 주소 → PC 로컬 IP로 변경
  final String serverUrl =
      'http://10.174.109.56:8080/auth/signup'; // PC IPv4 주소 사용

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint("Validation failed. Signup not called.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('폼을 올바르게 입력해주세요.')),
      );
      return;
    }

    final Map<String, String> requestBody = {
      'email': _emailController.text,
      'password': _passwordController.text,
      'nickname': _nicknameController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestBody),
      );

      debugPrint("----------------------------------------------------");
      debugPrint("Response: ${response.statusCode} ${response.body}");
      debugPrint("----------------------------------------------------");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${response.body}')),
        );
      }
    } catch (e) {
      debugPrint("Signup error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? '이메일을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) => value!.length < 4 ? '비밀번호는 4자 이상' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: '닉네임'),
                validator: (value) => value!.isEmpty ? '닉네임을 입력해주세요.' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _signup,
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }
}
