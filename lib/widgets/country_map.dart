import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/config/app_config.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../features/countries/domain/country.dart';
import 'app_feedback.dart';
import 'content_card.dart';

class CountryMap extends StatefulWidget {
  const CountryMap({
    required this.coordinates,
    required this.countryName,
    super.key,
  });

  final Coordinates coordinates;
  final String countryName;

  @override
  State<CountryMap> createState() => _CountryMapState();
}

class _CountryMapState extends State<CountryMap> {
  bool _tileFailed = false;
  bool _failureScheduled = false;
  int _revision = 0;

  void _reportTileFailure(int revision) {
    if (!mounted || revision != _revision || _tileFailed || _failureScheduled) {
      return;
    }

    _failureScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _failureScheduled = false;

      if (!mounted || revision != _revision || _tileFailed) {
        return;
      }

      setState(() {
        _tileFailed = true;
      });
    });
  }

  Future<void> _openAttribution() async {
    try {
      final opened = await launchUrl(
        Uri.parse(AppConfig.osmCopyrightUrl),
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        AppFeedback.error(AppStrings.linkFailed);
      }
    } catch (_) {
      AppFeedback.error(AppStrings.linkFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = LatLng(
      widget.coordinates.latitude,
      widget.coordinates.longitude,
    );

    final revision = _revision;

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.map_outlined, color: AppColors.primary),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  AppStrings.location,
                  style: TextStyle(
                    fontSize: 18.spMin,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            AppStrings.locationDescription,
            style: TextStyle(
              fontSize: 12.spMin,
              color: AppColors.muted,
              height: 1.5,
            ),
          ),
          16.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: SizedBox(
              height: 280.h.clamp(220.0, 360.0).toDouble(),
              child: FlutterMap(
                key: ValueKey(_revision),
                options: MapOptions(
                  initialCenter: point,
                  initialZoom: 4,
                  minZoom: 2,
                  maxZoom: 18,
                  backgroundColor: AppColors.primarySoft,
                ),
                children: [
                  TileLayer(
                    urlTemplate: AppConfig.tilesUrl,
                    userAgentPackageName: AppConfig.packageName,
                    maxNativeZoom: 19,
                    errorTileCallback: (tile, error, stackTrace) {
                      _reportTileFailure(revision);
                    },
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: 48,
                        height: 48,
                        child: Tooltip(
                          message: widget.countryName,
                          child: const Icon(
                            Icons.location_on,
                            size: 46,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        AppStrings.osmCredit,
                        onTap: _openAttribution,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_tileFailed) ...[
            12.verticalSpace,
            Text(
              AppStrings.mapFailed,
              style: TextStyle(color: AppColors.muted, fontSize: 12.spMin),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _tileFailed = false;
                  _revision++;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ],
      ),
    );
  }
}
