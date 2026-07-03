import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/cargo_service.dart';
import '../../models/gerbong_model.dart';
import 'gerbong_event.dart';
import 'gerbong_state.dart';

class GerbongBloc extends Bloc<GerbongEvent, GerbongState> {
  final CargoService _cargoService = CargoService();

  GerbongBloc() : super(GerbongInitial()) {
    on<FetchGerbongs>((event, emit) async {
      emit(GerbongLoading());
      try {
        print('📦 Fetching gerbongs from API...');
        final gerbongs = await _cargoService.getGerbongs();
        print('✅ Gerbongs fetched successfully: ${gerbongs.length} items');
        emit(GerbongLoaded(gerbongs));
      } catch (e) {
        print('❌ Error fetching gerbongs: $e');
        emit(GerbongError(e.toString()));
      }
    });

    on<AddGerbong>((event, emit) async {
      emit(GerbongLoading());
      try {
        print('➕ Adding new gerbong...');
        await _cargoService.createGerbong(event.gerbongData);
        print('✅ Gerbong added successfully');
        
        // Fetch ulang data setelah menambah
        final gerbongs = await _cargoService.getGerbongs();
        emit(GerbongLoaded(gerbongs));
      } catch (e) {
        print('❌ Error adding gerbong: $e');
        emit(GerbongError(e.toString()));
      }
    });

    on<UpdateGerbong>((event, emit) async {
      emit(GerbongLoading());
      try {
        print('✏️ Updating gerbong ${event.gerbongId}...');
        await _cargoService.updateGerbong(event.gerbongId, event.gerbongData);
        print('✅ Gerbong updated successfully');
        
        // Fetch ulang data setelah update
        final gerbongs = await _cargoService.getGerbongs();
        emit(GerbongLoaded(gerbongs));
      } catch (e) {
        print('❌ Error updating gerbong: $e');
        emit(GerbongError(e.toString()));
      }
    });

    on<DeleteGerbong>((event, emit) async {
      emit(GerbongLoading());
      try {
        print('🗑️ Deleting gerbong ${event.gerbongId}...');
        await _cargoService.deleteGerbong(event.gerbongId);
        print('✅ Gerbong deleted successfully');
        
        // Fetch ulang data setelah delete
        final gerbongs = await _cargoService.getGerbongs();
        emit(GerbongLoaded(gerbongs));
      } catch (e) {
        print('❌ Error deleting gerbong: $e');
        emit(GerbongError(e.toString()));
      }
    });
  }
}

