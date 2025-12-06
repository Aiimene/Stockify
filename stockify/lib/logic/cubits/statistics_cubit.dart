import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/statistics_repository.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsCubit(this._repository) : super(StatisticsInitial());

  Future<void> loadStatistics({
    String? startDate,
    String? endDate,
  }) async {
    emit(StatisticsLoading());
    
    final result = await _repository.getStatistics(
      startDate: startDate,
      endDate: endDate,
    );
    
    if (result['success'] == true) {
      emit(StatisticsLoaded(statistics: result['statistics'] as Map<String, dynamic>));
    } else {
      emit(StatisticsError(message: result['message'] as String));
    }
  }
}

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final Map<String, dynamic> statistics;

  StatisticsLoaded({required this.statistics});
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError({required this.message});
}

