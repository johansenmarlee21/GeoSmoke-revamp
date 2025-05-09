//
//  UserFilterPrefence.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 09/05/25.
//


struct UserFilterPrefence: Codable{
    enum SortMethod: String, CaseIterable, Codable{
        case nearest
        case furtheset
    }
    
    enum Ambience: String, CaseIterable, Codable{
        case dark
        case bright
    }
    
    enum CrowdLevel: String, CaseIterable, Codable{
        case quiet
        case crowded
    }
    
    enum CigaretteTypes: String, CaseIterable, Codable{
        case cigarette
        case eCigarette
    }
    
    
    var sortMethod: SortMethod
    var ambience: Ambience?
    var selectedFacilities: [String]
    var cigaretteTypes: [CigaretteTypes]
}
