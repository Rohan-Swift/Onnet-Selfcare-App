class Channel {
  final String name;
  final String description;
  final int number;

  Channel({
    required this.name,
    required this.description,
    required this.number,
  });
}

class BasePack {
  final String name;
  final double price;
  final String id;
  final List<Channel> channels;

  BasePack({
    required this.name,
    required this.price,
    required this.id,
    required this.channels,
  });
}

class AddonPack {
  final String name;
  final double price;
  final String id;
  final List<Channel> channels;

  AddonPack({
    required this.name,
    required this.price,
    required this.id,
    required this.channels,
  });
}

class AlaCartePack {
  final String name;
  final double price;
  final String id;
  final List<Channel> channels;

  AlaCartePack({
    required this.name,
    required this.price,
    required this.id,
    required this.channels,
  });
}

class RemovePacksChannels {
  final String name;
  final String id;

  RemovePacksChannels({required this.name, required this.id});
}
