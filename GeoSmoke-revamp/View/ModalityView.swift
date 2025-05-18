//
//  ModalityView.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 12/05/25.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct ModalityView: View {
    
    @ObservedObject var viewModel: ModalityViewModel
    @Binding var selectedDetent: PresentationDetent
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedArea: SmokingArea?
    @ObservedObject var filterViewModel: FilterViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @State private var showingFilterView = false
    
    
    var body: some View{
        
        NavigationView{
            VStack(alignment: .leading){
                Text(viewModel.sortingOption.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                if selectedDetent == .fraction(0.65){
                    if showingFilterView {
                        let newFilterVM = FilterViewModel(
                            selectedAmbience: UserFilterPrefence.Ambience(rawValue: viewModel.selectedAmbience ?? "") ?? .all,
                            selectedCrowdLevel: UserFilterPrefence.CrowdLevel(rawValue: viewModel.selectedCrowdLevel ?? "") ?? .all,
                            selectedFacilities: Set(viewModel.selectedFacilities.compactMap { UserFilterPrefence.Facilities(rawValue: $0) }),
                            selectedCigaretteTypes: Set(viewModel.selectedCigaretteTypes.compactMap { UserFilterPrefence.CigaretteTypes(rawValue: $0) })
                        )
                        FilterView(
                            viewModel: filterViewModel,
                            modalityViewModel: viewModel,
                            mapViewModel: mapViewModel
                        ) {
                            showingFilterView = false
                        }
                    }else{
                        HStack {
                            if viewModel.hasActiveFilters {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        
                                        // Ambience chip
                                        if let ambienceRaw = viewModel.selectedAmbience,
                                           let ambience = UserFilterPrefence.Ambience(rawValue: ambienceRaw),
                                           ambience != .all {
                                            ReusableFilterChipView(image: ambience.systemImage, label: ambienceRaw) {
                                                viewModel.selectedAmbience = UserFilterPrefence.Ambience.all.rawValue
                                                viewModel.applyStoredFilters()
                                            }
                                        }
                                        
                                        // Crowd level chip
                                        if let crowdRaw = viewModel.selectedCrowdLevel,
                                           let crowd = UserFilterPrefence.CrowdLevel(rawValue: crowdRaw),
                                           crowd != .all {
                                            ReusableFilterChipView(image: crowd.systemImage, label: crowdRaw) {
                                                viewModel.selectedCrowdLevel = UserFilterPrefence.CrowdLevel.all.rawValue
                                                viewModel.applyStoredFilters()
                                            }
                                        }
                                        
                                        // Facility chips
                                        ForEach(viewModel.selectedFacilities, id: \.self) { facilityRaw in
                                            if let facility = UserFilterPrefence.Facilities(rawValue: facilityRaw) {
                                                ReusableFilterChipView(image: facility.systemImage, label: facilityRaw) {
                                                    viewModel.selectedFacilities.removeAll { $0 == facilityRaw }
                                                    viewModel.applyStoredFilters()
                                                }
                                            }
                                        }
                                        
                                        // Cigarette type chips
                                        ForEach(viewModel.selectedCigaretteTypes, id: \.self) { typeRaw in
                                            if let type = UserFilterPrefence.CigaretteTypes(rawValue: typeRaw) {
                                                ReusableFilterChipView(image: type.systemImage, label: typeRaw) {
                                                    viewModel.selectedCigaretteTypes.removeAll { $0 == typeRaw }
                                                    viewModel.applyStoredFilters()
                                                }
                                            }
                                        }
                                    }
                                    .padding(.vertical, 3)
                                    .padding(.leading, 3)
                                }
                            } else {
                                Text("All Results")
                                    .font(.subheadline)
                            }

                            Spacer()

                            Rectangle()
                                .frame(width: 2, height: 38)
                                .foregroundColor(Color.gray)

                            Button(action: {
                                viewModel.syncFiltersToFilterViewModel()
                                showingFilterView = true
                            }) {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .foregroundColor(.darkGreen)
                            }
                        }
                        .padding(.horizontal)
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(Color.gray)
                            .opacity(0.09)
                        
                        
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(viewModel.filteredSmokingAreas) { area in
                                        SmokingAreaCardView(
                                            area: area,
                                            distance: viewModel.distance(from: area),
                                            isSelected: area.id == selectedArea?.id
                                        )
                                        .onTapGesture {
                                            selectedArea = area
                                        }
                                    }
                                }
                            }
                        }

                    }
                    
                }
            }
            .padding(.horizontal, 0)
            .padding(.top, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear {
                Task {
                    await viewModel.loadSmokingAreas(from: modelContext)
                    await MainActor.run {
                        viewModel.applyStoredFilters()
                    }
                }
            }

        }
        
    }
}

