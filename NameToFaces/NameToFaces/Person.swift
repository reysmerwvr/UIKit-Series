//
//  Person.swift
//  NameToFaces
//
//  Created by Reysmer Valle on 6/9/21.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
