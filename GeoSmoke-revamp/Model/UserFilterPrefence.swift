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
    
    enum Facilities: String, CaseIterable, Codable{
        case chair
        case roof
        case wasteBin
    }
    
    enum CigaretteTypes: String, CaseIterable, Codable{
        case cigarette
        case eCigarette
    }
    
    
    
    var sortMethod: SortMethod
    var ambience: Ambience?
    var selectedFacilities: [Facilities]
    var cigaretteTypes: [CigaretteTypes]
}
