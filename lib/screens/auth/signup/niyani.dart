import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/constants/app_constants.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/screens/auth/login/login_screen.dart';
import 'package:heyoo/screens/success_screen.dart';
import 'package:heyoo/services/firebase/signup_service.dart';
import 'package:heyoo/services/firebase/storage_service.dart';
import 'package:heyoo/widgets/phone_text_field.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';
import 'package:heyoo/widgets/text_field_builder.dart';

class Niyani extends StatefulWidget {
  const Niyani({super.key});

  @override
  State<Niyani> createState() => _NiyaniState();
}

class _NiyaniState extends State<Niyani> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<bool> _pageValidationStatus = [false, false, false, false, false];
  final TextEditingController _phoneNumberController = TextEditingController();

  final AppConstants _appConstants = AppConstants();

  // Separate lists of controllers for each page
  List<TextEditingController> _firstPageControllers = [];
  List<TextEditingController> _secondPageControllers = [];
  List<TextEditingController> _thirdPageControllers = [];
  List<TextEditingController> _fourthPageControllers = [];

  // Separate GlobalKey<FormState> for each page
  final GlobalKey<FormState> _zerothPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _firstPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _secondPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _thirdPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fourthPageFormKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _firstPageControllers) {
      controller.dispose();
    }
    for (var controller in _secondPageControllers) {
      controller.dispose();
    }
    for (var controller in _thirdPageControllers) {
      controller.dispose();
    }
    for (var controller in _fourthPageControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _firstPageControllers = List.generate(
        _appConstants.niyaniFirstPageQuestions.length,
        (_) => TextEditingController());
    _secondPageControllers = List.generate(
        _appConstants.niyaniSecondPageQuestions.length,
        (_) => TextEditingController());
    _thirdPageControllers = List.generate(
        _appConstants.niyaniThirdPageQuestions.length,
        (_) => TextEditingController());
    _fourthPageControllers = List.generate(
        _appConstants.niyaniFourthPageQuestions.length,
        (_) => TextEditingController());
  }

  Future<void> _saveAnswersToFirestore() async {
    try {
      // Create a map for the answers
      Map<String, String> data = {};

      // Collect answers from the first page
      for (int i = 0; i < _firstPageControllers.length; i++) {
        data[_appConstants.niyaniFirstPageQuestions[i]] =
            _firstPageControllers[i].text;
      }

      // Collect answers from the second page
      for (int i = 0; i < _secondPageControllers.length; i++) {
        data[_appConstants.niyaniSecondPageQuestions[i]] =
            _secondPageControllers[i].text;
      }

      // Collect answers from the third page
      for (int i = 0; i < _thirdPageControllers.length; i++) {
        data[_appConstants.niyaniThirdPageQuestions[i]] =
            _thirdPageControllers[i].text;
      }

      // Collect answers from the fourth page and save them in a separate map
      for (int i = 0; i < _fourthPageControllers.length; i++) {
        data[_appConstants.niyaniFourthPageQuestions[i]] =
            _fourthPageControllers[i].text;
      }

      String? storageUrl;
      if (_image == null) {
        storageUrl = null;
      } else {
        storageUrl = await FirebaseStorageService()
            .uploadImage(_image!, _phoneNumberController.text);
      }

      // Save answers using the service
      bool response = await FirebaseSignUpService().saveNiyaniDetails(
        userId: _phoneNumberController.text,
        data: data,
        imagePath: storageUrl,
      );

      if (response && mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const SuccessScreen();
        }));
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to create account. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Text('Niyani'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: Container(
                height: size.height * 0.15,
                width: size.width * 0.2,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: _image != null
                    ? Image.file(_image!)
                    : Icon(Icons.person, color: Colors.grey[700], size: 50),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        PhoneTextField(
                          size: size,
                          zerothPageFormKey: _zerothPageFormKey,
                          phoneNumberController: _phoneNumberController,
                        ),
                        SizedBox(height: size.height * 0.03),
                        PrimaryElevatedButton(
                          buttonText: 'Verify Phone Number',
                          onPressed: () async {
                            if (!_zerothPageFormKey.currentState!.validate()) {
                              return;
                            }

                            BaseItemModel response =
                                await FirebaseSignUpService()
                                    .isUserAleadyRegistered(
                                        _phoneNumberController.text);

                            if (response.success) {
                              Fluttertoast.showToast(
                                msg: 'User already exists',
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Form(
                      key: _firstPageFormKey,
                      child: TextFieldBuilder(
                        questions: _appConstants.niyaniFirstPageQuestions,
                        controllers: _firstPageControllers,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Form(
                      key: _secondPageFormKey,
                      child: TextFieldBuilder(
                        questions: _appConstants.niyaniSecondPageQuestions,
                        controllers: _secondPageControllers,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Form(
                      key: _thirdPageFormKey,
                      child: TextFieldBuilder(
                        questions: _appConstants.niyaniThirdPageQuestions,
                        controllers: _thirdPageControllers,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Form(
                      key: _fourthPageFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFieldBuilder(
                            questions: _appConstants.niyaniFourthPageQuestions,
                            controllers: _fourthPageControllers,
                          ),
                          SizedBox(height: size.height * 0.04),
                          PrimaryElevatedButton(
                            buttonText: 'Create Account',
                            onPressed: () async {
                              if (_validateCurrentPage()) {
                                await _saveAnswersToFirestore();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    if (index > _currentPage && _validateCurrentPage()) {
                      if (index == _currentPage + 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    } else if (index < _currentPage && index != 0) {
                      _pageController.jumpToPage(index);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateCurrentPage() {
    print('Validating page $_currentPage');
    bool isValid = false;
    switch (_currentPage) {
      case 0:
        isValid = _zerothPageFormKey.currentState?.validate() ?? false;
        break;
      case 1:
        isValid = _firstPageFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = _secondPageFormKey.currentState?.validate() ?? false;
        break;
      case 3:
        isValid = _thirdPageFormKey.currentState?.validate() ?? false;
        break;
      case 4:
        isValid = _fourthPageFormKey.currentState?.validate() ?? false;
        break;
      default:
        isValid = false;
    }
    _pageValidationStatus[_currentPage] = isValid;
    return isValid;
  }
}
