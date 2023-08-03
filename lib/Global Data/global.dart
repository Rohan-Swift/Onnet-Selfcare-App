class GlobalBasePack {
  List<String> selectedBasePackNamesG = [];
  List<String> selectedBasePackIDG = [];
  List<double> price = [];
}

class GlobalAddonPack {
  List<String> selectedAddonPackNamesG = [];
  List<String> selectedAddonPackIDG = [];
  List<double> price = [];
}

class GlobalAlaCarte {
  List<String> selectedAlacarteNamesG = [];
  List<String> selectedAlacarteIDG = [];
  List<double> price = [];
}

int count = 0;
GlobalBasePack globalBasePack = GlobalBasePack();
GlobalAddonPack globalAddonPack = GlobalAddonPack();
GlobalAlaCarte globalAlaCarte = GlobalAlaCarte();

List<String> allItemNames = [];
List<String> allItemID = [];
List<double> allItemPrices = [];
List<String> userSelectedChannels = [];
List<String> globalRemoveChannels = [];
List<String> globalRemoveChannelIDs = [];
String token = '';
