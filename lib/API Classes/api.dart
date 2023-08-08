import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Global Data/global.dart';
import '../models/channels.dart';
import 'api_keys.dart';

class BoxDetails {
  Future<Map<String, dynamic>> fetchBoxData() async {
    String url = baseURL + getWalletAmount;
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to fetch Box Details');
    }
  }
}

class Channels {
  Future<Map<String, dynamic>> fetchChannelData() async {
    String url = baseURL + getBouquets;

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to fetch Channel Details');
    }
  }
}

class AddBouquet {
  String baseUrl =
      'http://206.189.140.49:7070/admin/api/subscriber/addSubscription';
  Future<List<String>> fetchBouquets() async {
    final response = await http.get(
      Uri.parse(baseUrl + getBouquets),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<String> data = jsonResponse['data']
          .map<String>((item) => item['name'].toString())
          .toList();
      return data;
    } else {
      throw Exception('Failed to fetch bouquet details');
    }
  }

  Future<http.Response> putRequest(String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode(data);

    final response = await http.put(url, headers: headers, body: body);
    return response;
  }
}

class GetBouquets {
  Future<Map<String, dynamic>> fetchBoxData() async {
    String apiUrl = baseURL + getBouquets;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Failed to fetch Bouquets');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      throw Exception('Failed to fetch Bouquets');
    }
  }
}

class GetUserSubscription {
  Future<Map<String, dynamic>> fetchUserChannelAndPacks(
    Map<String, dynamic> body,
  ) async {
    String apiUrl = baseURL +
        getSubscriptionBySubscriberCodeAndStbIdActive; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Failed to fetch user packs and channels');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      throw Exception('Failed to fetch user packs and channels');
    }
  }
}

class Login {
  static Future<int> loginUser(String username, String password) async {
    String loginUrl = baseURL + msoLogin;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {
      'username': username,
      'password': password,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(loginUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Login was successful
        String responseData = response.body;

        Map<String, dynamic> jsonResponse = jsonDecode(responseData);

        token = jsonResponse['token'];

        if (kDebugMode) {
          print('Token from login response: $token');
        }
        return 1;
      } else {
        if (kDebugMode) {
          print('Login failed with status: ${response.statusCode}');
        }
        return 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return 0;
    }
  }
}

class BasePackAPIs {
  static List<BasePack> parseBasePacks(String responseBody) {
    final parsed = json.decode(responseBody)['data'];
    return parsed
        .where((pack) => pack['packType'] == 'BASE_PACK')
        .map<BasePack>((pack) {
      final channels = (pack['channels'] as List<dynamic>)
          .map<Channel>((channel) => Channel(
                name: channel['name'],
                description: channel['description'],
                number: channel['number'],
              ))
          .toList();

      return BasePack(
        name: pack['name'],
        price: pack['price'],
        id: pack['id'].toString(),
        channels: channels,
      );
    }).toList();
  }

  static Future<List<BasePack>> fetchData() async {
    String url = baseURL + getBouquets;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer $token', // Add the bearer token in the headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.body;
        return parseBasePacks(jsonData);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      throw Exception('Failed to fetch data');
    }
  }
}

class AddonPackAPIs {
  static List<AddonPack> parseAddonPacks(String responseBody) {
    final parsed = json.decode(responseBody)['data'];
    return parsed
        .where((pack) => pack['packType'] == 'ADD_ON_PACK')
        .map<AddonPack>((pack) {
      final channels = (pack['channels'] as List<dynamic>)
          .map<Channel>((channel) => Channel(
                name: channel['name'],
                description: channel['description'],
                number: channel['number'],
              ))
          .toList();

      return AddonPack(
        name: pack['name'],
        price: pack['price'],
        id: pack['id'].toString(),
        channels: channels,
      );
    }).toList();
  }

  static Future<List<AddonPack>> fetchData() async {
    String url = baseURL + getBouquets;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.body;
        return parseAddonPacks(jsonData);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      throw Exception('Failed to fetch data');
    }
  }
}

class AlacarteApis {
  static List<AlaCartePack> parsealaCartePacks(String responseBody) {
    final parsed = json.decode(responseBody)['data'];
    return parsed
        .where((pack) => pack['packType'] == 'ALACARETE_PACK')
        .map<AlaCartePack>((pack) {
      final channels = (pack['channels'] as List<dynamic>)
          .map<Channel>((channel) => Channel(
                name: channel['name'],
                description: channel['description'],
                number: channel['number'],
              ))
          .toList();

      return AlaCartePack(
        name: pack['name'],
        price: pack['price'],
        id: pack['id'].toString(),
        channels: channels,
      );
    }).toList();
  }

  static Future<List<AlaCartePack>> fetchData() async {
    String url = 'http://206.189.140.49:7070/admin/api/bouquet/getBouquets';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.body;
        return parsealaCartePacks(jsonData);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      throw Exception('Failed to fetch data');
    }
  }
}

class AddChannels {
  Future<void> makePutRequest() async {
    final Map<String, dynamic> requestBody = {
      "subscriberCode": "BAN0000001",
      "stbId": 34,
      "bouquetId": allItemID.join(","),
      "duration": 1,
    };

    final url = Uri.parse(baseURL + addSubscription);
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add the bearer token in the headers
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('PUT request successful');
      }
    } else {
      if (kDebugMode) {
        print('PUT request failed with status code: ${response.statusCode}');
      }
    }
  }
}

class RemoveChannelsAPI {
  static List<RemovePacksChannels> parseRemoveChannels(String responseBody) {
    final parsed = json.decode(responseBody)['data'];
    return parsed
        .where((pack) => pack['pack_type'] != 'BASE_PACK')
        .map<RemovePacksChannels>((pack) {
      return RemovePacksChannels(
        name: pack['bouquet_name'],
        id: pack['bouquet_id'].toString(),
      );
    }).toList();
  }

  static Future<List<RemovePacksChannels>> fetchData() async {
    String url = baseURL + getSubscriptionBySubscriberCodeAndStbIdActive;

    final Map<String, dynamic> requestBody = {
      "subscriberCode": "BAN0000001",
      "stbId": 34,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonData = response.body;
        return parseRemoveChannels(jsonData);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> removeChannels() async {
    final Map<String, dynamic> requestBody = {
      "subscriberCode": "BAN0000001",
      "stbId": 34,
      "bouquetIds": globalRemoveChannelIDs.join(",")
    };

    final url = Uri.parse(baseURL + removeSubscription);
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add the bearer token in the headers
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('PUT request successful, channels removed');
      }
    } else {
      if (kDebugMode) {
        print('PUT request failed with status code: ${response.statusCode}');
      }
    }
  }
}
