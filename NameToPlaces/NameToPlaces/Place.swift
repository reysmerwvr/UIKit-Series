//
//  Place.swift
//  NameToPlaces
//
//  Created by Reysmer Valle on 6/24/21.
//

import UIKit

class Place: Comparable {
    static func < (lhs: Place, rhs: Place) -> Bool {
        return lhs.image < rhs.image
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.image == rhs.image
    }
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
