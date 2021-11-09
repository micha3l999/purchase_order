import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchase_order/src/global_widgets/no_scroll_behavior.dart';
import 'package:purchase_order/src/routes/routes.dart';
import 'package:purchase_order/src/ui/login/models/user.dart';
import 'package:purchase_order/src/ui/login/repository/login_repository.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/global_widgets/primary_button.dart';
import 'package:purchase_order/src/utils/dialogs.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginRepository _loginRepository = LoginRepository();
  final _formKey = GlobalKey<FormState>();
  User? _user;

  bool _passwordObscure = true;
  bool _showIconPassword = false;
  String? _username = "", _password = "";

  @override
  Widget build(BuildContext context) {
    // Media Query constants
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Scaffold(
        backgroundColor: blackColor,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: ScrollConfiguration(
              behavior: NoScrollBehavior(),
              child: ListView(
                children: [
                  SizedBox(
                    height: (mediaHeight * 0.3) - 33,
                    child:
                        LayoutBuilder(builder: (_, BoxConstraints constraints) {
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: constraints.maxHeight * 0.5,
                          width: constraints.maxWidth * 0.5,
                          alignment: Alignment.center,
                          child: Center(
                            child: Image(
                              image: Image.asset("assets/images/xiao_logo.jpg")
                                  .image,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: (mediaHeight * 0.7) - 33,
                    child: Padding(
                      padding: EdgeInsets.only(top: mediaHeight * 0.05),
                      child: Column(
                        children: [
                          Text(
                            "Login",
                            style: GoogleFonts.lato(
                              fontSize: 45,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Form(
                            key: _formKey,
                            child: SizedBox(
                              width: 250,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Ingrese el usuario';
                                      }
                                    },
                                    onSaved: (String? value) {
                                      _username = value;
                                    },
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: blackColor, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: blackColor, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: "usuario",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    onChanged: (String? value) {
                                      if (value != null && value.isNotEmpty) {
                                        setState(() {
                                          _showIconPassword = true;
                                        });
                                      } else {
                                        setState(() {
                                          _showIconPassword = false;
                                          _passwordObscure = true;
                                        });
                                      }
                                    },
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Ingrese la contraseña';
                                      }
                                    },
                                    onSaved: (String? value) {
                                      _password = value;
                                    },
                                    obscureText: _passwordObscure,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      suffixIcon: _showIconPassword
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _passwordObscure =
                                                      !_passwordObscure;
                                                });
                                              },
                                              icon: _passwordObscure
                                                  ? const Icon(Icons.visibility)
                                                  : const Icon(
                                                      Icons.visibility_off),
                                            )
                                          : null,
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: blackColor, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: blackColor, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: "contraseña",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  PrimaryButton(
                                      onTap: () {
                                        if (_formKey.currentState != null &&
                                            _formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          sendDataLogin();
                                        }
                                      },
                                      title: const Text(
                                        "Iniciar sesión",
                                        style: TextStyle(fontSize: 16),
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendDataLogin() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _user = await _loginRepository.signIn(_username, _password);

      if (_user != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.home, (Route<dynamic> route) => false);
      } else {
        Dialogs.informationDialog(context,
            title: "El Usuario o contraseña está incorrecto");
      }
    }
  }
}
