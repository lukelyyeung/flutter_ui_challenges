import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_challenge/const/theme.dart';
import 'package:ui_challenge/cubit/survey_cubit.dart';
import 'package:ui_challenge/model/dynamic_form_question_model.dart';

class DynamicFormPreviewPage extends StatefulWidget {
  const DynamicFormPreviewPage({super.key});

  @override
  State<DynamicFormPreviewPage> createState() => _DynamicFormPreviewPageState();
}

class _DynamicFormPreviewPageState extends State<DynamicFormPreviewPage> {
  late GlobalKey _surveyFormKey;

  @override
  void initState() {
    // TODO: implement initState
    _surveyFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<SurveyCubit, SurveyInitial>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Dynamic Form Preview'),
            backgroundColor: Colors.teal,
          ),
          body: Center(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal.shade300),
                  borderRadius: BorderRadius.circular(6)),
              child: SingleChildScrollView(
                child: Form(
                  key: _surveyFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...state.survey.map((e) => _buildSurvey(e)).toList(),
                      _submitButton(),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget _submitButton() {
    return OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.send_outlined),
        label: const Text('submit'));
  }

  Widget _buildSurvey(Questions item) {
    switch (item.type) {
      case QuestionType.title:
        return SurveyTitle(item);
      case QuestionType.text:
        return SurveyTextQuestion(item);
      case QuestionType.radio:
        return SurveyRadioQuestion(item);
      case QuestionType.checkbox:
        return SurveyCheckboxQuestion(item);
      default:
        return Text('WIP');
    }
  }
}

class SurveyTitle extends StatelessWidget {
  final Questions item;

  SurveyTitle(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Survey: ${item.question}',
          style: StyleClass.kSurveyQuestion,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class SurveyCheckboxQuestion extends StatefulWidget {
  final Questions item;

  SurveyCheckboxQuestion(this.item, {super.key});

  @override
  State<SurveyCheckboxQuestion> createState() => _SurveyCheckboxQuestionState();
}

class _SurveyCheckboxQuestionState extends State<SurveyCheckboxQuestion> {
  late int optionLen;
  late List<bool> isCheckedList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    optionLen = widget.item.answerOptions!.length;
    isCheckedList = List.generate(optionLen, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(widget.item.question, style: StyleClass.kSurveyQuestion),
          ...widget.item.answerOptions!.map((e) {
            int index = widget.item.answerOptions!.indexOf(e);
            return CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(e),
              value: isCheckedList[index],
              onChanged: (value) {
                setState(() {
                  isCheckedList[index] = value!;
                });
              },
            );
          })
        ],
      ),
    );
  }
}

class SurveyRadioQuestion extends StatefulWidget {
  final Questions item;

  const SurveyRadioQuestion(this.item, {super.key});

  @override
  State<SurveyRadioQuestion> createState() => _SurveyRadioQuestionState();
}

class _SurveyRadioQuestionState extends State<SurveyRadioQuestion> {
  Map<String, bool> isSelected = {};
  String _selectedAnswer = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedAnswer = widget.item.answerOptions!.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(
            widget.item.question,
            style: StyleClass.kSurveyQuestion,
          ),
          ...widget.item.answerOptions!.asMap().entries.map((options) {
            return RadioListTile(
              title: Text(options.value),
              value: options.value,
              groupValue: _selectedAnswer,
              onChanged: (String? value) {
                setState(() {
                  _selectedAnswer = value!;
                });
              },
            );
          }),
        ],
      ),
    );
  }
}

class SurveyTextQuestion extends StatefulWidget {
  Questions item;

  SurveyTextQuestion(this.item, {super.key});

  @override
  State<SurveyTextQuestion> createState() => SurveyTextQuestionState();
}

class SurveyTextQuestionState extends State<SurveyTextQuestion> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            widget.item.question,
            style: StyleClass.kSurveyQuestion,
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            height: 180,
            width: double.maxFinite,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              cursorHeight: 10,
              decoration: const InputDecoration(border: InputBorder.none),
              initialValue: '',
              maxLines: 5,
              maxLength: 100,
              validator: (value) => null,
              onSaved: (value) => null,
            ),
          )
        ],
      ),
    );
  }
}
