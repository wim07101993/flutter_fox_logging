import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/field_visibilities.dart';
import 'package:flutter_fox_logging/src/labeled_check_box.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({
    super.key,
    required this.controller,
  });

  final ValueNotifier<LogFieldVisibilities> controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Visible fields'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ValueListenableBuilder<LogFieldVisibilities>(
            valueListenable: controller,
            builder: (context, visibleFields, _) => Column(
              children: [
                LabeledCheckBox(
                  value: visibleFields.icon,
                  onChanged: (v) => controller.value =
                      visibleFields.copyWithIcon(icon: v ?? false),
                  label: const Text('Icon'),
                ),
                LabeledCheckBox(
                  value: visibleFields.loggerName,
                  onChanged: (v) => controller.value =
                      visibleFields.copyWithLoggerName(loggerName: v ?? false),
                  label: const Text('Logger name'),
                ),
                LabeledCheckBox(
                  value: visibleFields.time,
                  onChanged: (v) => controller.value =
                      visibleFields.copyWithTime(time: v ?? false),
                  label: const Text('Time'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
