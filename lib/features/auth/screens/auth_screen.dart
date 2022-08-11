import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/app_color.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Screen for authorization process.
///
/// Contains [IAuthRepository] to do so.
class AuthScreen extends StatefulWidget {
  /// Repository for auth implementation.
  final IAuthRepository authRepository;

  /// Constructor for [AuthScreen].
  const AuthScreen({
    required this.authRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // TODO(task): Implement Auth screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Log In'),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _name,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(
                      color: textFC,
                      width: 2.3,
                    ),
                  ),
                  filled: true,
                  contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  label: Text(
                    'Login',
                    style: TextStyle(
                      color: labelF,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: textFC,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    borderSide: BorderSide(
                      color: textFC,
                      width: 2.3,
                    ),
                  ),
                  filled: true,
                  contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  label: Text(
                    'Password',
                    style: TextStyle(
                      color: labelF,
                    ),
                  ),
                ),
                // чтобы авторизоваться по завершению ввода
                // пароля (нажав на готово/Галочку),
                // а не только через кнопку [Log In]
                // скорее всего в этом нет необходимости
                onEditingComplete: () async {
                  final name = _name.text;
                  final password = _password.text;
                  // if (password.isEmpty) {
                  //   return;
                  // }
                  try {
                    final dto = await widget.authRepository.signIn(
                      login: name,
                      password: password,
                    );
                    _pushToChat(context, dto);
                  } catch (e) {
                    //
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = _name.text;
                  final password = _password.text;
                  try {
                    final dto = await widget.authRepository.signIn(
                      login: name,
                      password: password,
                    );
                    _pushToChat(context, dto);
                  } catch (e) {
                    //
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 150,
                    vertical: 6,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Далее',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pushToChat(BuildContext context, TokenDto token) {
    Navigator.push<ChatScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChatScreen(
            chatRepository: ChatRepository(
              StudyJamClient().getAuthorizedClient(token.token),
            ),
          );
        },
      ),
    );
  }
}
