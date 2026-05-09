import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:io';
import 'package:exif/exif.dart';
import 'photo_gallery_screen.dart';

class PhotoViewerScreen extends StatefulWidget {
  final List<PhotoItem> photos;
  final int initialIndex;

  const PhotoViewerScreen({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showInfo = false;
  Map<String, IfdTag>? _exifData;
  bool _loadingExif = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _loadExifData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadExifData() async {
    setState(() => _loadingExif = true);
    
    try {
      final file = File(widget.photos[_currentIndex].path);
      if (file.existsSync()) {
        final bytes = await file.readAsBytes();
        final data = await readExifFromBytes(bytes);
        setState(() {
          _exifData = data;
          _loadingExif = false;
        });
      }
    } catch (e) {
      setState(() {
        _exifData = null;
        _loadingExif = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.photos.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(_showInfo ? Icons.info : Icons.info_outline, color: Colors.white),
            onPressed: () => setState(() => _showInfo = !_showInfo),
          ),
        ],
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (context, index) {
              final photo = widget.photos[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(photo.path)),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(tag: photo.path),
              );
            },
            itemCount: widget.photos.length,
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
              ),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _showInfo = false;
              });
              _loadExifData();
            },
          ),
          if (_showInfo) _buildInfoOverlay(),
        ],
      ),
    );
  }

  Widget _buildInfoOverlay() {
    final photo = widget.photos[_currentIndex];
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                photo.plant.scientificName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (photo.plant.commonName.isNotEmpty)
                Text(
                  photo.plant.commonName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                '${photo.plant.dateCollected.day}/${photo.plant.dateCollected.month}/${photo.plant.dateCollected.year}',
                style: const TextStyle(color: Colors.white70),
              ),
              if (photo.plant.latitude != null && photo.plant.longitude != null) ...[
                const SizedBox(height: 4),
                Text(
                  'GPS: ${photo.plant.latitude!.toStringAsFixed(6)}, ${photo.plant.longitude!.toStringAsFixed(6)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
              if (_exifData != null && _exifData!.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'EXIF Data:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ..._buildExifInfo(),
              ] else if (_loadingExif)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExifInfo() {
    if (_exifData == null) return [];
    
    final info = <Widget>[];
    
    // Camera make and model
    if (_exifData!.containsKey('Image Make') && _exifData!.containsKey('Image Model')) {
      final make = _exifData!['Image Make']!.printable;
      final model = _exifData!['Image Model']!.printable;
      info.add(Text(
        'Câmera: $make $model',
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ));
    }
    
    // ISO, Aperture, Shutter Speed
    final iso = _exifData!['EXIF ISOSpeedRatings']?.printable;
    final aperture = _exifData!['EXIF FNumber']?.printable;
    final shutter = _exifData!['EXIF ExposureTime']?.printable;
    
    if (iso != null || aperture != null || shutter != null) {
      final parts = <String>[];
      if (iso != null) parts.add('ISO $iso');
      if (aperture != null) parts.add('f/$aperture');
      if (shutter != null) parts.add('${shutter}s');
      
      info.add(Text(
        parts.join(' • '),
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ));
    }
    
    // Image dimensions
    final width = _exifData!['EXIF ExifImageWidth']?.printable;
    final height = _exifData!['EXIF ExifImageLength']?.printable;
    
    if (width != null && height != null) {
      info.add(Text(
        'Resolução: $width × $height',
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ));
    }
    
    return info;
  }
}
