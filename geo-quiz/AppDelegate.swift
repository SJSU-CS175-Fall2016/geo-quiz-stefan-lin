//
//  AppDelegate.swift
//  geo-quiz
//
//  Created by stefan on 12/16/16.
//  Copyright © 2016 stefan. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  /** Custom Attributes */
  let inputFileName: String = "inputs"
  let inputFileType: String = "txt"
  //var unAnsweredCapitals = [Capital]()
  //var answeredCapitals = [Capital]()
  var unAnsweredCapitals = [String:Capital]()
  var answeredCapitals = [String:Capital]()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    self.readFromFile()
    print("unAnsweredCapitals.count = ")
    print(unAnsweredCapitals.count)
    /**
    print(unAnsweredCapitals.count)
    for i in unAnsweredCapitals{
      print(i)
    }*/
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  private func readFromFile(){
    if let fPath = Bundle.main.path(forResource: self.inputFileName, ofType: self.inputFileType){
      if let aStreamReader = StreamReader(path: fPath) {
        defer {
          aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {
          print(line)
          print("\n")
          
          /** Parsing comma separated string */
          // Trim newline
          let trimedString = line.trimmingCharacters(in: CharacterSet.newlines)
          //var nationInfo = split(trimedString) {$0 = ","}
          var nationInfo = trimedString.components(separatedBy: ",")
          
          if nationInfo.count == 4{
            self.unAnsweredCapitals[nationInfo[0]] = Capital(
              title: nationInfo[0], 
              coordinate: CLLocationCoordinate2D(
                latitude: CoordinateConvertor.convert(inputs: nationInfo[2]),
                longitude: CoordinateConvertor.convert(inputs: nationInfo[3])
              ), 
              info: "default", 
              cap: nationInfo[1]
            )
            //self.unAnsweredCapitals.append(Capital(
            //  title: nationInfo[1], 
            //  coordinate: CLLocationCoordinate2D(
            //    latitude: CoordinateConvertor.convert(inputs: nationInfo[2]), 
            //    longitude: CoordinateConvertor.convert(inputs: nationInfo[3])
            //  ), 
            //  info: "default", 
            //  nat: nationInfo[0]
            //))
          } // END IF STATEMENT
          else{
            print("Invalid input data - skip")
          }
        } // END WHILE LOOP
      } // END IF STATEMENT
    } // END IF STATEMENT
    else {
      puts("file not found")
    } // END IF-ELSE STATEMENT
  } // END METHOD readFromFile
}

