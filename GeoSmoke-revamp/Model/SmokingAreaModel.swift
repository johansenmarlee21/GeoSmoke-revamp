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
    var photoURL: String
    var disposalPhotoURL: String
    var disposalDirection: String
    var isFavorite: Bool
    var facilityGrade: String
    
    var ambience: String
    var crowdLevel: String
    var cigaretteTypes: [String]
    
}


