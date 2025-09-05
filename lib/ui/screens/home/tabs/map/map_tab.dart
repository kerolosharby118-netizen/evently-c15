import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(30.0444, 31.2357); // القاهرة

  final List<Map<String, dynamic>> events = [
    {
      "id": "1",
      "title": "Meeting for Updating The Development Met...",
      "location": "Cairo, Egypt",
      "position": const LatLng(30.0444, 31.2357),
    },
    {
      "id": "2",
      "title": "Business Conference",
      "location": "Nasr City, Cairo",
      "position": const LatLng(30.0561, 31.3300),
    },
  ];

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    for (var e in events) {
      _markers.add(
        Marker(
          markerId: MarkerId(e["id"]),
          position: e["position"],
          infoWindow: InfoWindow(title: e["title"], snippet: e["location"]),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
        ),

        /// زرار الإعدادات فوق يمين
        Positioned(
          top: 20,
          right: 20,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.blue,
            onPressed: () {},
            child: const Icon(Icons.settings, color: Colors.white),
          ),
        ),

        /// 🔹 الكارت تحت (للأحداث)
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.meeting_room,
                              color: Colors.blue, size: 32),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event["title"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.blue, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      event["location"],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
