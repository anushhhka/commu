import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/constants/app_constants.dart';
import 'package:heyoo/widgets/text_field_builder.dart';
import 'package:image_picker/image_picker.dart';

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

  final AppConstants _appConstants = AppConstants();

  // Separate lists of controllers for each page
  List<TextEditingController> _firstPageControllers = [];
  List<TextEditingController> _secondPageControllers = [];
  List<TextEditingController> _thirdPageControllers = [];
  List<TextEditingController> _fourthPageControllers = [];

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
        _appConstants.villageMemberFirstPageQuestions.length,
        (_) => TextEditingController());
    _secondPageControllers = List.generate(
        _appConstants.villageMemberSecondPageQuestions.length,
        (_) => TextEditingController());
    _thirdPageControllers = List.generate(
        _appConstants.villageMemberThirdPageQuestions.length,
        (_) => TextEditingController());
    _fourthPageControllers = List.generate(
        _appConstants.villageMemberFourthPageQuestions.length,
        (_) => TextEditingController());
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  child: _image != null
                      ? Image.file(_image!)
                      : Icon(Icons.person, color: Colors.grey[700], size: 50),
                ),
              ),
              SizedBox(
                height: size.height * 0.65,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: TextFieldBuilder(
                        questions:
                            _appConstants.villageMemberFirstPageQuestions,
                        controllers: _firstPageControllers,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: TextFieldBuilder(
                        questions:
                            _appConstants.villageMemberSecondPageQuestions,
                        controllers: _secondPageControllers,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: TextFieldBuilder(
                        questions:
                            _appConstants.villageMemberThirdPageQuestions,
                        controllers: _thirdPageControllers,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: TextFieldBuilder(
                        questions:
                            _appConstants.villageMemberFourthPageQuestions,
                        controllers: _fourthPageControllers,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(index);
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
      ),
    );
  }
}
