import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/event_model.dart';

abstract class EventEvent extends Equatable { const EventEvent(); @override List<Object?> get props => []; }
class LoadEvents extends EventEvent {}
class AddEvent extends EventEvent { final EventModel event; const AddEvent(this.event); @override List<Object?> get props => [event]; }

abstract class EventState extends Equatable { const EventState(); @override List<Object?> get props => []; }
class EventInitial extends EventState {}
class EventLoading extends EventState {}
class EventLoaded extends EventState { final List<EventModel> events; const EventLoaded(this.events); @override List<Object?> get props => [events]; }

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventInitial()) {
    on<LoadEvents>((event, emit) async { emit(EventLoading()); emit(const EventLoaded([])); });
    on<AddEvent>((event, emit) async { if (state is EventLoaded) { final current = (state as EventLoaded).events; emit(EventLoaded([...current, event.event])); } });
  }
}
