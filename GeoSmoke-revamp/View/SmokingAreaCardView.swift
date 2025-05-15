//
//  SmokingAreaCardView.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 15/05/25.
//


import SwiftUI
import Foundation

struct SmokingAreaCardView: View {
    
    var area: SmokingArea
    var distance: String
    
    var body: some View {
        VStack{
            HStack{
                Image("TheShady1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 105, height: 67)
                    .cornerRadius(8)
                    .clipped()
                VStack(alignment: .leading, spacing: 0){
                    Text(area.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.splashGreen)
                        .padding(.top, 0)
                    Text(area.location)
                        .font(.caption)
                        .fontWeight(.regular)
                    Spacer()
                    
                    Text("\(distance) Meters")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orangetheme)
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 13)
                        .foregroundColor(Color.orangetheme)
                }
            }
            .padding(.horizontal)
            Rectangle()
                .frame(height: 3)
                .foregroundColor(Color.gray)
                .opacity(0.09)
                .padding(.bottom, 3)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 83)
        .padding(.top, 6)
//        .background(Color.red)
    }
}

#Preview{
    SmokingAreaCardView(area:
                            SmokingArea(
                                name: "The SmokeStage",
                                location: "Garden",
                                longitude: 106.6529061,
                                latitude: -6.3011829,
                                photo: "SmokeStage1",
                                allPhoto: ["SmokeStage1", "SmokeStage2"],
                                disposalPhoto: "SmokeStage2",
                                disposalDirection: "The disposal unit should be located directly at the location.",
                                isFavorite: false,
                                ambience: UserFilterPrefence.Ambience.bright.rawValue,
                                crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
                                facilities: [
                                    UserFilterPrefence.Facilities.wasteBin.rawValue
                                ],
                                cigaretteTypes: [
                                    UserFilterPrefence.CigaretteTypes.eCigarette.rawValue,
                                    UserFilterPrefence.CigaretteTypes.cigarette.rawValue
                                ]
                            )
                            , distance: "23")
}
