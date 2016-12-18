//
//  Capital.swift
//  geo-quiz
//
//  Created by stefan on 12/16/16.
//  Copyright © 2016 stefan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Capital: NSObject, MKAnnotation{
  /** MKAnnotation Attributes */
  var title: String?
  var coordinate: CLLocationCoordinate2D
  var info: String
  
  /** Custom Attributes */
  var capital: String?
  
  override  var description: String{
    return title! + "," + capital! + "\n"
  }
  
  init(title: String, coordinate: CLLocationCoordinate2D, info: String, cap: String) {
    self.title      = title
    self.coordinate = coordinate
    self.info       = info
    self.capital     = cap
  } // END METHOD init
  
  func setNation(cap: String) -> Void {
    self.capital = cap
  }
  
  func getNation() -> String {
    if (self.capital?.isEmpty)!{
      return "Default Nation"
    }
    return self.capital!
  }
} // END CLASS Capital

class Quiz{
  var nation: String?
  var correct: String?
  var options = [String]()
  
  init(nat: String, cor: String, opt: [String]) {
    nation = nat
    correct = cor
    options = opt
  } // END CONSTRUCTOR
  
  func isCorrect(usrAnswer: Int) -> Bool {
    if (options[usrAnswer] == correct){
      return true
    }
    return false
  } // END METHOD isCorrect
  
  func getQuestion() -> String {
    return "What is the capital city of " + self.nation! + " ?"
  }
  
  func getOptionByIndex(index: Int) -> String{
    if (index <= options.count && index >= 0){
      return options[index]
    }
    return "default - invalid index"
  }
  
} // END CLASS Quiz
