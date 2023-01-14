part of 'survey_cubit.dart';

@immutable
abstract class SurveyState {}

class SurveyInitial extends SurveyState {
  late final List<Questions> questions;

  SurveyInitial(this.questions);
}
