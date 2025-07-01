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

      // Reset quantity to 1 and update max allowed quantity
      final purchaseVM = Provider.of<PurchaseViewModel>(context, listen: false);
      purchaseVM.resetQuantity();
      purchaseVM.setMaxQuantity(event!.remainingCapacity);
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
🎫 Available: ${event!.remainingCapacity}/${event!.capacity} tickets

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

  Widget _buildCapacityInfo() {
    if (event == null) return const SizedBox.shrink();

    final isFullyBooked = event!.isFullyBooked;
    final remaining = event!.remainingCapacity;
    final total = event!.capacity;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tickets",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFullyBooked ? Colors.red[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isFullyBooked ? "Sold Out" : "$remaining Available",
                    style: TextStyle(
                      color: isFullyBooked ? Colors.red[800] : Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: event!.capacityPercentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                isFullyBooked ? Colors.red : Colors.green,
              ),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Text(
              "${total - remaining} of $total tickets sold",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: Image.network(
                      event!.poster,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Event Title
              Text(
                event!.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Capacity Info
              _buildCapacityInfo(),

              // Event Details
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoRow("Date", event!.date, icon: Icons.calendar_today),
                      _buildInfoRow("Time", event!.time, icon: Icons.access_time),
                      _buildInfoRow("Location", event!.location, icon: Icons.location_on),
                      _buildInfoRow("Category", event!.category, icon: Icons.category),
                      _buildInfoRow("Price", "RM${event!.price}", icon: Icons.attach_money),
                    ],
                  ),
                ),
              ),

              // Description
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About this event",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event!.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              // Quantity selector - only show if tickets available
              if (!event!.isFullyBooked) ...[
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Select Quantity",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: vm.quantity > 1 ? vm.decrement : null,
                            icon: Icon(
                              Icons.remove_circle,
                              color: vm.quantity > 1 ? Colors.blue : Colors.grey,
                              size: 32,
                            ),
                          ),
                          Container(
                            width: 60,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              vm.quantity.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: vm.quantity < event!.remainingCapacity ? vm.increment : null,
                            icon: Icon(
                              Icons.add_circle,
                              color: vm.quantity < event!.remainingCapacity ? Colors.blue : Colors.grey,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      if (event!.remainingCapacity < 10)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Only ${event!.remainingCapacity} tickets left!",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      height: 50,
                      color: event!.isFullyBooked ? Colors.grey : Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onPressed: event!.isFullyBooked ? null : () async {
                        if (event == null) return;

                        // Refresh event data to get latest capacity info
                        final latestEvent = await EventService().getEventById(widget.eventId);
                        if (latestEvent == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Unable to load event details"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Check if event is now fully booked
                        if (latestEvent.isFullyBooked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Sorry, this event is now sold out!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          // Update local event data
                          setState(() {
                            event = latestEvent;
                          });
                          return;
                        }

                        // Check if requested quantity exceeds remaining capacity
                        if (vm.quantity > latestEvent.remainingCapacity) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Only ${latestEvent.remainingCapacity} tickets remaining. Please reduce quantity.",
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          // Update local event data and reset quantity
                          setState(() {
                            event = latestEvent;
                          });
                          vm.setMaxQuantity(latestEvent.remainingCapacity);
                          if (vm.quantity > latestEvent.remainingCapacity) {
                            vm.resetQuantity();
                          }
                          return;
                        }

                        final ticketVM = context.read<TicketViewModel>();

                        ticketVM.setEventData(
                          eventId: latestEvent.id,
                          name: latestEvent.title,
                          location: latestEvent.location,
                          date: latestEvent.date,
                          time: latestEvent.time,
                          price: latestEvent.price,
                          poster: latestEvent.poster,
                        );

                        // Set quantity for ticket
                        ticketVM.setQuantity(vm.quantity);

                        try {
                          final paymentSuccess = await StripeService.instance.makePayment(vm.totalPrice);

                          if (paymentSuccess) {
                            final saveSuccess = await ticketVM.saveTicket();

                            if (saveSuccess) {
                              // Update the event's booked count
                              final updatedEvent = latestEvent.copyWith(
                                bookedCount: latestEvent.bookedCount + vm.quantity,
                              );

                              // Update in Firebase
                              await EventService().updateEvent(updatedEvent);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Purchase successful! ${vm.quantity} ticket${vm.quantity > 1 ? 's' : ''} purchased.",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Payment successful but failed to save ticket. Please contact support."),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Purchase failed: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text(
                        event!.isFullyBooked
                            ? "SOLD OUT"
                            : "Purchase ${vm.quantity} Ticket${vm.quantity > 1 ? 's' : ''} (RM${vm.totalPrice.toStringAsFixed(2)})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  MaterialButton(
                    height: 50,
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: shareEvent,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.share, size: 20, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          "Share",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}