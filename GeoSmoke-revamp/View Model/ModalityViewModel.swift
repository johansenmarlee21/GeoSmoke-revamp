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
    @Published var isLoading = true
    
    @Published var selectedAmbience: String? {
        didSet {if !isLoadingFilters {
            saveFilters()
        }}
    }
    @Published var selectedCrowdLevel: String? {
        didSet {if !isLoadingFilters {
            saveFilters()
        }}
    }
    @Published var selectedFacilities: [String] = [] {
        didSet {if !isLoadingFilters {
            saveFilters()
        }}
    }
    @Published var selectedCigaretteTypes: [String] = [] {
        didSet {if !isLoadingFilters {
            saveFilters()
        }}
    }
    @Published var sortingOption: SortingOption = .nearest {
        didSet {if !isLoadingFilters {
            saveFilters()
        }}
    }
    
    
    
    private var locationManager  = LocationManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var filterViewModel: FilterViewModel
    private var isLoadingFilters = false
    
    
    
    init(filterViewModel: FilterViewModel) {
        
        self.filterViewModel = filterViewModel
        bindFilterViewModel()
        loadFilters()
        LocationManager.shared.$userLocation
            .removeDuplicates(by: { old, new in
                guard let old = old, let new = new else { return false }
                return old.latitude == new.latitude && old.longitude == new.longitude
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLocation in
                guard newLocation != nil else { return }
                
                Task { @MainActor in
                    self?.applyStoredFilters() // <-- Or applyFilters(using:), based on consistency
                }
            }
            .store(in: &cancellables)

    }
    
    
    
    @MainActor
    func loadSmokingAreas(from context: ModelContext) async {
        do {
            isLoading = true
            let descriptor = FetchDescriptor<SmokingArea>()
            let areas = try context.fetch(descriptor)
            self.allSmokingAreas = areas
            await applyStoredFilters()
            isLoading = false
        } catch {
            print("Error loading smoking areas: \(error)")
            isLoading = false
        }
    }

    
    @MainActor
    func applyFilters(using filterViewModel: FilterViewModel) {
        guard !allSmokingAreas.isEmpty else { return }
        
        let filtered = filterViewModel.applyFilters(to: allSmokingAreas, userLocation: LocationManager.shared.userLocation.flatMap {
            CLLocation(latitude: $0.latitude, longitude: $0.longitude)
        })
        self.filteredSmokingAreas = filtered
    }
    
    @MainActor
    func applyStoredFilters() {
        print(">>> applyStoredFilters called")
        print("Initial allSmokingAreas count: \(allSmokingAreas.count)")
        print("Selected ambience: \(selectedAmbience ?? "nil")")
        print("Selected crowdLevel: \(selectedCrowdLevel ?? "nil")")
        print("Selected facilities: \(selectedFacilities)")
        print("Selected cigaretteTypes: \(selectedCigaretteTypes)")
        print("Sorting option: \(sortingOption)")

        guard !allSmokingAreas.isEmpty else {
            print("No smoking areas available, exiting")
            return
        }

        var result = allSmokingAreas

        if let ambience = selectedAmbience, ambience != "all" {
            result = result.filter { $0.ambience == ambience }
            print("After ambience filter count: \(result.count)")
        }

        if let crowdLevel = selectedCrowdLevel, crowdLevel != "all" {
            result = result.filter { $0.crowdLevel == crowdLevel }
            print("After crowdLevel filter count: \(result.count)")
        }

        if !selectedFacilities.isEmpty {
            result = result.filter { area in
                Set(selectedFacilities).isSubset(of: area.facilities)
            }
            print("After facilities filter count: \(result.count)")
        }

        if !selectedCigaretteTypes.isEmpty {
            result = result.filter { area in
                Set(selectedCigaretteTypes).isSubset(of: area.cigaretteTypes)
            }
            print("After cigaretteTypes filter count: \(result.count)")
        }

        if let userLocation = locationManager.userLocation {
            let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)

            result.sort {
                let d1 = CLLocation(latitude: $0.latitude, longitude: $0.longitude).distance(from: userCLLocation)
                let d2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude).distance(from: userCLLocation)
                return sortingOption == .nearest ? d1 < d2 : d1 > d2
            }
            print("Sorted by user location with sorting option: \(sortingOption)")
        } else {
            print("User location not available, no sorting applied")
        }

        print("Final filteredSmokingAreas count: \(result.count)")

        self.filteredSmokingAreas = result
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
    
    var previewFilteredSmokingAreas: [SmokingArea] {
        var filtered = allSmokingAreas
        
        if let ambience = selectedAmbience {
            filtered = filtered.filter { $0.ambience == ambience }
        }
        
        if let crowd = selectedCrowdLevel {
            filtered = filtered.filter { $0.crowdLevel == crowd }
        }
        
        if !selectedFacilities.isEmpty {
            filtered = filtered.filter { area in
                !Set(selectedFacilities).isDisjoint(with: area.facilities)
            }
        }
        
        if !selectedCigaretteTypes.isEmpty {
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
        
        return filtered
    }
    
    func saveFilters() {
        print("Saving ambience: \(selectedAmbience ?? "nil")")
        print("Saving crowd: \(selectedCrowdLevel ?? "nil")")
        print("Saving facilities: \(selectedFacilities)")
        print("Saving cigarette types: \(selectedCigaretteTypes)")
        print("Saving sorting nearest: \(sortingOption == .nearest)")
        UserDefaults.standard.set(selectedAmbience, forKey: "selectedAmbience")
        UserDefaults.standard.set(selectedCrowdLevel, forKey: "selectedCrowdLevel")
        UserDefaults.standard.set(selectedFacilities, forKey: "selectedFacilities")
        UserDefaults.standard.set(selectedCigaretteTypes, forKey: "selectedCigaretteTypes")
        UserDefaults.standard.set(sortingOption == .nearest, forKey: "sortingOptionNearest")
    }

    func loadFilters() {
        isLoadingFilters = true
        selectedAmbience = UserDefaults.standard.string(forKey: "selectedAmbience")
        selectedCrowdLevel = UserDefaults.standard.string(forKey: "selectedCrowdLevel")
        selectedFacilities = UserDefaults.standard.stringArray(forKey: "selectedFacilities") ?? []
        selectedCigaretteTypes = UserDefaults.standard.stringArray(forKey: "selectedCigaretteTypes") ?? []
        let nearest = UserDefaults.standard.bool(forKey: "sortingOptionNearest")
        sortingOption = nearest ? .nearest : .furthest
        print("Loaded ambience: \(selectedAmbience ?? "nil")")
        print("Loaded crowd: \(selectedCrowdLevel ?? "nil")")
        print("Loaded facilities: \(selectedFacilities)")
        print("Loaded cigarette types: \(selectedCigaretteTypes)")
        print("Loaded sorting nearest: \(sortingOption == .nearest)")
    }
    
    
    private func bindFilterViewModel() {
        filterViewModel.$selectedAmbience
            .sink { [weak self] newValue in
                self?.selectedAmbience = newValue.rawValue
            }
            .store(in: &cancellables)

        filterViewModel.$selectedCrowdLevel
            .sink { [weak self] newValue in
                self?.selectedCrowdLevel = newValue.rawValue
            }
            .store(in: &cancellables)

        filterViewModel.$selectedFacilities
            .sink { [weak self] newValue in
                self?.selectedFacilities = newValue.map { $0.rawValue }
            }
            .store(in: &cancellables)

        filterViewModel.$selectedCigaretteTypes
            .sink { [weak self] newValue in
                self?.selectedCigaretteTypes = newValue.map { $0.rawValue }
            }
            .store(in: &cancellables)

        filterViewModel.$sortMethod
            .sink { [weak self] newValue in
                self?.sortingOption = (newValue == .nearest) ? .nearest : .furthest
            }
            .store(in: &cancellables)
    }
    
    var hasActiveFilters: Bool {
        let hasAmbience = selectedAmbience != nil && selectedAmbience != "all"
        let hasCrowd = selectedCrowdLevel != nil && selectedCrowdLevel != "all"
        let hasFacilities = !selectedFacilities.isEmpty
        let hasCigaretteTypes = !selectedCigaretteTypes.isEmpty
        return hasAmbience || hasCrowd || hasFacilities || hasCigaretteTypes
    }
    
    func syncFiltersToFilterViewModel(){
        let ambience = UserFilterPrefence.Ambience(rawValue: selectedAmbience ?? "") ?? .all
        let crowdLevel = UserFilterPrefence.CrowdLevel(rawValue: selectedCrowdLevel ?? "") ?? .all
        
        let facilities = Set(selectedFacilities.compactMap{
            UserFilterPrefence.Facilities(rawValue: $0)
        })
        let cigaretteTypes = Set(selectedCigaretteTypes.compactMap{
            UserFilterPrefence.CigaretteTypes(rawValue: $0)
        })
        
        filterViewModel.selectedAmbience = ambience
        filterViewModel.selectedCrowdLevel = crowdLevel
        filterViewModel.selectedFacilities = facilities
        filterViewModel.selectedCigaretteTypes = cigaretteTypes
        
    }



    
}

