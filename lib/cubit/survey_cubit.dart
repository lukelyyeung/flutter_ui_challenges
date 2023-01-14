import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ui_challenge/model/dynamic_form_question_model.dart';

part 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyInitial> {
  SurveyCubit() : super(SurveyInitial(const []));
}
