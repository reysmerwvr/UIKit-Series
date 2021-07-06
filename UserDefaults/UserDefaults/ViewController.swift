//
//  ViewController.swift
//  UserDefaults
//
//  Created by Reysmer Valle on 7/6/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        
        defaults.set(29, forKey: "Age")
        defaults.set(true, forKey: "UseFaceId")
        defaults.set(CGFloat.pi, forKey: "Pi")
        defaults.set("Reysmer Valle", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        defaults.set(["Hello", "Reysmer"], forKey: "SavedArray")
        defaults.set(["Name": "Reysmer"], forKey: "SavedDict")
        
        let savedInteger = defaults.integer(forKey: "Age")
        let savedBoolean = defaults.integer(forKey: "UseFaceId")
        
        let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        let savedDict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
        
    }
}

