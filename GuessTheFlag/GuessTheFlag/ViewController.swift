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
    var answeredQuestions = 0
    var correctAnswer = 0
    var maxNumberOfAnswers = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        print(defaults.integer(forKey: "highestScore"))
        countries += ["estonia", "france", "germany", "ireland", "italy",
                      "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareScore))
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
        title = countries[correctAnswer].uppercased()
        title = "\(title!) - Score: \(score)"
    }
    
    func endGame(action: UIAlertAction! = nil) {
        for button in buttons {
            button.isUserInteractionEnabled = false
        }
        title = "Final Score: \(score)"
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        } completion: { finished in
            sender.transform = .identity
            self.validateAnswer(sender)
        }
    }
    
    func validateAnswer(_ sender: UIButton) {
        var title: String
        var message: String
        answeredQuestions += 1
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, you've selected the flag of \(countries[sender.tag].uppercased())"
            score = score > 0 ? score - 1 : 0
        }
        if answeredQuestions >= maxNumberOfAnswers {
            title = "You have reached the max number of answers (\(maxNumberOfAnswers))"
            message = "Your final score is: \(score)"
            let defaults = UserDefaults.standard
            let highestScore = defaults.integer(forKey: "highestScore")
            if score > highestScore {
                defaults.set(score, forKey: "highestScore")
                message = "Your new highest score is: \(score)"
            }
            showAlert(title: title, handler: endGame, message: message)
        } else {
            message = "Your score is: \(score)"
            showAlert(title: title, handler: askQuestion, message: message)
        }
    }
    
    func showAlert(title: String, handler: ((UIAlertAction)-> Void)?, message: String = "",
                   style: UIAlertController.Style = .alert, actionStyle: UIAlertAction.Style = .default,
                   actionTitle: String = "Continue", animated: Bool = true) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: handler))
        present(alertController, animated: animated)
    }
    
    @objc func shareScore() {
        let vc = UIActivityViewController(activityItems: ["Score: \(score)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

