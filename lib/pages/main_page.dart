import 'package:flutter/material.dart';
import 'package:flutter_fight_club/pages/fight_page.dart';
import 'package:flutter_fight_club/pages/statistics_page.dart';
import 'package:flutter_fight_club/resources/FightClubImages.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

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
            Center(
              child: Text(
                "Last Fight Result",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: FightClubColors().darkGreyText,
                ),
              ),
            ),
            SizedBox(height: 16),
            FightResultWidget(),

            Expanded(child: SizedBox()),
            SecondaryActionButton(
              text: "Statistics".toUpperCase(),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StatisticsPage()
                )
                );
              },
            ),
            SizedBox(height: 16),
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

class FightResultWidget extends StatelessWidget {

  const FightResultWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        height: 160,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: ColoredBox(
                      color: FightClubColors().whiteBackground,
                    )),
                Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.white,
                            FightClubColors().purpleBackround
                          ])),
                    )),
                Expanded(
                    child: ColoredBox(
                      color: FightClubColors().purpleBackround,
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SizedBox(height: 16),
                    Text("You"),
                    SizedBox(height: 12),
                    SizedBox(
                      width: 92,
                      height: 92,
                      child: Image.asset(FightClubImages.enemy),
                    )
                  ],
                ),
                SizedBox(
                    height: 44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(22),
                          color: FightClubColors().blueButton
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                        child: Center(
                          child: FutureBuilder<String?>(
                              future: SharedPreferences.getInstance().then(
                                      (sharedPrerences) => sharedPrerences.getString("last_fight_result")),
                              builder: (context, snapshot){
                                if (!snapshot.hasData || snapshot.data == null){
                                  return Text("VS", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),);
                                }
                                return Center(child: Text(snapshot.data!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),));
                              }),
                        ),
                      ),
                    )),
                Column(
                  children: [
                    SizedBox(height: 16),
                    Text("Enemy"),
                    SizedBox(height: 12),
                    SizedBox(
                      width: 92,
                      height: 92,
                      child: Image.asset(FightClubImages.you),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}