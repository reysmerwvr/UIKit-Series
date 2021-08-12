//
//  ViewController.swift
//  Debugging
//
//  Created by Reysmer Valle on 8/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("I'm inside the viewDidLoad")
        print(1, 2, 3, separator: "-")
        print("Some message", terminator: "")
        
        assert(1 == 1, "Math failure!")
//        assert(1 == 2, "Math failure!")
        
        for i in 1...100 {
            print("Got number \(i).")
        }
    }


}
