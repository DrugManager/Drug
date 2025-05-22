import 'package:drug/features/auth/login/set_nickname_view_model.dart';
import 'package:flutter/material.dart';

class SetNickname extends StatefulWidget {
  const SetNickname({super.key});

  @override
  _SetNicknameState createState() => _SetNicknameState();
}

class _SetNicknameState extends State<SetNickname> {
  final viewModel = SetNicknameViewModel();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40,),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: "닉네임을 입력해주세요"
                ),
              ),
              const SizedBox(height: 200,),
              SizedBox(
                width: 350,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () async{
                    final nickname = _nicknameController.text.trim();
                    await viewModel.saveNickname(nickname);
                    viewModel.MoveToHome(context, nickname);
                  },
                  child: Text(
                    "메디안 스토리 시작하기",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
