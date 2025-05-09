//
//  SmokingAreaModel.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 09/05/25.
//

import Foundation
import SwiftData

struct SmokingArea{
    var name: String
    var location: String
    var longitude: Double
    var latitude: Double
    var photo: String
    var allPhoto: [String]
    var disposalPhoto: String
    var disposalDirection: String
    var isFavorite: Bool
    
    var ambience: String
    var crowdLevel: String
    var facilities: [String]
    var cigaretteTypes: [String]
    
}


