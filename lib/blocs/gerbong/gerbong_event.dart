import 'package:equatable/equatable.dart';

abstract class GerbongEvent extends Equatable {
  const GerbongEvent();

  @override
  List<Object> get props => [];
}

class FetchGerbongs extends GerbongEvent {}

class AddGerbong extends GerbongEvent {
  final Map<String, dynamic> gerbongData;
  const AddGerbong(this.gerbongData);

  @override
  List<Object> get props => [gerbongData];
}

class UpdateGerbong extends GerbongEvent {
  final int gerbongId;
  final Map<String, dynamic> gerbongData;
  const UpdateGerbong(this.gerbongId, this.gerbongData);

  @override
  List<Object> get props => [gerbongId, gerbongData];
}

class DeleteGerbong extends GerbongEvent {
  final int gerbongId;
  const DeleteGerbong(this.gerbongId);

  @override
  List<Object> get props => [gerbongId];
}