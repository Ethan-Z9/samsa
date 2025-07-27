// lib/pages/match_scout.dart

import 'package:flutter/material.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/header/app_header.dart';
import 'package:frc_scout_app/form/draggable_resizable_card.dart';

import 'package:frc_scout_app/form/basic_inputs/counter.dart';
import 'package:frc_scout_app/form/basic_inputs/number.dart';
import 'package:frc_scout_app/form/basic_inputs/toggle_switch.dart';
import 'package:frc_scout_app/form/basic_inputs/text_input.dart';

import 'package:frc_scout_app/form/selection_inputs/checkbox.dart';
import 'package:frc_scout_app/form/selection_inputs/radio.dart';
import 'package:frc_scout_app/form/selection_inputs/selection.dart';
import 'package:frc_scout_app/form/selection_inputs/slider.dart';

import '';


import '';

class MatchScout extends StatelessWidget {
  const MatchScout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Match Scout'),
      drawer: const AppDrawer(),
      body: Stack(
        children: const [

          DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: Counter(label: 'Score Counter'),
          ),

          DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: Number(label: 'Score Total'),
          ),
          
          DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: ToggleSwitch(label: 'Power', leftLabel: 'Off', rightLabel: 'On'),
          ),

          DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: TextInput(label: 'Comment'),
          ),

          DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: CheckboxInput(label: 'Check'),
          ),

          /*DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: Radio(label: 'Comment'),
          ),

          DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: Selection(label: 'Comment'),
          ),*/

          DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: SliderInput(label: 'Slider'),
          ),





        ],
      ),
    );
  }
}
