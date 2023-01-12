import 'package:flutter/material.dart';

class DynamicFormAnswerPage extends StatefulWidget {
  const DynamicFormAnswerPage({super.key});

  static const title = 'Dynamic Form';

  @override
  State<DynamicFormAnswerPage> createState() => _DynamicFormAnswerPageState();
}

class _DynamicFormAnswerPageState extends State<DynamicFormAnswerPage> {
  Map<int, dynamic> addedQuestion = {};
  late GlobalKey<FormState> surveyFormKey;
  late TextEditingController titleTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    surveyFormKey = GlobalKey();
    titleTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleTextController.dispose();
    surveyFormKey.currentState!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    String surveyTitle = 'Please enter survey name';

    // List<Questions> questionList = http.getQuestion();

    List<String> questionList = ['1'];
    Widget submitButton() {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            surveyFormKey.currentState!.validate();
          },
          child: const Text('Submit'),
        ),
      );
    }

    return SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 35,
        ),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.teal.shade300),
                borderRadius: BorderRadius.circular(4)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Form(
                      key: surveyFormKey,
                      child: Column(
                        children: [
                          SurveyTitle(surveyTitle, surveyFormKey),
                          submitButton(),
                        ],
                      )),

                  const SizedBox(height: 10),
                  // const ElevatedButton(
                  //     onPressed: null, child: Text('Create Questionnaire')),
                  //TODO: List of question as QuestionDisplay Widget
                  // ...questionList.map((e){
                  //   Widget shoeWidget(e.QuestionType){

                  //   }
                  // });
                ],
              ),
            )),
      ),
    );
  }
}

class SurveyTitle extends StatefulWidget {
  String surveyTitle;
  GlobalKey formKey;

  SurveyTitle(this.surveyTitle, this.formKey, {super.key});

  @override
  State<SurveyTitle> createState() => _SurveyTitleState();
}

class _SurveyTitleState extends State<SurveyTitle> {
  TextEditingController? titleEdit;
  late GlobalKey surveyTitleKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleEdit = TextEditingController();
    surveyTitleKey = GlobalKey<FormState>();
    // surveyTitleKey.currentState.
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleEdit!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Name of Survey'),
          TextFormField(
            decoration:
                const InputDecoration(hintText: 'please enter some text'),

            onChanged: (value) => widget.surveyTitle = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return value.characters.length.toString();
            },
            // ,
          ),
        ],
      ),
    );
  }
}
