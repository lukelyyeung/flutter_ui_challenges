import 'package:flutter/material.dart';
import 'package:ui_challenge/cubit/survey_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_challenge/model/dynamic_form_question_model.dart';

//TODO: challenge
//**
//* GlobalKey won't follow
//* Double AnswerField()
//* Cannot delete specific AnswerField()
// */

typedef void ValCallBack(dynamic question, dynamic answers);
typedef void SubCallBack(dynamic value);

class DynamicFormAnswerPage extends StatefulWidget {
  const DynamicFormAnswerPage({super.key});

  static const title = 'Dynamic Form';

  @override
  State<DynamicFormAnswerPage> createState() => _DynamicFormAnswerPageState();
}

class _DynamicFormAnswerPageState extends State<DynamicFormAnswerPage> {
  Map<int, dynamic> addedQuestion = {};
  late GlobalKey<FormState> _surveyFormKey;
  // late TextEditingController titleTextController;

  List<QuestionType> questions = [QuestionType.title];
  List<Questions> surveyList = [];

  void addQuestion(QuestionType type) {
    questions.add(type);
  }

  void removeQuestion() {
    if (questions.length == 1) {
      return;
    }
    questions.removeLast();
  }

  Widget? showQuestion(QuestionType type) {
    switch (type) {
      case QuestionType.title:
        return QuestionField(
            isSurveyTitle: true, textCallBack: (value, answer) {});
      case QuestionType.text:
        return QuestionField(
          textCallBack: (question, answer) {},
        );
      case QuestionType.radio:
        return QuestionField(
          textCallBack: (question, answer) {
            surveyList.add(RadioQuestion(111, type, question, answer));
          },
          isMultipleAnswer: true,
        );
      default:
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _surveyFormKey = GlobalKey();
    // titleTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // titleTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    // Widget submitButton(String surveytitle) {
    //   return Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: ElevatedButton(
    //       onPressed: () {
    //         bool canSubmit = _surveyFormKey.currentState!.validate();
    //         if (canSubmit) {
    //           print(surveytitle);
    //         }
    //       },
    //       child: const Text('Submit'),
    //     ),
    //   );
    // }

    return BlocProvider(
      create: (context) => SurveyCubit(),
      child: SizedBox(
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
              child: BlocBuilder<SurveyCubit, SurveyInitial>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Form(
                          key: _surveyFormKey,
                          child: Column(
                            children: [
                              //TODO: List of question as QuestionDisplay Widget
                              ...questions
                                  .asMap()
                                  .entries
                                  .map((e) => showQuestion(e.value)!)
                                  .toList(),
                              //TODO: List of add questions options
                              addQuestionButton(),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                  onPressed: () {
                                    _surveyFormKey.currentState!.validate();
                                  },
                                  child: const Text('Validate')),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                  onPressed: () {
                                    bool isValid =
                                        _surveyFormKey.currentState!.validate();
                                    if (isValid) {
                                      _surveyFormKey.currentState!.save();
                                      _surveyFormKey.currentState!.reset();
                                    }
                                  },
                                  child: const Text('Submit')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> addQuestionButton() {
    return PopupMenuButton(itemBuilder: (context) {
      return [
        PopupMenuItem(
          child: const Text('Text Question'),
          onTap: () {
            setState(() {
              addQuestion(QuestionType.text);
            });
          },
        ),
        PopupMenuItem(
          child: const Text('Radio Question'),
          onTap: () {
            setState(() {
              addQuestion(QuestionType.radio);
            });
          },
        ),
        PopupMenuItem(
          child: const Text('Remove Question'),
          onTap: () {
            setState(() {
              removeQuestion();
            });
          },
        ),
      ];
    });
  }
}

class QuestionField extends StatefulWidget {
  // TextEditingController textEditingController;
  bool isSurveyTitle;
  bool isMultipleAnswer;
  ValCallBack textCallBack;
  List<String> answers;
  List<Widget>? optionField;
  int counter = 1;

  QuestionField(
      {required this.textCallBack,
      this.isSurveyTitle = false,
      this.isMultipleAnswer = false,
      super.key})
      : answers = [];

  @override
  State<QuestionField> createState() => _QuestionFieldState();
}

class _QuestionFieldState extends State<QuestionField> {
  @override
  Widget build(BuildContext context) {
    String title = !widget.isSurveyTitle ? 'Question Name' : "Survey Name";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextFormField(
            // controller: textController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: 'please enter some text',
              prefixIcon: Icon(
                Icons.lightbulb,
                color: Colors.amber,
              ),
            ),
            initialValue: null,
            maxLength: 50,
            maxLines: 1,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              RegExp nonNum = RegExp(r'[0-9]');
              bool hasNum = nonNum.hasMatch(value);
              if (hasNum) {
                return 'Please enter text only';
              }
              return null;
            },
            onSaved: (newValue) =>
                widget.textCallBack(newValue, widget.answers),
          ),
          //** index always  */
          if (widget.isMultipleAnswer)
            // AnswerField(),
            // ...List.generate(widget.counter, AnswerField((value) {})),
            ...List.generate(
              widget.counter,
              (index) {
                bool isLast = widget.counter == index + 1;
                return addAnswerField(index, isLast);
              },
            ),
        ],
      ),
    );
  }

  Row addAnswerField(int index, bool isLast) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnswerField(
          index,
          valCallBack: (value) {
            widget.answers.add(value);
          },
        ),
        if (isLast)
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    widget.counter++;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.add,
                    // size: 15,
                  )),
              IconButton(
                  onPressed: () {
                    widget.counter--;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.delete,
                    // size: 15,
                  ))
            ],
          ),
      ],
    );
  }
}

class AnswerField extends StatelessWidget {
  SubCallBack valCallBack;
  int index;

  AnswerField(this.index, {required this.valCallBack, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Option ${index + 1}',
          style: TextStyle(),
        ),
        SizedBox(
          width: 170,
          child: TextFormField(
            // controller: textController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: 'answer options',
              prefixIcon: Icon(
                Icons.arrow_circle_right,
                color: Colors.blue,
                size: 15,
              ),
            ),
            initialValue: null,
            maxLength: 20,
            maxLines: 1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              RegExp nonNum = RegExp(r'[0-9]');
              bool hasNum = nonNum.hasMatch(value);
              if (hasNum) {
                return 'Please enter text only';
              }
              return null;
            },
            onSaved: (newValue) => valCallBack(newValue),
          ),
        ),
      ],
    );
  }
}
