import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart' as qu_utils;
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

part 'chat_page_event.dart';
part 'chat_page_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  ChatPageBloc() : super(ChatPageState()) {
    on<InitChatPageEvent>(_fetchedToState);
    on<AddChatMessageEvent>(_addToState);
    on<AddChatMessageEventV2>(_addToStateV2,
        transformer: throttleDroppable(throttleDuration));
    on<ReplaceChatMessageEvent>(_switchToState);
  }

  // @override
  // Stream<ChatPageState> mapEventToState(
  //   ChatPageEvent event,
  // ) async* {
  //   if (event is InitChatPageEvent) {
  //     yield await _fetchedToState(state);
  //   }

  //   if (event is AddChatMessageEvent) {
  //     yield await _addToState(state, event);
  //   }

  //   if (event is AddChatMessageEventV2) {
  //     yield await _addToStateV2(state, event);
  //   }

  //   // if (event is AddChatMessageEvent) {
  //   //   yield* _addToStateV2(state, event);
  //   // }

  //   if (event is ReplaceChatMessageEvent) {
  //     yield await _switchToState(state, event);
  //   }
  // }

  // @override
  // Stream<Transition<ChatPageEvent, ChatPageState>> transformEvents(
  //   Stream<ChatPageEvent> events,
  //   TransitionFunction<ChatPageEvent, ChatPageState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 50)),
  //     transitionFn,
  //   );
  // }

  Future<void> _fetchedToState(
      InitChatPageEvent event, Emitter<ChatPageState> emit) async {
    return;
  }

  Future<void> _addToState(
      AddChatMessageEvent event, Emitter<ChatPageState> emit) async {
    List<Widget> ls = List.of(state.widgets);
    ls.add(event.widget);
    return emit(state.copyWith(ChatPageStatus.add, ls));
  }

  Future<void> _addToStateV2(
      AddChatMessageEventV2 event, Emitter<ChatPageState> emit) async {
    List<Widget> ls = List.of(state.widgets);
    ls.add(event.widget);
    emit(state.copyWith(ChatPageStatus.add, ls));
  }

  // Stream<ChatPageState> _addToStateV2(
  //     ChatPageState state, AddChatMessageEvent event) async* {
  //   List<Widget> ls = List.of(state.widgets);
  //   ls.add(event.widget);
  //   yield state.copyWith(ChatPageStatus.add, ls);
  // }

  Future<void> _switchToState(
      ReplaceChatMessageEvent event, Emitter<ChatPageState> emit) async {
    List<Widget> ls = List.of(state.widgets);
    if (ls.length > 0) {
      ls.removeLast();
      ls.add(event.widget);
    } else {
      ls.add(event.widget);
    }
    emit(state.copyWith(ChatPageStatus.add, ls));
  }
}
