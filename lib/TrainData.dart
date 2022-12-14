import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'dataUtil.dart';

class TrainData {
  final DateTime time;
  final TrainName name;
  final String service;
  final String destination;

  TrainData(this.time, this.name, this.service, this.destination);
}

class TrainDataList {
  final List<TrainData> _kudariList = [];
  final List<TrainData> _noboriList = [];

  TrainDataList() {
    Future<File> kudariFile;
    Future<File> noboriFile;
    if (DateTime.now().weekday == DateTime.sunday) {
    } else if (DateTime.now().weekday == DateTime.saturday) {
    } else {}
    kudariFile = DataUtil.getFileFromAssets("h-u.csv");
    noboriFile = DataUtil.getFileFromAssets("h-t.csv");
    _TrainDataFormat dataFormat = _TrainDataFormat();

    kudariFile.then((value) {
      value.readAsLines().then((texts) {
        for (String text in texts) {
          List<String> list = text.split(',');
          if (list.isNotEmpty) {
            _kudariList.add(dataFormat.formatData(list));
          }
        }
      });
    });

    noboriFile.then((value) {
      value.readAsLines().then((texts) {
        for (String text in texts) {
          List<String> list = text.split(',');
          if (list.isNotEmpty) {
            _noboriList.add(dataFormat.formatData(list));
          }
        }
      });
    });
  }

  List<TrainData> getData(int num, bool isNobori) {
    List<TrainData> result = [];
    List<TrainData> array = isNobori ? _noboriList : _kudariList;
    int index = 0;
    for (TrainData data in array) {
      if (data.time.isAfter(kDebugMode
          ? DateTime(2022, 6, 21, 3, 0)
          : DateTime.now().add(const Duration(minutes: 3)))) {
        for (int a = 0; a < num; a++) {
          if (a + index < array.length) {
            result.add(array[a + index]);
          } else {
            break;
          }
        }
        break;
      }
      index++;
    }

    return result;
  }

  static String getTrainName(TrainName trainName) {
    switch (trainName) {
      case TrainName.shonanShinjukuLine:
        return "?????????????????????";
      case TrainName.uenoTokyoLine:
        return "?????????????????????";
      case TrainName.utsunomiyaLine:
        return "????????????";
      case TrainName.nikkoLine:
        return "?????????";
      case TrainName.ryomoLine:
        return "?????????";
      case TrainName.mitoLine:
        return "?????????";
    }
  }
}

enum TrainName {
  shonanShinjukuLine,
  uenoTokyoLine,
  utsunomiyaLine,
  nikkoLine,
  ryomoLine,
  mitoLine
}

class _TrainDataFormat {
  TrainData formatData(List<String> csvLine) {
    TrainName trainName = TrainName.utsunomiyaLine;
    String trainService = "??????";
    String destination = "??????";
    DateFormat format = DateFormat("yyyy/MM/dd HH:mm");

    if (csvLine.length == 1 || csvLine[1] == "") {
      trainName = TrainName.utsunomiyaLine;
      trainService = "??????";
      destination = "?????????";
    } else if (csvLine.length > 1 && csvLine[1] != "???") {
      switch (csvLine[1]) {
        case "???":
          trainName = TrainName.uenoTokyoLine;
          trainService = "??????";
          destination = "??????";
          break;

        case "???":
          trainName = TrainName.shonanShinjukuLine;
          trainService = "??????";
          destination = "??????";
          break;

        case "???":
          trainName = TrainName.utsunomiyaLine;
          trainService = "??????";
          destination = "??????";
          break;

        case "???":
          trainName = TrainName.uenoTokyoLine;
          trainService = "??????";
          destination = "?????????";
          break;

        case "???":
          trainName = TrainName.uenoTokyoLine;
          trainService = "??????";
          destination = "??????";
          break;

        case "???":
          trainName = TrainName.uenoTokyoLine;
          trainService = "??????";
          destination = "??????";
          break;

        case "???":
          trainName = TrainName.shonanShinjukuLine;
          trainService = "??????";
          destination = "??????";
          break;

        case "???":
          trainName = TrainName.uenoTokyoLine;
          trainService = "??????";
          destination = "?????????";
          break;

        case "???":
          trainName = TrainName.uenoTokyoLine;
          trainService = "??????";
          destination = "??????";
          break;

        case "???":
          trainName = TrainName.utsunomiyaLine;
          trainService = "??????";
          destination = "??????";
          break;

        case "???":
          trainName = TrainName.nikkoLine;
          trainService = "??????";
          destination = "??????";
          break;

        case "???":
          trainName = TrainName.utsunomiyaLine;
          trainService = "??????";
          destination = "??????";
      }
    } else {
      switch (csvLine[2]) {
        case "???":
          trainName = TrainName.shonanShinjukuLine;
          trainService = "??????";
          destination = "??????";
          break;
        case "???":
          trainName = TrainName.utsunomiyaLine;
          trainService = "??????????????????";
          destination = "??????";
          break;
        case "???":
          trainName = TrainName.utsunomiyaLine;
          trainService = "??????";
          destination = "?????????";
      }
    }
    DateTime nowTime = kDebugMode ? DateTime(2022, 6, 21) : DateTime.now();
    DateTime time = format.parseStrict(nowTime.year.toString() +
        "/" +
        nowTime.month.toString() +
        "/" +
        nowTime.day.toString() +
        " " +
        csvLine[0]);

    if (time.hour < 1) {
      time.add(const Duration(days: 1));
    }
    return TrainData(time, trainName, trainService, destination);
  }
}
