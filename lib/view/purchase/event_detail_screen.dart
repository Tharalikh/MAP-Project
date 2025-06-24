import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:festquest/model/event_model.dart';
import 'package:festquest/services/event_service.dart';
import 'package:festquest/services/paymentGateway_service.dart';
import '../../view_model/purchase_viewModel.dart';
import '../../view_model/ticket_viewModel.dart';
import 'package:flutter/services.dart';

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

  void shareEvent() async {
    if (event == null) return;

    final shareText = '''🎉 Check out this amazing event on FestQuest!

${event!.title}

📅 Date: ${event!.date}
⏰ Time: ${event!.time}
📍 Location: ${event!.location}
🏷️ Category: ${event!.category}
💰 Price: RM${event!.price}

${event!.description}

📱 Open in FestQuest app: festquest://event/${widget.eventId}

Don't have the app? Search for "FestQuest" in your app store!
Event ID: ${widget.eventId}''';

    try {
      await Clipboard.setData(ClipboardData(text: shareText));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event shared! Copied to clipboard - paste it anywhere to share.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to copy event details'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PurchaseViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(event?.title ?? 'Loading...'),
        actions: [
          if (!isLoading && event != null)
            IconButton(
              onPressed: shareEvent,
              icon: const Icon(Icons.share),
              tooltip: 'Share Event',
            ),
        ],
      ),
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
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (event == null) return;

                        // ✅ Local variable that is non-nullable
                        final e = event!;

                        final ticketVM = context.read<TicketViewModel>();

                        ticketVM.setEventData(
                          eventId: e.id ?? '',
                          name: e.title ?? '',
                          location: e.location ?? '',
                          date: e.date ?? '',
                          time: e.time ?? '',
                          price: e.price ?? '0',
                          poster: e.poster ?? '',
                        );

                        final paymentSuccess = await StripeService.instance.makePayment(vm.totalPrice);

                        if (paymentSuccess) {
                          final saveSuccess = await ticketVM.saveTicket();

                          if (saveSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Purchase successful")),
                            );
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text("Purchase"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  MaterialButton(
                    color: Colors.grey[600],
                    textColor: Colors.white,
                    onPressed: shareEvent,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.share, size: 16),
                        SizedBox(width: 4),
                        Text("Share"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}