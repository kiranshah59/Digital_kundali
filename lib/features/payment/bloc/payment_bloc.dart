import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_event.dart';
import 'payment_state.dart';
import '../data/payment_service.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<LoadPlans>(_onLoadPlans);
  }

  Future<void> _onLoadPlans(LoadPlans event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final response = await PaymentService.getPlans();
      if (response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>;
        
        // The API returns a map of plans. Let's filter out inactive ones if is_active exists.
        // Actually, the API says "premium/guru slugs exist in DB but are deactivated (is_active: false)"
        // It might be handled by the backend, or we filter it here.
        Map<String, dynamic> activePlans = {};
        
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            bool isActive = value['is_active'] ?? true; 
            // the doc says they are kept only for old data integrity, so we might want to skip them if they are not active.
            if (isActive) {
              activePlans[key] = value;
            }
          }
        });

        emit(PaymentLoaded(activePlans.isNotEmpty ? activePlans : data));
      } else {
        emit(PaymentError(response['message'] ?? 'Failed to load plans'));
      }
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
