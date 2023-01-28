part of 'survey_cubit.dart';

@immutable
abstract class SurveyState with StatusMixin {}

class SurveyInitial extends SurveyState {
  late List<QuestionType> displayQuestions = [];
  late List<Questions> survey = [];

  SurveyInitial(this.displayQuestions, this.survey);
}
