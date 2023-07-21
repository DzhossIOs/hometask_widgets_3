import 'package:flutter/material.dart';
import 'package:flutter_fight_club/pages/fight_page.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaigPage extends StatelessWidget {
  const MaigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MainPageContext();
  }
}

class _MainPageContext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors().background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            Center(
              child: Text(
                "The\nFight\nClub".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: FightClubColors().darkGreyText,
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            FutureBuilder<String?>(
              future: SharedPreferences.getInstance().then(
                      (sharedPrerences) => sharedPrerences.getString("last_fight_result")),
              builder: (context, snapshot){
                if (!snapshot.hasData || snapshot.data == null){
                  return const SizedBox();
                }
                return Center(child: Text(snapshot.data!));
              }),
            Expanded(child: SizedBox()),
            ActionButton(
              text: "Start".toUpperCase(),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FightPage()
                  )
                );
              },
              color: FightClubColors().blackButton,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
