// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:sudoku/banner.dart';
import 'package:sudoku/blokChar.dart';
import 'package:sudoku/focus_class.dart';
import 'package:sudoku/timer.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class SudokuWidget extends StatefulWidget {
  const SudokuWidget({super.key});

  @override
  State<SudokuWidget> createState() => _SudokuWidgetState();
}

class _SudokuWidgetState extends State<SudokuWidget> {
  //our variable
  List<BoxInner> boxInners = [];
  FocusClass focusClass = FocusClass();
  bool isFinish = false;
  String? tapBoxIndex;
  @override
  void initState() {
    generateSudoku();
    //implement init state
    super.initState();
  }

  void generateSudoku() {
    isFinish = false;
    focusClass = FocusClass();
    tapBoxIndex = null;
    generatePuzzle();
    checkFinish();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const CountUpTimerPage(),
        titleTextStyle: const TextStyle(fontSize: 10, ),
        actions: [
          ElevatedButton(
            onPressed: () => generateSudoku(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen.shade900,
            ),
            child: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 8),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  //height: 400,
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(1),
                  width: double.maxFinite,
                  //color: Colors.red,
                  alignment: Alignment.center,
                  child: GridView.builder(
                    itemCount: boxInners.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    physics: const ScrollPhysics(),
                    itemBuilder: ((buildContext, index) {
                      BoxInner boxInner = boxInners[index];

                      //print(boxInner.blokChars.length);

                      return Container(
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: GridView.builder(
                          itemCount: boxInner.blokChars.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                          ),
                          physics: const ScrollPhysics(),
                          itemBuilder: ((buildContext, indexChar) {
                            BlokChar blokChar = boxInner.blokChars[indexChar];
                            Color color = Colors.grey.shade900;
                            Color colorText = Colors.white;

                            //change color base condition

                            if (isFinish) {
                              color = Colors.lightGreen.shade900;
                            } else if (blokChar.isDefault) {
                              color = Colors.grey.shade800;
                            } else if (blokChar.isFocus) {
                              color = Colors.lightGreen.shade900;
                            }

                            if (tapBoxIndex == '${index} - ${indexChar}' &&
                                !isFinish) color = Colors.black54;

                            if (isFinish) {
                              colorText = Colors.white;
                            } else if (blokChar.isExist) {
                              colorText = Colors.redAccent.shade700;
                            }

                            return Container(
                              color: color,
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: blokChar.isDefault
                                    ? null
                                    : () => setFocus(index, indexChar),
                                child: Text.rich(
                                  TextSpan(text: '${blokChar.text}'),
                                  style:
                                      TextStyle(color: colorText, fontSize: 20),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
                const Divider(
                  height: 15,
                  color: Colors.white,
                ),
                Container(
                  child: Row(children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 160,
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GridView.builder(
                              itemCount: 9,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                              ),
                              physics: const ScrollPhysics(),
                              itemBuilder: ((buildContext, index) {
                                return ElevatedButton(
                                  onPressed: () => setInput(index + 1),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white)),
                                  child: Text.rich(
                                    TextSpan(text: '${index + 1}'),
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 34,
                        padding: const EdgeInsets.only(right: 8),
                        //color: Colors.orange,
                        child: ElevatedButton(
                          onPressed: () => setInput(null),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: const Text.rich(
                            TextSpan(text: 'Clear'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  generatePuzzle() {
    //install plugins sudoku generator to generate one
    boxInners.clear();
    var sudokuGenerator = SudokuGenerator(emptySquares: 54); //2
    //than populate to get a possible combination
    //quiver for easy populate collection using partition
    List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList();
    partition(sudokuGenerator.newSudoku,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList()
        .asMap()
        .entries
        .forEach((entry) {
      List<int> tempListCompletes =
          completes[entry.key].expand((element) => element).toList();
      List<int> tempList = entry.value.expand((element) => element).toList();

      tempList.asMap().entries.forEach((entryIn) {
        int index = entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() +
            (entryIn.key % 9).toInt() ~/ 3;

        if (boxInners.where((element) => element.index == index).isEmpty) {
          boxInners.add(BoxInner(index, []));
        }

        BoxInner boxInner =
            boxInners.where((element) => element.index == index).first;

        boxInner.blokChars.add(BlokChar(
          entryIn.value == 0 ? '' : entryIn.value.toString(),
          index: boxInner.blokChars.length,
          isDefault: entryIn.value != 0,
          isCorrect: entryIn.value != 0,
          correctText: tempListCompletes[entryIn.key].toString(),
        ));
      });
    });

    //print(boxInners);
    //complete generate puzzele sudoku
  }

  setFocus(int index, int indexChar) {
    tapBoxIndex = '${index}-${indexChar}';
    focusClass.setData(index, indexChar);
    showFocusCenterLine();
    setState(() {});
  }

  void showFocusCenterLine() {
    // set focus color for line vertical & horizontal
    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    for (var element in boxInners) {
      element.clearFocus();
    }

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach(
        (e) => e.setFocus(focusClass.indexChar!, Direction.Horizontal));

    boxInners
        .where((element) => element.index % 3 == colNoBox)
        .forEach((e) => e.setFocus(focusClass.indexChar!, Direction.Vertical));
  }

  setInput(int? number) {
    // set input data based grid
    //or clear out data
    if (focusClass.indexBox == null) return;
    if (boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text ==
            number.toString() ||
        number == null) {
      for (var element in boxInners) {
        element.clearFocus();
        element.clearExist();
      }
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setEmpty();
      tapBoxIndex = null;
      isFinish = false;
      showSameInputOnSameLine();
    } else {
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setText('$number');

      showSameInputOnSameLine();

      checkFinish();
    }

    setState(() {});
  }

  void showSameInputOnSameLine() {
    //show duplicate number on same line vert&horiz-so player know to have wrong value
    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    String textInput =
        boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text!;

    for (var element in boxInners) {
      element.clearExist();
    }

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Horizontal));

    boxInners.where((element) => element.index % 3 == colNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Vertical));

    List<BlokChar> exists = boxInners
        .map((element) => element.blokChars)
        .expand((element) => element)
        .where((element) => element.isExist)
        .toList();
    if (exists.length == 1) exists[0].isExist = false;
  }

  void checkFinish() {
    int totalUnfinish = boxInners
        .map((e) => e.blokChars)
        .expand((element) => element)
        .where((element) => !element.isCorrect)
        .length;
    isFinish = totalUnfinish == 0;
  }
}
