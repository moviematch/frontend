import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'LoadIndicator.dart';
import 'colours.dart';
import 'package:openapi/api.dart';
import 'CountryButton.dart';
import 'room_prefs.dart';
import 'country_cache.dart';
import 'SettingDropdownState.dart';

class CountrySelector extends StatefulWidget {
  final Room room;
  final void Function(Room room, bool refreshSettings) updateRoom;

  CountrySelector({this.room, this.updateRoom});

  @override
  State<StatefulWidget> createState() {
    return _CountrySelectorState(room, updateRoom);
  }
}

class _CountrySelectorState extends SettingDropdownState {
  _CountrySelectorState(
      Room room, void Function(Room room, bool refreshSettings) updateRoom)
      : super(room, updateRoom);

  @override
  void setupModifications(
      Room currentRoom,
      void Function(Room modificationsOnly) finish,
      void Function(Room updatedRoom) fullRoomUpdate) {
    for (User user in currentRoom.users) {
      if (user.me) {
        user.countries = [];
        for (Country c in CountryCache.loadedCountries) {
          if (RoomPrefs.I().getCountryIds().contains(c.id)) {
            user.countries.add(c);
          }
        }
      }
    }
    finish(Room(countries: RoomPrefs.I().getCountriesFromIds()));
    fullRoomUpdate(currentRoom);
  }

  @override
  Widget build(BuildContext context) {
    if (CountryCache.loadedCountries != null) {
      return _countryList(context, CountryCache.loadedCountries);
    }
    return FutureBuilder(
        future: CountryCache.loadCountries(),
        builder: (context, future) {
          if (future.connectionState != ConnectionState.done) {
            return LoadIndicator(colours: [Green, Yellow, Grey]);
          } else {
            if (future.data == null) {
              return Text(
                  'Unavailable; please check your internet connection.');
            } else {
              return _countryList(context, future.data);
            }
          }
        });
  }

  Widget _countryList(BuildContext context, List<Country> countries) {
    String selectedCountryNames = "";
    for (Country country in countries) {
      if (RoomPrefs.I().getCountryIds().contains(country.id)) {
        if (selectedCountryNames.length > 0) selectedCountryNames += ", ";
        selectedCountryNames += country.name;
      }
    }

    return dropdownContainer(context,
        icon: Icons.language,
        title: 'Countries',
        subtitle: selectedCountryNames.length > 0
            ? selectedCountryNames
            : 'No countries selected yet',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Select the country you will be watching from. You can select several countries, for example if you have access to a VPN. Everyone in the room gets a chance to select their own list of countries.'),
            SizedBox(height: 8),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 1.3,
                  maxCrossAxisExtent: 48,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemCount: countries.length,
              itemBuilder: (context, index) => CountryButton(
                  country: countries[index], change: super.modifyRoom),
            )
          ],
        ));
  }
}
