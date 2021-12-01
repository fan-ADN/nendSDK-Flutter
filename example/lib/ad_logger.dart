import 'package:flutter/material.dart';
import 'package:nend_plugin/nend_plugin.dart';

class SettingAdLogger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logLevels = NendAdLogLevel.values;

    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Ad Logger'),
      ),
      body: ListView.builder(
        itemCount: logLevels.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  logLevels[index].toString(),
                  textAlign: TextAlign.left,
                ),
                onTap: () async {
                  await NendAdLogger.setLogLevel(logLevels[index]);
                },
              ),
              Divider(height: 0),
            ],
          );
        },
      ),
    );
  }
}
