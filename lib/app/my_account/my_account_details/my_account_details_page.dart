import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vollgym/app/models/account.dart';
import 'package:vollgym/app/widgets/rounded_button.dart';

class MyAccountDetailsPage extends StatefulWidget {
  const MyAccountDetailsPage({super.key, required this.account});

  final Account? account;

  @override
  State<MyAccountDetailsPage> createState() => _MyAccountDetailsPageState();
}

class _MyAccountDetailsPageState extends State<MyAccountDetailsPage> {
  final ImagePicker _picker = ImagePicker();
  bool isEdited = false;

  late final _firstNameController =
      TextEditingController(text: widget.account?.firstName);
  late final _lastNameController =
      TextEditingController(text: widget.account?.lastName);
  late final _emailController =
      TextEditingController(text: widget.account?.email);
  late final _phoneNumberController =
      TextEditingController(text: widget.account?.phoneNumber);

  String? updatedAvatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szczegóły konta')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: updatedAvatar != null
                    ? MemoryImage(base64Decode(updatedAvatar!))
                    : widget.account != null && widget.account!.isAvatarExists
                        ? widget.account!.getImage.image
                        : const AssetImage('assets/avatar_default.png'),
                radius: 50.0,
              ),
            ),
            if (!isEdited) const SizedBox(height: 25),
            if (isEdited)
              Center(
                child: TextButton(
                  onPressed: () async {
                    final status = await Permission.storage.status;

                    if (status.isPermanentlyDenied) {
                      AlertDialog alert = AlertDialog(
                        title: const Text("Brak uprawnień"),
                        content: const Text(
                            "Nie udzielono dostępu do plików w telefonie, udziel uprawnień w ustawieniach aplikacji"),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );

                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }

                      return;
                    }

                    if (!status.isGranted) {
                      final requestedPermission =
                          await Permission.storage.request();

                      if (!requestedPermission.isGranted) {
                        return;
                      }
                    }

                    final image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      final imageBytes = await image.readAsBytes();
                      setState(() {
                        updatedAvatar = base64Encode(imageBytes);
                      });
                    }
                  },
                  child: const Text('Wstaw zdjęcie'),
                ),
              ),
            FullNameInfo(
              isEdited: isEdited,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
            ),
            const SizedBox(height: 10),
            Divider(
              height: 2,
              thickness: 1.2,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 10),
            EmailInfo(
              isEdited: isEdited,
              emailController: _emailController,
            ),
            const SizedBox(height: 10),
            Divider(
              height: 2,
              thickness: 1.2,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 10),
            PhoneInfo(
              isEdited: isEdited,
              phoneNumberController: _phoneNumberController,
            ),
            const Spacer(),
            if (!isEdited)
              RoundedButton(
                text: 'Edytuj',
                onPressed: () {
                  setState(() {
                    isEdited = true;
                  });
                },
              ),
            if (isEdited)
              Row(
                children: [
                  Expanded(
                    child: RoundedButton(
                      text: 'Anuluj',
                      onPressed: () {
                        setState(() {
                          updatedAvatar = null;
                          isEdited = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: RoundedButton(
                      text: 'Zapisz',
                      onPressed: () async {
                        if (widget.account != null) {
                          final ref = FirebaseFirestore.instance
                              .collection('accounts')
                              .doc(FirebaseAuth.instance.currentUser!.uid);

                          final updatedAccount = widget.account!.copyWith(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            phoneNumber: _phoneNumberController.text,
                            email: _emailController.text,
                            avatar: updatedAvatar,
                          );

                          await ref.update(updatedAccount.toMap());
                        }

                        setState(() {
                          isEdited = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class FullNameInfo extends StatelessWidget {
  const FullNameInfo({
    super.key,
    required this.isEdited,
    required this.firstNameController,
    required this.lastNameController,
  });

  final bool isEdited;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  @override
  Widget build(BuildContext context) {
    if (isEdited) {
      return Row(
        children: [
          const Icon(Icons.account_circle_rounded, size: 35),
          const SizedBox(width: 10),
          Expanded(
              child: MyAccountInfoEditingTile(controller: firstNameController)),
          const SizedBox(width: 10),
          Expanded(
              child: MyAccountInfoEditingTile(controller: lastNameController)),
        ],
      );
    }

    return MyAccountInfoTile(
      icon: Icons.account_circle_rounded,
      title:
          '${firstNameController.text ?? ''} ${lastNameController.text ?? ''}',
    );
  }
}

class EmailInfo extends StatelessWidget {
  const EmailInfo({
    super.key,
    required this.isEdited,
    required this.emailController,
  });

  final bool isEdited;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    if (isEdited) {
      return MyAccountInfoEditingTile(
        controller: emailController,
        icon: Icons.email_outlined,
      );
    }

    return MyAccountInfoTile(
      icon: Icons.email_outlined,
      title: emailController.text,
    );
  }
}

class PhoneInfo extends StatelessWidget {
  const PhoneInfo({
    super.key,
    required this.isEdited,
    required this.phoneNumberController,
  });

  final bool isEdited;
  final TextEditingController phoneNumberController;

  @override
  Widget build(BuildContext context) {
    if (isEdited) {
      return MyAccountInfoEditingTile(
        controller: phoneNumberController,
        icon: Icons.phone_android_outlined,
        maxFieldLength: 9,
        textInputType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      );
    }

    return MyAccountInfoTile(
      icon: Icons.phone_android_outlined,
      title: phoneNumberController.text,
    );
  }
}

class MyAccountInfoTile extends StatelessWidget {
  const MyAccountInfoTile({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 35),
        const SizedBox(width: 10),
        Text(title),
      ],
    );
  }
}

class MyAccountInfoEditingTile extends StatelessWidget {
  const MyAccountInfoEditingTile({
    super.key,
    required this.controller,
    this.icon,
    this.maxFieldLength = 150,
    this.textInputType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final IconData? icon;
  final int maxFieldLength;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return Row(
        children: [
          Icon(icon, size: 35),
          const SizedBox(width: 10),
          Expanded(child: _textField()),
        ],
      );
    }

    return _textField();
  }

  Widget _textField() {
    return SizedBox(
      height: 40,
      child: TextField(
        maxLength: maxFieldLength,
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.0),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
          hintText: "Type in your text",
          fillColor: Colors.white30,
          contentPadding: const EdgeInsets.only(left: 15),
        ),
        controller: controller,
      ),
    );
  }
}
