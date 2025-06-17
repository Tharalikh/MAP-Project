import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:festquest/model/event_model.dart';
import 'package:festquest/services/event_service.dart';
import 'package:festquest/services/paymentGateway_service.dart';
import '../../view_model/purchase_viewModel.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  EventModel? event;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEventData();
  }

  Future<void> loadEventData() async {
    event = await EventService().getEventById(widget.eventId);

    if (event != null) {
      final price = double.tryParse(event!.price) ?? 0.0;
      Provider.of<PurchaseViewModel>(context, listen: false).setPrice(price);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PurchaseViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(event?.title ?? 'Loading...')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event!.poster.isNotEmpty)
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(event!.poster, fit: BoxFit.cover),
                  ),
                ),
              const SizedBox(height: 12),
              Text("Description:", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(event!.description),
              const SizedBox(height: 10),
              Text("Date: ${event!.date}"),
              Text("Time: ${event!.time}"),
              Text("Location: ${event!.location}"),
              Text("Category: ${event!.category}"),
              Text("Creator ID: ${event!.creatorId}"),
              Text("Price: RM${event!.price}"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: vm.decrement, icon: const Icon(Icons.remove_circle)),
                  Text(vm.quantity.toString(), style: const TextStyle(fontSize: 18)),
                  IconButton(onPressed: vm.increment, icon: const Icon(Icons.add_circle)),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    final total = vm.totalPrice;
                    StripeService.instance.makePayment(total);
                  },
                  child: Text("Pay RM ${vm.totalPrice.toStringAsFixed(2)}"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
