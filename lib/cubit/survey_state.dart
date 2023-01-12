part of 'survey_cubit.dart';

@immutable
abstract class SurveyState {}

class SurveyInitial extends SurveyState {
  late final String surveyTitle;
  late final List<Questions> questions;

  SurveyInitial(this.surveyTitle, this.questions);
}
