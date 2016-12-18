//
//  CoordinateConvertor.swift
//  geo-quiz
//
//  Created by stefan on 12/16/16.
//  Copyright © 2016 stefan. All rights reserved.
//

import Foundation

class CoordinateConvertor{
  static func convert(inputs: String) -> Double{
    var inStr = inputs
    var retNum = 0.0
    switch inStr.remove(at: inStr.index(before: inStr.endIndex)) {
    case "N", "E", "n", "e":
      retNum = Double(inStr)!
      break
    case "S", "W", "s", "w":
      retNum = Double(inStr)!
      retNum *= -1
      break
    default:
      retNum = 0.0
    } // END SWITCH STATEMENT
    return retNum
  } // END METHOD convert
}
