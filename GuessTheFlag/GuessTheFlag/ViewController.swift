//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Reysmer Valle on 1/23/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonThree: UIButton!
    
    
    var buttons: [UIButton] = [UIButton]()
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy",
        "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        buttons += [buttonOne, buttonTwo, buttonThree]
        configureButtons()
        askQuestion()
    }
    
    func configureButtons() {
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        for (index, button) in buttons.enumerated() {
            button.setImage(UIImage(named: countries[index]), for: .normal)
        }
        title =  countries[correctAnswer].uppercased()
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        let alertController = UIAlertController(title: title, message: "Your score is: \(score)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestteion))
        present(alertController, animated: true)
    }
}

