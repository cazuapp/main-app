part of 'bloc.dart';

abstract class PlaceOrderEvent extends Equatable {
  const PlaceOrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrder extends PlaceOrderEvent {
  const PlaceOrder({required this.address, required this.payment});

  final int address;
  final int payment;

  @override
  List<Object> get props => [address, payment];
}
