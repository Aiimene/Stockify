import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/order.dart';
import '../../data/repositories/orders_repository.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _repository;

  OrdersCubit(this._repository) : super(OrdersInitial());

  Future<void> loadOrders({
    String? startDate,
    String? endDate,
    String? status,
    String? paymentMethod,
  }) async {
    emit(OrdersLoading());
    
    final result = await _repository.getOrders(
      startDate: startDate,
      endDate: endDate,
      status: status,
      paymentMethod: paymentMethod,
    );
    
    if (result['success'] == true) {
      emit(OrdersLoaded(
        orders: result['orders'] as List<Order>,
        count: result['count'] as int,
      ));
    } else {
      emit(OrdersError(message: result['message'] as String));
    }
  }

  Future<void> createOrder({
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    emit(OrdersLoading());
    
    final result = await _repository.createOrder(
      paymentMethod: paymentMethod,
      items: items,
    );
    
    if (result['success'] == true) {
      emit(OrderCreated(order: result['order'] as Order));
      // Reload orders
      await loadOrders();
    } else {
      emit(OrdersError(message: result['message'] as String));
    }
  }

  Future<void> deleteOrder(int orderId) async {
    emit(OrdersLoading());
    
    final result = await _repository.deleteOrder(orderId);
    
    if (result['success'] == true) {
      // Order deleted successfully - reload orders list
      await loadOrders();
      emit(OrderDeleted(orderId: orderId));
    } else {
      emit(OrdersError(message: result['message'] as String));
    }
  }

  Future<void> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    emit(OrdersLoading());
    
    final result = await _repository.updateOrderStatus(
      orderId: orderId,
      status: status,
    );
    
    if (result['success'] == true) {
      // Order status updated successfully - reload orders list
      await loadOrders();
      
      if (result['order'] != null && result['order'] is Order) {
        emit(OrderStatusUpdated(order: result['order'] as Order));
      }
    } else {
      emit(OrdersError(message: result['message'] as String));
    }
  }
}

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;
  final int count;

  OrdersLoaded({required this.orders, required this.count});
}

class OrderCreated extends OrdersState {
  final Order order;

  OrderCreated({required this.order});
}

class OrderDeleted extends OrdersState {
  final int orderId;

  OrderDeleted({required this.orderId});
}

class OrderStatusUpdated extends OrdersState {
  final Order order;

  OrderStatusUpdated({required this.order});
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError({required this.message});
}

