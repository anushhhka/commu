import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';

class TextFieldBuilder extends StatelessWidget {
  const TextFieldBuilder(
      {super.key, required this.questions, required this.controllers});

  final List<String> questions;
  final List<TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        bool isMobileNumber = questions[index].contains("Mobile Number") ||
            questions[index].contains("Whatsapp Number");
        bool isDateOfBirth = questions[index].contains("Date");
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              if (isMobileNumber)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: '+91',
                        counterText:
                            ' ', // For Aligning the TextFormField with the second TextFormField
                        labelStyle: Typo.bodyLarge.copyWith(
                          color: AppColors.slightlyDarkGray,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                ),
              SizedBox(width: size.height * 0.01),
              Expanded(
                flex: isMobileNumber ? 3 : 1,
                child: TextFormField(
                  controller: controllers[index],
                  readOnly: isDateOfBirth,
                  onTap: isDateOfBirth
                      ? () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ).then((value) {
                            if (value != null) {
                              controllers[index].text =
                                  "${value.day}/${value.month}/${value.year}";
                            }
                          });
                        }
                      : null,
                  keyboardType: isMobileNumber ? TextInputType.phone : null,
                  maxLength: isMobileNumber ? 10 : null,
                  decoration: InputDecoration(
                    hintText: questions[index],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
