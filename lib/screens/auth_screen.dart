import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '/screens/home_screen.dart';
// import 'package:bdh_school/screens/home_screen.dart';
// import 'package:easy_localization/easy_localization.dart';
import '../common_widgets/Sigin_buttom_widget.dart';
import '../models copy/model.dart';
import '../providers/Model_provider.dart';
// import '../routing/app_router.dart';
import '../server/auth_server.dart';
import '../styles/app_colors.dart';
// import '../translations/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:space_fixer/space_fixer.dart';
import '../providers/onboarding_proivder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int currentPage = 0;
  final PageController _controller = PageController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode passNode = FocusNode();

  showTheDilog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Crate accout"),
        content: const Text(
            'If you don\'t have an account you must contact with the owner '),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              launch('tel://+963988156955');
              Navigator.of(context).pop();
            },
            child: const Text('Contact'),
          ),
        ],
      ),
    );
  }

  bool _isLoading = false;
  bool isToken = true;
  Future<void> readToken() async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      var _token = await storage.getString('token');
      var _tokenType = await storage.getString('tokenType');
      await Provider.of<AuthServer>(context, listen: false)
          .tryToken(token: _token);
      print(
          '...............................read token in the start of auth screen');
      print(_token);
      print(_tokenType);
      print('...........................................');
      setState(() {
        isToken = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _submit(String userName, String Password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false)
          .login(userName, Password);
      print(AuthServer.isAuth);
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Response',
          message: AuthServer.message,

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType:
              AuthServer.isAuth ? ContentType.success : ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      setState(() {
        _isLoading = false;
        if (AuthServer.isAuth) {
          setState(() {});
          Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
        }
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    readToken();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return isToken
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipPath(
                    clipper: ImageClipPathBetter(),
                    child: Consumer<OnboardingProvider>(
                      builder: (context, imageProvider, _) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Image.asset(
                            imageProvider.currentImagePath,
                            key: ValueKey(imageProvider.currentImagePath),
                            fit: BoxFit.cover,
                            height: mediaQuery.height / 1.7,
                            width: mediaQuery.width,
                          ),
                        );
                      },
                    ),
                  ),
                  Consumer<OnboardingProvider>(
                    builder: (context, value, _) {
                      //print(imageProvider.size);
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          key: ValueKey(value.currentImagePath),
                          pause: Duration(milliseconds: 2000),
                          // isRepeatingAnimation: false,
                          animatedTexts: [
                            value.textWidgets,
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<OnboardingProvider>(
                    builder: (context, value, _) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          key: ValueKey(value.currentImagePath),
                          pause: Duration(milliseconds: 2000),
                          // isRepeatingAnimation: false,
                          animatedTexts: [
                            value.subtextsWidgets,
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Consumer<OnboardingProvider>(
                    builder: (context, value, child) => SmoothPageIndicator(
                      effect: JumpingDotEffect(
                        activeDotColor: AppColors.primaryColor,
                        dotColor: AppColors.textColor,
                        offset: 20,
                        jumpScale: 4,
                        // verticalOffset: 10,
                      ),
                      controller: _controller,
                      count: 3,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Consumer<OnboardingProvider>(
                      builder: (context, value, child) {
                        value.setcontroller(_controller);
                        return PageView(
                          allowImplicitScrolling: false,
                          physics: NeverScrollableScrollPhysics(),
                          controller: _controller,
                          children: [
                            Container(
                              color: Colors.white,
                            ),
                            Container(
                              color: Colors.white,
                            ),
                            Container(
                              color: Colors.white,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              bottomSheet: CustomPaint(
                size: Size(double.infinity,
                    (double.infinity * 0.4696132596685083 - 30).toDouble()),
                painter: RPSCustomPainter(),
                child: Container(
                  // color: Colors.white,
                  height: 150,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Consumer<OnboardingProvider>(
                        builder: (context, value, child) => InkWell(
                          onTap: () async {
                            // final prefs = await SharedPreferences.getInstance();
                            // prefs.setBool('showLogin', true);

                            Model _model = new Model();
                            _model.passwordController = passwordController;
                            _model.userNameController = userNameController;

                            showModalBottomSheet(
                              isScrollControlled: true,
                              // barrierColor: Colors.transparent,

                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => buildSheet(
                                  MediaQuery.of(context).size, _model),
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
  Widget buildSheet(Size size, Model _model) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: makeDismissible(
            child: DraggableScrollableSheet(
              initialChildSize: 0.662,
              builder: (context, scrollController) => Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    // physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      CustomPaint(
                        size: Size(size.width,
                            (size.width * 0.4696132596685083 - 30).toDouble()),
                        painter: RPSCustomPainter(),
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: AppColors.secondaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        height: 2,
                                        thickness: 2,
                                        indent: (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2) -
                                            40,
                                        endIndent:
                                            (MediaQuery.of(context).size.width /
                                                2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SpaceFixerHorizontalLine(
                        context: context,
                        overflowHeight: 3,
                        overflowColor: AppColors.primaryColor,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 25),
                        height: size.height / 1.9,
                        color: AppColors.primaryColor,
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(50, 10, 50, 16),
                          child: Column(children: [
                            Consumer<OnboardingProvider>(
                              builder: (context, value, child) => TextFormField(
                                autovalidateMode: value.autovalidateMode,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter user name';
                                  }
                                  if (value.length < 2) {
                                    return 'User name is too short';
                                  }
                                  if (value.length > 26) {
                                    return 'User name is too long';
                                  }
                                  bool usernameValid =
                                      RegExp(r'^[a-zA-Z0-9_]+$')
                                          .hasMatch(value);
                                  if (!usernameValid) {
                                    return 'User name is invaled';
                                  }
                                  return null;
                                },
                                controller: _model.userNameController,
                                focusNode: nameNode,
                                autofocus: false,
                                cursorColor: AppColors.primaryColor,
                                autofillHints: [AutofillHints.name],
                                obscureText: false,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(passNode);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter user name',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF101213),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE0E3E7),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4B39EF),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  errorStyle: const TextStyle(
                                    color: Colors
                                        .white, // Set your desired color here
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Color(0xFF101213),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                keyboardType: TextInputType.name,
                                // validator: _model.emailAddressControllerValidator.asValidator(context),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<ModelProvider>(
                              builder: (context, value, child) =>
                                  Consumer<OnboardingProvider>(
                                builder: (context, pass, child) =>
                                    TextFormField(
                                  autovalidateMode: pass.autovalidateMode,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter password';
                                    }
                                    if (value.length < 2) {
                                      return 'Password is too short';
                                    }
                                    if (value.length > 45) {
                                      return 'Password is too long';
                                    }
                                    return null;
                                  },
                                  obscureText: !value.model.passwordVisibility,
                                  controller: _model.passwordController,
                                  autofocus: false,
                                  autofillHints: [AutofillHints.password],
                                  focusNode: passNode,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText: 'Enter password',
                                    hintStyle: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF101213),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFF4B39EF),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    errorStyle: const TextStyle(
                                      color: Colors
                                          .white, // Set your desired color here
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFFFF5963),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFFFF5963),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    suffixIcon: Consumer<ModelProvider>(
                                      builder: (context, value, child) =>
                                          InkWell(
                                        onTap: () {
                                          value.model.passwordVisibility
                                              ? value.setFalse_PasswordVisible()
                                              : value.setTrue_PasswordVisible();
                                        },
                                        focusNode:
                                            FocusNode(skipTraversal: true),
                                        child: Selector<ModelProvider,
                                            ModelProvider>(
                                          selector: (_, modelProvider) =>
                                              modelProvider,
                                          builder: (context, value, child) =>
                                              Icon(
                                            (value.model.passwordVisibility)
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Color(0xFF57636C),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                  ),

                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF101213),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  keyboardType: TextInputType.name,
                                  // validator: _model
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 20,
                            ),
                            _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      _submit(userNameController.text,
                                          passwordController.text);
                                      // print(AuthServer.isAuth);

                                      AuthServer.message == 'success'
                                          ? Navigator.of(context).pop()
                                          : null;
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(
                                            240, 249, 255, 0.808),
                                        fontSize: 26,
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 90,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Don\'t have an accont?',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.height / 90,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showTheDilog();
                                  },
                                  child: const Text(
                                    'Rigester',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            240, 249, 255, 0.808),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildImage({
    required Key? key,
    required String urlImage,
    required String title,
    required String subtitle,
    required Size size,
    // required Size size,
  }) =>
      ClipPath(
        clipper: ImageClipPathBetter(),
        child: Image(
          image: AssetImage(urlImage),
          fit: BoxFit.fitHeight,
          // height: size.height / 1.7,
          // width: size.width,
        ),
      );
}
