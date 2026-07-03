import 'package:equatable/equatable.dart';
import '../../models/gerbong_model.dart';

abstract class GerbongState extends Equatable {
  const GerbongState();
  
  @override
  List<Object> get props => [];
}

class GerbongInitial extends GerbongState {}

class GerbongLoading extends GerbongState {}

class GerbongLoaded extends GerbongState {
  final List<GerbongModel> gerbongs;
  const GerbongLoaded(this.gerbongs);

  @override
  List<Object> get props => [gerbongs];
}

class GerbongError extends GerbongState {
  final String message;
  const GerbongError(this.message);

  @override
  List<Object> get props => [message];
}