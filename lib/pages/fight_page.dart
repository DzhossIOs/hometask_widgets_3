import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_icons.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  _FightPageState createState() => _FightPageState();
}

class _FightPageState extends State<FightPage> {
  static const maxLives = 5;
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  String centerText = "";
  int yourLives = maxLives;
  int enemysLives = maxLives;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FightClubColors().background,
        body: SafeArea(
          child: Column(children: [
            FightersInfoWidget(
              maxLivesCount: maxLives,
              yourLivesCount: yourLives,
              enemysLivesCount: enemysLives,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
              child: SizedBox(
                width: double.maxFinite,
                child: ColoredBox(
                  color: FightClubColors().infoBlockBackroundColor,
                  child: Center(
                    child: Text(
                      centerText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )),
            ControlsWidget(
              defendingBodyPart: defendingBodyPart,
              attackingBodyPart: attackingBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            SizedBox(height: 14),
            ActionButton(
              text: yourLives == 0 || enemysLives == 0 ? "Back" : "GO",
              onTap: _onGoButtonClicked,
              color: _getGoButtonColor(),
            ),
            SizedBox(height: 16)
          ]),
        ));
  }

  Color _getGoButtonColor() {
    if (yourLives == 0 || enemysLives == 0) {
      return FightClubColors().blackButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return FightClubColors().greyButton;
    } else {
      return FightClubColors().blackButton;
    }
  }

  void _onGoButtonClicked() {
    if (yourLives == 0 || enemysLives == 0) {
      Navigator.of(context).pop();
    } else if (attackingBodyPart != null && defendingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (youLoseLife) {
          yourLives -= 1;
        }
       final FightResult? fightResult = FightResult.calculateResult(enemysLives, yourLives);
        if (fightResult != null){
            SharedPreferences.getInstance().then((sharedPreferences){
              sharedPreferences.setString("last_fight_result", fightResult.result);
            });
        }


        centerText = _calculateCenterText(youLoseLife, enemyLoseLife);
        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();
        attackingBodyPart = null;
        defendingBodyPart = null;
      });
    }
  }

  String _calculateCenterText(
      final bool youLoseLife, final bool enemyLoseLife) {
    if (enemysLives == 0 && yourLives == 0) {
      return "Draw";
    } else if (yourLives == 0) {
      return "You lose";
    } else if (enemysLives == 0) {
      return "You win";
    } else {
      final String first = enemyLoseLife
          ? "You hit enemy's ${attackingBodyPart!.name.toLowerCase()}"
          : "You attack was blocked";
      final String second = youLoseLife
          ? "Enemy hit enemy's ${attackingBodyPart!.name.toLowerCase()}"
          : "Enemy's attack was blocked";
      return "$first\n$second";
    }
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }
}

class FightersInfoWidget extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;

  const FightersInfoWidget({
    super.key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemysLivesCount,
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
                LivesWidget(
                    overallLivesCount: maxLivesCount,
                    currentLivesCount: yourLivesCount),
                Column(
                  children: [
                    SizedBox(height: 16),
                    Text("You"),
                    SizedBox(height: 12),
                    SizedBox(
                      width: 92,
                      height: 92,
                      child: Image.asset(FightClubIcons.enemy),
                    )
                  ],
                ),
                SizedBox(
                    height: 44,
                    width: 44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: FightClubColors().blueButton),
                      child: Center(
                        child: Text(
                          "VS",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
                      child: Image.asset(FightClubIcons.you),
                    )
                  ],
                ),
                LivesWidget(
                    overallLivesCount: maxLivesCount,
                    currentLivesCount: enemysLivesCount)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget(
      {super.key,
      required this.defendingBodyPart,
      required this.attackingBodyPart,
      required this.selectDefendingBodyPart,
      required this.selectAttackingBodyPart});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text('Defend'.toUpperCase()),
              SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text('Attack'.toUpperCase()),
              SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(overallLivesCount, (index) {
        if (index < currentLivesCount) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
            child: Image.asset(FightClubIcons.heartFull, width: 18, height: 18),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
            child:
                Image.asset(FightClubIcons.heartEmpty, width: 18, height: 18),
          );
        }
      }),
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    super.key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? FightClubColors().blueButton : Colors.transparent,
            border: !selected
                ? Border.all(color: FightClubColors().darkGreyText, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: TextStyle(
                  color: selected
                      ? FightClubColors().whiteText
                      : FightClubColors().darkGreyText),
            ),
          ),
        ),
      ),
    );
  }
}
