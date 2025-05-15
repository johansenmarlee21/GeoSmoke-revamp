//
//  ModalityView.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 12/05/25.
//

import Foundation
import SwiftUI
import SwiftData

struct ModalityView: View {
    
    @ObservedObject private var viewModel = ModalityViewModel()
    @Environment(\.modelContext) private var modelContext
    
//    init(viewModel: ModalityViewModel = ModalityViewModel()) {
//            self.viewModel = viewModel
//    }
    
    var body: some View{
        
        NavigationView{
            VStack(alignment: .leading){
                Text("Nearest")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                HStack{
                    Text("All Results")
                    Spacer()
                    Rectangle()
                        .frame(width: 2, height: 38)
                        .foregroundColor(Color.gray)
                    Button(action:{
                        
                    }){
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
                
                ScrollView{
                    LazyVStack(spacing: 0){
                        ForEach(viewModel.filteredSmokingAreas) {area in
                            SmokingAreaCardView(area: area, distance: viewModel.distance(from: area))
                        }
                    }
                }

            }
            .padding(.horizontal, 0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear{
                print("testing")
                viewModel.loadSmokingAreas(from: modelContext)
                    viewModel.applyFilters()
                
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
