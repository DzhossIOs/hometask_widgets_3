import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';

class SecondaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SecondaryActionButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(color: FightClubColors().blackButton, width: 2)),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: FightClubColors().blackButton),
        ),
      ),
    );
  }
}