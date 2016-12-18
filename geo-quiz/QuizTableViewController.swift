//
//  QuizTableViewController.swift
//  geo-quiz
//
//  Created by stefan on 12/17/16.
//  Copyright © 2016 stefan. All rights reserved.
//

import UIKit

class QuizTableViewController: UIViewController {
  /** CONSTANTS */
  let NUM_OF_ROWS: Int = 4
  let TABLE_CELL_IDENTIFIER: String = "quizOpt"
  
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var quizHeader: UIView!
  @IBOutlet weak var quizTable: UITableView!
  
  var selectedQuiz: Quiz? = nil
  var qFlag: Bool = false
  var currScore: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.setHeader()
    
    // TESTING  /////////////////////////
    let temp = selectedQuiz?.options
    for s in temp!{
      print(s)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setHeader()->Void{
    if selectedQuiz != nil{
      self.headerLabel.text = self.selectedQuiz?.getQuestion()
    }
    else{
      self.headerLabel.text = "Default Question - Invalid Quiz object passing through segue"
    }
    self.qFlag = false
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
} // END CLASS QuizTableViewController

extension QuizTableViewController: UITableViewDelegate, UITableViewDataSource{
  /** TableView Initialization */
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.NUM_OF_ROWS // your number of cell here
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //let cell = QuizOption()
    let cell = tableView.dequeueReusableCell(
      withIdentifier: self.TABLE_CELL_IDENTIFIER, 
      for: indexPath
      ) as! QuizOption
    print("initializing cells")
    //for q in (selectedQuiz?.options)!{
    //  print(q)
    //}
    
    cell.option.text = selectedQuiz?.options[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // cell selected code here
    //let selectedCity = tableView.cellForRow(at: indexPath)
    if (self.selectedQuiz?.isCorrect(usrAnswer: indexPath.row))!{
      self.qFlag = true
      self.currScore += 1
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      if self.currScore == appDelegate.unAnsweredCapitals.count{
        let rAlert = UIAlertController(
          title: "Result", 
          message: "You win !!! You have \(self.currScore) points.", 
          preferredStyle: UIAlertControllerStyle.alert)
        
        rAlert.addAction(UIAlertAction(
          title: "Ok", style: .default, 
          handler: { 
            (action: UIAlertAction!) in
            UIControl().sendAction(
              #selector(URLSessionTask.suspend), 
              to: UIApplication.shared, 
              for: nil
            )
        }))
        present(rAlert, animated: true, completion: nil)
      } // END IF

      
      let rAlert = UIAlertController(
        title: "Result", 
        message: "Correct!!! You have \(self.currScore) points", 
        preferredStyle: UIAlertControllerStyle.alert)
      
      rAlert.addAction(UIAlertAction(
        title: "Ok", style: .default, 
        handler: { 
          (action: UIAlertAction!) in
          self.performSegue(withIdentifier: "fromQuizToMapSegue", sender: self)
      }))
      present(rAlert, animated: true, completion: nil)
    }
    else{
      let rAlert = UIAlertController(
        title: "Result", 
        message: "Incorrect!!!", 
        preferredStyle: UIAlertControllerStyle.alert)
      
      rAlert.addAction(UIAlertAction(
        title: "Ok", style: .default, 
        handler: { 
          (action: UIAlertAction!) in
          self.performSegue(withIdentifier: "fromQuizToMapSegue", sender: self)
      }))
      present(rAlert, animated: true, completion: nil)
    }
  }
  
  // PREPARE FOR SEGUE
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //print("prepare called - QuizTable")
    if segue.identifier == "fromQuizToMapSegue"{
      if let destination = segue.destination as? ViewController {        
        destination.flag = self.qFlag
        destination.currScore = self.currScore
      }
    }
  } // END METHOD prepare
}

class QuizOption: UITableViewCell{
  @IBOutlet weak var option: UILabel!
  
}