//#Preview {
//    let mockVM = ModalityViewModel()
//    mockVM.filteredSmokingAreas = [
//        SmokingArea(
//            name: "The SmokeStage",
//            location: "Garden",
//            longitude: 106.6529061,
//            latitude: -6.3011829,
//            photo: "SmokeStage1",
//            allPhoto: ["SmokeStage1", "SmokeStage2"],
//            disposalPhoto: "SmokeStage2",
//            disposalDirection: "The disposal unit should be located directly at the location.",
//            isFavorite: false,
//            ambience: UserFilterPrefence.Ambience.bright.rawValue,
//            crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
//            facilities: [UserFilterPrefence.Facilities.wasteBin.rawValue],
//            cigaretteTypes: [UserFilterPrefence.CigaretteTypes.cigarette.rawValue]
//        ),
//        SmokingArea(
//            name: "SixJog",
//            location: "GOP 6",
//            longitude: 106.6525899,
//            latitude: -6.3028502,
//            photo: "SixJog1",
//            allPhoto: ["SixJog1", "SixJog2"],
//            disposalPhoto: "SixJogWaste",
//            disposalDirection: "The disposal unit should be located directly at the location.",
//            isFavorite: false,
//            ambience: UserFilterPrefence.Ambience.bright.rawValue,
//            crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
//            facilities: [
//                UserFilterPrefence.Facilities.wasteBin.rawValue,
//                UserFilterPrefence.Facilities.chair.rawValue
//            ],
//            cigaretteTypes: [
//                UserFilterPrefence.CigaretteTypes.eCigarette.rawValue,
//                UserFilterPrefence.CigaretteTypes.cigarette.rawValue
//            ]
//        ),
//        SmokingArea(
//            name: "Ecopuff Corner",
//            location: "GOP 6",
//            longitude: 106.654619,
//            latitude: -6.303563,
//            photo: "EcopuffCorner1",
//            allPhoto: ["EcopuffCorner1", "EcopuffCorner2"],
//            disposalPhoto: "EcopuffCorner2",
//            disposalDirection: "Find the stairs located near you, find for the nearest disposal unit that located near the lobby.",
//            isFavorite: false,
//            ambience: UserFilterPrefence.Ambience.bright.rawValue,
//            crowdLevel: UserFilterPrefence.CrowdLevel.crowded.rawValue,
//            facilities: [
//                UserFilterPrefence.Facilities.wasteBin.rawValue,
//                UserFilterPrefence.Facilities.roof.rawValue
//            ],
//            cigaretteTypes: [
//                UserFilterPrefence.CigaretteTypes.eCigarette.rawValue
//            ]
//        ),
//        SmokingArea(
//            name: "SixJog",
//            location: "GOP 6",
//            longitude: 106.6525899,
//            latitude: -6.3028502,
//            photo: "SixJog1",
//            allPhoto: ["SixJog1", "SixJog2"],
//            disposalPhoto: "SixJogWaste",
//            disposalDirection: "The disposal unit should be located directly at the location.",
//            isFavorite: false,
//            ambience: UserFilterPrefence.Ambience.bright.rawValue,
//            crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
//            facilities: [
//                UserFilterPrefence.Facilities.wasteBin.rawValue,
//                UserFilterPrefence.Facilities.chair.rawValue
//            ],
//            cigaretteTypes: [
//                UserFilterPrefence.CigaretteTypes.eCigarette.rawValue,
//                UserFilterPrefence.CigaretteTypes.cigarette.rawValue
//            ]
//        ),
//        SmokingArea(
//            name: "SixJog",
//            location: "GOP 6",
//            longitude: 106.6525899,
//            latitude: -6.3028502,
//            photo: "SixJog1",
//            allPhoto: ["SixJog1", "SixJog2"],
//            disposalPhoto: "SixJogWaste",
//            disposalDirection: "The disposal unit should be located directly at the location.",
//            isFavorite: false,
//            ambience: UserFilterPrefence.Ambience.bright.rawValue,
//            crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
//            facilities: [
//                UserFilterPrefence.Facilities.wasteBin.rawValue,
//                UserFilterPrefence.Facilities.chair.rawValue
//            ],
//            cigaretteTypes: [
//                UserFilterPrefence.CigaretteTypes.eCigarette.rawValue,
//                UserFilterPrefence.CigaretteTypes.cigarette.rawValue
//            ]
//        ),
//        SmokingArea(
//            name: "SixJog",
//            location: "GOP 6",
//            longitude: 106.6525899,
//            latitude: -6.3028502,
//            photo: "SixJog1",
//            allPhoto: ["SixJog1", "SixJog2"],
//            disposalPhoto: "SixJogWaste",
//            disposalDirection: "The disposal unit should be located directly at the location.",
//            isFavorite: false,
//            ambience: UserFilterPrefence.Ambience.bright.rawValue,
//            crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
//            facilities: [
//                UserFilterPrefence.Facilities.wasteBin.rawValue,
//                UserFilterPrefence.Facilities.chair.rawValue
//            ],
//            cigaretteTypes: [
//                UserFilterPrefence.CigaretteTypes.eCigarette.rawValue,
//                UserFilterPrefence.CigaretteTypes.cigarette.rawValue
//            ]
//        )
//    ]
//    return ModalityView(viewModel: mockVM)
//}
