import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/services/map_service.dart';
import '../../core/theme/folium_theme.dart';

class MapWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final bool interactive;
  final double zoom;
  final bool showMarker;
  final VoidCallback? onTap;
  final Function(LatLng)? onLocationSelected;

  const MapWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.interactive = true,
    this.zoom = 15.0,
    this.showMarker = true,
    this.onTap,
    this.onLocationSelected,
  });

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  late MapController _mapController;
  LatLng? _selectedLocation;

  /// Moves the map back to the widget's current latitude/longitude.
  void recenter() {
    if (widget.latitude != null && widget.longitude != null) {
      final target = LatLng(widget.latitude!, widget.longitude!);
      setState(() {
        _selectedLocation = target;
      });
      _mapController.move(target, widget.zoom);
    }
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.latitude != null && widget.longitude != null) {
      _selectedLocation = LatLng(widget.latitude!, widget.longitude!);
    }
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update map when parent provides new coordinates
    if (widget.latitude != oldWidget.latitude ||
        widget.longitude != oldWidget.longitude) {
      if (widget.latitude != null && widget.longitude != null) {
        final newLocation = LatLng(widget.latitude!, widget.longitude!);
        setState(() {
          _selectedLocation = newLocation;
        });
        _mapController.move(newLocation, widget.zoom);
      }
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final center = _selectedLocation ?? LatLng(0, 0);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: widget.zoom,
        interactionOptions: InteractionOptions(
          flags: widget.interactive
              ? InteractiveFlag.all
              : InteractiveFlag.none,
        ),
        onTap: widget.onLocationSelected != null
            ? (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
                widget.onLocationSelected!(point);
              }
            : null,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.herbario.field_book',
          maxZoom: 19,
          // Use cached tile provider for offline support
          tileProvider: MapService.getTileProvider(),
        ),
        if (widget.showMarker && _selectedLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedLocation!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: FoliumTheme.info,
                  size: 40,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
