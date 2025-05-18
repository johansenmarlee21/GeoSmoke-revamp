//
//  FilterViewModel.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 15/05/25.
//

import Foundation
import SwiftData
import CoreLocation

class FilterViewModel: ObservableObject {
    @Published var sortMethod: UserFilterPrefence.SortMethod = .nearest
    @Published var selectedAmbience: UserFilterPrefence.Ambience = .all
    @Published var selectedCrowdLevel: UserFilterPrefence.CrowdLevel = .all
    @Published var selectedFacilities: Set<UserFilterPrefence.Facilities> = []
    @Published var selectedCigaretteTypes: Set<UserFilterPrefence.CigaretteTypes> = []
    
    @Published var matchedResultsCount: Int = 0
    
    init(
            sortMethod: UserFilterPrefence.SortMethod = .nearest,
            selectedAmbience: UserFilterPrefence.Ambience = .all,
            selectedCrowdLevel: UserFilterPrefence.CrowdLevel = .all,
            selectedFacilities: Set<UserFilterPrefence.Facilities> = [],
            selectedCigaretteTypes: Set<UserFilterPrefence.CigaretteTypes> = []
        ) {
            self.sortMethod = sortMethod
            self.selectedAmbience = selectedAmbience
            self.selectedCrowdLevel = selectedCrowdLevel
            self.selectedFacilities = selectedFacilities
            self.selectedCigaretteTypes = selectedCigaretteTypes
        }
    
    var userFilterPreference: UserFilterPrefence {
        UserFilterPrefence(
            sortMethod: sortMethod,
            ambience: selectedAmbience,
            crowdLevel: selectedCrowdLevel,
            selectedFacilities: Array(selectedFacilities),
            cigaretteTypes: Array(selectedCigaretteTypes)
        )
    }
    
    
    func applyFilters(
            to areas: [SmokingArea],
            userLocation: CLLocation?
        ) -> [SmokingArea] {
            var filtered = areas
            
            // Filter ambience (ignore if 'all')
            if selectedAmbience != .all {
                filtered = filtered.filter { $0.ambience == selectedAmbience.rawValue }
            }
            
            // Filter crowd level (ignore if 'all')
            if selectedCrowdLevel != .all {
                filtered = filtered.filter { $0.crowdLevel == selectedCrowdLevel.rawValue }
            }
            
            // Filter facilities
            if !selectedFacilities.isEmpty {
                let selectedFacilitiesRaw = selectedFacilities.map { $0.rawValue }
                filtered = filtered.filter { area in
                    !Set(selectedFacilitiesRaw).isDisjoint(with: area.facilities)
                }
            }
            
            // Filter cigarette types
            if !selectedCigaretteTypes.isEmpty {
                let selectedCigaretteRaw = selectedCigaretteTypes.map { $0.rawValue }
                filtered = filtered.filter { area in
                    !Set(selectedCigaretteRaw).isDisjoint(with: area.cigaretteTypes)
                }
            }
            
            // Sort by distance if location is available
            if let location = userLocation {
                filtered.sort { area1, area2 in
                    let loc1 = CLLocation(latitude: area1.latitude, longitude: area1.longitude)
                    let loc2 = CLLocation(latitude: area2.latitude, longitude: area2.longitude)
                    let dist1 = loc1.distance(from: location)
                    let dist2 = loc2.distance(from: location)
                    return sortMethod == .nearest ? dist1 < dist2 : dist1 > dist2
                }
            }
            
            DispatchQueue.main.async {
                self.matchedResultsCount = filtered.count
            }
            
            return filtered
        }
    
    
    func resetFilters(){
        selectedAmbience = UserFilterPrefence.Ambience.all
        selectedCrowdLevel = UserFilterPrefence.CrowdLevel.all
//        selectedFacilities = [UserFilterPrefence.Facilities.wasteBin, UserFilterPrefence.Facilities.chair, UserFilterPrefence.Facilities.roof]
//        selectedCigaretteTypes = [UserFilterPrefence.CigaretteTypes.eCigarette, UserFilterPrefence.CigaretteTypes.cigarette]
        
        selectedFacilities = []
        selectedCigaretteTypes = []
        
    }
}
