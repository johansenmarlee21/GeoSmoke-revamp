//
//  SmokingAreaModel.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 09/05/25.
//

import Foundation
import SwiftData

@Model
class SmokingArea: Identifiable {
    var id: UUID
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
    
    init(
        id: UUID = UUID(),
        name: String,
        location: String,
        longitude: Double,
        latitude: Double,
        photo: String,
        allPhoto: [String],
        disposalPhoto: String,
        disposalDirection: String,
        isFavorite: Bool,
        ambience: String,
        crowdLevel: String,
        facilities: [String],
        cigaretteTypes: [String]
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.longitude = longitude
        self.latitude = latitude
        self.photo = photo
        self.allPhoto = allPhoto
        self.disposalPhoto = disposalPhoto
        self.disposalDirection = disposalDirection
        self.isFavorite = isFavorite
        self.ambience = ambience
        self.crowdLevel = crowdLevel
        self.facilities = facilities
        self.cigaretteTypes = cigaretteTypes
    }
}




