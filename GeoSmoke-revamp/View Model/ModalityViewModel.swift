//
//  ModalityViewModel.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 12/05/25.
//

import Foundation
import SwiftData
import CoreLocation
import Combine


enum SortingOption{
    case nearest
    case furthest
}

class ModalityViewModel: ObservableObject {
    @Published var allSmokingAreas: [SmokingArea] = []
    @Published var filteredSmokingAreas: [SmokingArea] = []
    
    @Published var selectedAmbience: String?
    @Published var selectedCrowdLevel: String?
    @Published var selectedFacilities: [String] = []
    @Published var selectedCigaretteTypes: [String] = []
    @Published var sortingOption: SortingOption = .nearest
    
    
    private var locationManager  = LocationManager.shared
    
    
    @MainActor
    func loadSmokingAreas(from context: ModelContext){
        do{

            let descriptor = FetchDescriptor<SmokingArea>()
            let areas = try context.fetch(descriptor)
            self.allSmokingAreas = areas
        }catch{
            print("error on loading the smoking areas")
        }
    }
    
    func applyFilters() {
        var filtered = allSmokingAreas
        
        if let ambience = selectedAmbience {
            filtered = filtered.filter { $0.ambience == ambience}
        }
        
        if let crowd = selectedCrowdLevel {
            filtered = filtered.filter { $0.crowdLevel == crowd}
        }
        
        if !selectedFacilities.isEmpty{
            filtered = filtered.filter { area in
                !Set(selectedFacilities).isDisjoint(with: area.facilities)
            }
        }
        
        if !selectedCigaretteTypes.isEmpty{
            filtered = filtered.filter { area in
                !Set(selectedCigaretteTypes).isDisjoint(with: area.cigaretteTypes)
            }
        }
        
        if let userLocation = locationManager.userLocation {
            let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            
            filtered.sort {
                let distance1 = CLLocation(latitude: $0.latitude, longitude: $0.longitude).distance(from: userCLLocation)
                let distance2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude).distance(from: userCLLocation)
                return sortingOption == .nearest ? distance1 < distance2 : distance1 > distance2
            }
        }
        print("✅ Filtered down to \(filtered.count) areas")
        self.filteredSmokingAreas = filtered
    }
    
    func distance(from area: SmokingArea) -> String{
        guard let userCoord = LocationManager.shared.userLocation else {
            return "-"
        }
        let userLocation = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
        let areaLocation = CLLocation(latitude: area.latitude, longitude: area.longitude)
        let distance = userLocation.distance(from: areaLocation)
        return String(format: "%.0f", distance)
    }
}

