//
//  UserFilterPrefence.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 09/05/25.
//


struct UserFilterPrefence: Codable{
    enum SortMethod: String, CaseIterable, Codable{
        case nearest
        case furthest
    }
    
    enum Ambience: String, CaseIterable, Codable{
        case dark
        case bright
        case all
    }
    
    enum CrowdLevel: String, CaseIterable, Codable{
        case quiet
        case crowded
        case all
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
    var crowdLevel: CrowdLevel?
    var selectedFacilities: [Facilities]
    var cigaretteTypes: [CigaretteTypes]
}


extension UserFilterPrefence.Ambience {
    var systemImage: String {
        switch self {
        case .all:
            return "circle.grid.3x3"
        case .dark:
            return "moonphase.waxing.crescent"
        case .bright:
            return "moonphase.waning.gibbous"
        }
    }
}

extension UserFilterPrefence.CrowdLevel {
    var systemImage: String {
        switch self {
        case .all:
            return "circle.grid.3x3"
        case .quiet:
            return "zzz"
        case .crowded:
            return "person.2"
        }
    }
}

extension UserFilterPrefence.Facilities {
    var systemImage: String {
        switch self {
        case .chair:
            return "chair.fill"
        case .roof:
            return "beach.umbrella.fill"
        case .wasteBin:
            return "arrow.up.trash.fill"
        }
    }
}

extension UserFilterPrefence.CigaretteTypes {
    var systemImage: String {
        switch self {
        case .cigarette:
            return "flame.fill"
        case .eCigarette:
            return "e.circle.fill"
        }
    }
}

extension SortingOption{
    var displayName: String {
        switch self {
        case .nearest:
            return "Nearest"
        case .furthest:
            return "Furthest"
        }
    }
}

