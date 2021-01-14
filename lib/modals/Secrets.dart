import 'dart:convert';

import 'package:flutter/services.dart';

class Secrets {

    const Secrets({
       this.airtableApiBaseId,
       this.airtableApiKey, 
    });

    final String airtableApiBaseId;
    final String airtableApiKey;

    // !!!
    static Secrets fromJson(json) => Secrets(
        airtableApiBaseId: json['AIRTABLE_API_BASE_ID'],
        airtableApiKey: json['AIRTABLE_API_KEY'],
    );

    // !!!
    static Future<Secrets> fromAssets() => rootBundle.loadStructuredData<Secrets>(
        'assets/secrets.json',
        (secrets) => Future.sync(() => 
            Secrets.fromJson(jsonDecode(secrets)),
        )
    );

    // !!!
    dynamic toJson() => {
        'AIRTABLE_API_BASE_ID': this.airtableApiBaseId,
        'AIRTABLE_API_KEY': this.airtableApiKey
    };
}