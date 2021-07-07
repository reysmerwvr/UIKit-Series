//
//  Person.swift
//  NameToFaces
//
//  Created by Reysmer Valle on 6/9/21.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) -> Void {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}

//class Person: NSObject, Codable {
//    var name: String
//    var image: String
//
//    init(name: String, image: String) {
//        self.name = name
//        self.image = image
//    }
//}

