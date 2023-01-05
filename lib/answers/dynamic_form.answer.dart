import 'package:flutter/material.dart';
import 'package:ui_challenge/model/dynamic_form_question_model.dart';

class DynamicFormAnswerPage extends StatefulWidget {
  const DynamicFormAnswerPage({super.key});

  static const title = 'Dynamic Form';

  @override
  State<DynamicFormAnswerPage> createState() => _DynamicFormAnswerPageState();
}

class _DynamicFormAnswerPageState extends State<DynamicFormAnswerPage> {
  Map<int, dynamic> storedAnswer = {};
  submit() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    Text title = const Text('Questionnaire Name');

    // List<Questions> questionList = http.getQuestion();

    List<String> questionList = ['1'];

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
                  title,
                  const SizedBox(height: 10),
                  const ElevatedButton(
                      onPressed: null, child: Text('Create Questionnaire')),
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

class AddNewQuestion extends StatelessWidget {
  const AddNewQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Question title'),
        Text('Type of Question'),
        //TODO if not text type, show answer option
        Text('Answer Option'),
        //TODO upon complete, trigger QuestionList().add
        //TODO or cancel
      ],
    );
  }
}
