
import 'dart:convert';

import 'package:flutter/material.dart';

import 'API.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKeyLogin = GlobalKey<FormState>();

  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late bool passwordVisibility;

  late String username,password;
  bool selected = false;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    passwordVisibility = false;
  }

  @override
  void dispose() {

    super.dispose();
  }

  void _login() async{
    var data = {
      'username' : username,
      'password' : password
    };
    var res = await Network().post(data, 'users/login');
    var body = jsonDecode(res.body);
    if(res.statusCode == 200){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var data = body['data'];
      localStorage.setString('user', json.encode(data['userData']));
      localStorage.setString('token', data['token']);

      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => HomePage()
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        top: true,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/2,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFC11616),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: Container(
                        width: double.infinity,
                        height: 950,
                        decoration: BoxDecoration(
                          color: Color(0x80FFFFFF),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Text(
                            'T-RES',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/2,
              height: 220,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://picsum.photos/seed/328/600',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Form(
                    key: formKeyLogin,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Welcome Telyutizen!',
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: usernameController,
                            autofocus: true,
                            obscureText: false,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E3E7),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFF5963),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFF5963),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (us){
                              if(us!.isEmpty){
                                return 'Please enter your Username';
                              }
                              username = us;
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: passwordController,
                            autofocus: true,
                            obscureText: !passwordVisibility,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () => setState(
                                      () => passwordVisibility =
                                  !passwordVisibility,
                                ),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  passwordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 24,
                                ),
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E3E7),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFF5963),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFF5963),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (pass){
                              if(pass!.isEmpty){
                                return 'Please enter your Password';
                              }
                              password = password;
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKeyLogin.currentState!.validate()) {
                              _login();
                            }
                          },
                          child: Text('Log in'
                              ,style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Inter',
                              )),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(120,40),
                            primary: Color(0xFFDFD8D0),
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24, 0, 24, 0),

                          ),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

