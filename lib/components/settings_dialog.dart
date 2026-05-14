import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:flutter/material.dart';

void showSettingsDialog(BuildContext context, DewPointRepository dewPointRepo) {
  final controller = TextEditingController(text: dewPointRepo.dewPointFanUrl);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(i18n(context).com_settings),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: i18n(context).settings_url_label,
          hintText: i18n(context).settings_url_hint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(i18n(context).com_cancel),
        ),
        TextButton(
          onPressed: () async {
            await dewPointRepo.setUrl(controller.text);
            if (context.mounted) {
              Navigator.pop(context);
              // Trigger a refresh after URL change if possible, 
              // but the stream in DewPointRepository will eventually fetch from new URL.
            }
          },
          child: Text(i18n(context).com_ok),
        ),
      ],
    ),
  );
}
