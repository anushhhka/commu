import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/constants/app_constants.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/models/village_member_model.dart';
import 'package:heyoo/screens/auth/login/login_screen.dart';
import 'package:heyoo/screens/success_screen.dart';
import 'package:heyoo/services/firebase/signup_service.dart';
import 'package:heyoo/services/firebase/storage_service.dart';
import 'package:heyoo/widgets/phone_text_field.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';
import 'package:heyoo/widgets/text_field_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class VillageMember extends StatefulWidget {
  const VillageMember({super.key});

  @override
  State<VillageMember> createState() => _VillageMemberState();
}

class _VillageMemberState extends State<VillageMember> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<bool> _pageValidationStatus = [false, false, false, false, false, false, false];
  final TextEditingController _phoneNumberController = TextEditingController();

  final AppConstants _appConstants = AppConstants();

  // Separate lists of controllers for each page
  List<TextEditingController> _firstPageControllers = [];
  List<TextEditingController> _secondPageControllers = [];
  List<TextEditingController> _thirdPageControllers = [];
  List<TextEditingController> _fourthPageControllers = [];
  List<TextEditingController> _fifthPageControllers = [];
  List<TextEditingController> _sixthPageControllers = [];

  // Separate GlobalKey<FormState> for each page
  final GlobalKey<FormState> _zerothPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _firstPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _secondPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _thirdPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fourthPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fifthPageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _sixthPageFormKey = GlobalKey<FormState>();

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
    for (var controller in _fifthPageControllers) {
      controller.dispose();
    }
    for (var controller in _sixthPageControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _firstPageControllers = List.generate(_appConstants.villageMemberFirstPageQuestions.length, (_) => TextEditingController());
    _secondPageControllers = List.generate(_appConstants.villageMemberSecondPageQuestions.length, (_) => TextEditingController());
    _thirdPageControllers = List.generate(_appConstants.villageMemberThirdPageQuestions.length, (_) => TextEditingController());
    _fourthPageControllers = List.generate(_appConstants.villageMemberFourthPageQuestions.length, (_) => TextEditingController());
    _fifthPageControllers = List.generate(_appConstants.villageMemberFifthPageQuestions.length, (_) => TextEditingController());
    _sixthPageControllers = List.generate(_appConstants.villageMemberSixthPageQuestions.length, (_) => TextEditingController());
  }

  Future<void> _saveAnswersToFirestore() async {
    try {
      Timestamp dob = Timestamp.now();
      Timestamp marriageDate = Timestamp.now();
      if (_fifthPageControllers[1].text.isNotEmpty) {
        // Convert Marriage Date to Timestamp
        DateTime parsedMarriageDate = DateFormat('dd/MM/yyyy').parse(_fifthPageControllers[1].text);
        marriageDate = Timestamp.fromDate(parsedMarriageDate);
      }
      if (_thirdPageControllers[0].text.isNotEmpty) {
        DateTime parsedBirthDate = DateFormat('dd/MM/yyyy').parse(_thirdPageControllers[0].text);
        dob = Timestamp.fromDate(parsedBirthDate);
      }

      String? storageUrl;
      if (_image == null) {
        storageUrl = null;
      } else {
        storageUrl = await FirebaseStorageService().uploadImage(_image!, _phoneNumberController.text);
      }

      VillageMemberModel villageMember = VillageMemberModel(
        activityOrEmployeeStatus: _fourthPageControllers[3].text,
        additionalNumber: int.tryParse(_thirdPageControllers[5].text),
        bloodGroup: _thirdPageControllers[3].text,
        dateOfBirth: dob,
        education: _thirdPageControllers[1].text,
        educationStatus: _thirdPageControllers[2].text,
        email: _firstPageControllers[0].text,
        emailAddress: _firstPageControllers[0].text,
        firstNameOfTheMember: _firstPageControllers[1].text,
        fullNameOfMavitra: _fifthPageControllers[2].text,
        fullNameOfTheFamilyHead: _secondPageControllers[3].text,
        grandMotherOrMotherInLawName: _secondPageControllers[1].text,
        grandfatherOrFatherInLawName: _secondPageControllers[0].text,
        hobbies: _thirdPageControllers[6].text,
        imagePath: storageUrl,
        isAdmin: false,
        isVerified: false,
        maritalStatus: _fifthPageControllers[0].text,
        marriageDate: marriageDate,
        middleNameFatherOrHusbandName: _firstPageControllers[2].text,
        mobileOrWhatsappNumber: int.tryParse(_thirdPageControllers[4].text),
        motherName: _firstPageControllers[3].text,
        pinCode: int.tryParse(_fourthPageControllers[2].text),
        relationWithHeadOfTheFamily: _secondPageControllers[4].text,
        residentialAddress: _fourthPageControllers[0].text,
        state: _fourthPageControllers[1].text,
        surname: _secondPageControllers[2].text,
        timestamp: Timestamp.now(),
        totalNumberOfFamilyMembers: int.tryParse(_fifthPageControllers[4].text),
        villageName: _fifthPageControllers[3].text,
      );

      bool response = await FirebaseSignUpService().saveVillageMembersDetails(
        userId: _phoneNumberController.text,
        data: villageMember,
        imagePath: storageUrl,
      );

      if (response && mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const SuccessScreen();
        }));
      } else {
        Fluttertoast.showToast(msg: 'Failed to create account. Please try again.');
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
        title: const Text('Village Member'),
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
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: _image != null ? Image.file(_image!) : Icon(Icons.person, color: Colors.grey[700], size: 50),
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

                            BaseItemModel response = await FirebaseSignUpService().isUserAleadyRegistered(_phoneNumberController.text);

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _firstPageFormKey,
                        child: TextFieldBuilder(
                          questions: _appConstants.villageMemberFirstPageQuestions,
                          controllers: _firstPageControllers,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _secondPageFormKey,
                        child: TextFieldBuilder(
                          questions: _appConstants.villageMemberSecondPageQuestions,
                          controllers: _secondPageControllers,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _thirdPageFormKey,
                        child: TextFieldBuilder(
                          questions: _appConstants.villageMemberThirdPageQuestions,
                          controllers: _thirdPageControllers,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _fourthPageFormKey,
                        child: TextFieldBuilder(
                          questions: _appConstants.villageMemberFourthPageQuestions,
                          controllers: _fourthPageControllers,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _fifthPageFormKey,
                        child: TextFieldBuilder(
                          questions: _appConstants.villageMemberFifthPageQuestions,
                          controllers: _fifthPageControllers,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _sixthPageFormKey,
                        child: Column(
                          children: [
                            TextFieldBuilder(
                              questions: _appConstants.villageMemberSixthPageQuestions,
                              controllers: _sixthPageControllers,
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
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (index) {
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
                        color: _currentPage == index ? AppColors.primary : Colors.grey,
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
            ),
          ],
        ),
      ),
    );
  }

  bool _validateCurrentPage() {
    setState(() {});
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
      case 5:
        isValid = _fifthPageFormKey.currentState?.validate() ?? false;
        break;
      case 6:
        isValid = _sixthPageFormKey.currentState?.validate() ?? false;
        break;
      default:
        isValid = false;
    }
    _pageValidationStatus[_currentPage] = isValid;
    return isValid;
  }
}
