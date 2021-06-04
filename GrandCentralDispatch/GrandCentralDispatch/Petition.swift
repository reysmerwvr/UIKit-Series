//
//  Petition.swift
//  WhPetitions
//
//  Created by Reysmer Valle on 5/18/21.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
