import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ui_challenge/cubit/status_mixin.dart';
import 'package:ui_challenge/model/dynamic_form_question_model.dart';

part 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyInitial> {
  SurveyCubit() : super(SurveyInitial([QuestionType.title], [])..empty());

  void addDisplayQuestion(QuestionType type) {
    try {
      emit(state..loading());
      var result = state.displayQuestions..add(type);
      emit(SurveyInitial(result, state.survey)..success());
    } catch (e) {
      emit(state..fail(e.toString()));
    }
  }

  void removeDisplayQuestion(int index) {
    try {
      emit(state..loading());
      var result = state.displayQuestions..removeAt(index);
      emit(SurveyInitial(result, state.survey)..success());
    } catch (e) {
      emit(state..fail(e.toString()));
    }
  }

  void addSurveyQuestion(List<Questions> submitQuestions) {
    try {
      emit(state..loading());
      state.survey.clear();
      state.survey.addAll(submitQuestions);
      emit(SurveyInitial(state.displayQuestions, state.survey));
      print(state.survey.toString());
    } catch (e) {
      emit(state..fail(e.toString()));
    }
  }
}
