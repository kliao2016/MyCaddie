//
//  Stats2.swift
//  MyCaddie
//
//  Created by Weston Mauz on 6/6/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class Stats2: UIViewController {
    
    var shotCount = String()
    
    var holeScores = [4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]
    
    // Label text to change every shot
    @IBOutlet weak var ShotNumberText: UILabel!
    // currentScore Display
    @IBOutlet weak var Actual: UILabel!
    
    var putts = Int ()
    var currentHole = Int()
    var currentScore = Int()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        currentHole = 1
        
        // Initial text
        ShotNumberText.text = "Where was your first shot?"
        Actual.text = "Shots hit: 0"
        
        //self.ShotNumberText.text = "Where was your " + shotCount + " shot?"
        //self.Actual.text = "Shot Count: " + "\(currentScore)"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func PuttPopUp() {
        let popUp = UIAlertController(title: "How many putts did you have?", message: nil, preferredStyle: .alert)
        popUp.addTextField { (textField) in
            textField.text = "Putts"
        }
        
        popUp.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [popUp] (_) in
            let textField = popUp.textFields![0] // Force unwrapping because we know it exists.
            print("Putts: \(textField.text ?? "No")")
            self.putts = Int(textField.text!)!
            self.updateScore()
        }))
        
        //let action = UIAlertAction(title: "Enter", style: .default, handler: nil)
        //popUp.addAction(action)
        self.present(popUp, animated: true, completion: nil)
        //print("Putt Text Field: \(String(describing: textField.text))")
    }
    
    // Buttons
    @IBAction func Green(_ sender: Any) {
        currentScore += 1
        PuttPopUp()
    }
    @IBAction func Fringe(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func GreenSand(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func FairwaySand(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Fairway(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Hazard(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func OB(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Right(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Left(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateShotText() {
        switch currentScore {
        case 0:
            shotCount = "first"
            break
        case 1:
            shotCount = "second"
            break
        case 2:
            shotCount = "third"
            break
        case 3:
            shotCount = "fourth"
            break
        case 4:
            shotCount = "fifth"
            break
        case 5:
            shotCount = "sixth"
            break
        case 6:
            shotCount = "seventh"
            break
        case 7:
            shotCount = "eighth"
            break
        case 8:
            shotCount = "ninth"
            break
        case 9:
            shotCount = "tenth"
            break
        default:
            shotCount = "????"
        }
    }
    
    func updateUI(){
        Actual.text = "Shots Hit: \(currentScore)"
        ShotNumberText.text = "Where was your \(shotCount) shot?"
    }
    
    func updateScore(){
        holeScores[currentHole - 1] = currentScore + putts
        print("Non-Putts: " + "\(currentScore)")
        print("Putts: " + "\(holeScores)")
        currentHole += 1
        putts = 0
        currentScore = 0
        updateShotText()
        updateUI()
    }
    
    
}
