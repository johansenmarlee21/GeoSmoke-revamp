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
    let isSelected: Bool
    
    var body: some View {
        VStack{
            HStack{
                Image(area.photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 105, height: 67)
                    .cornerRadius(8)
                    .clipped()
                    .padding(.leading, isSelected ? 22 : 0)
                    .animation(.easeInOut(duration: 0.25), value: isSelected)

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
                .animation(.easeInOut(duration: 0.25), value: isSelected)
                Spacer()
                Button(action: {}) {
                    ZStack {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 13)
                            .opacity(isSelected ? 0 : 1)
                        
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .opacity(isSelected ? 1 : 0)
                    }
                    .foregroundColor(.orangetheme)
                    .animation(.easeInOut(duration: 0.25), value: isSelected)
                }

            }
            .padding(.horizontal)
            .background(Color.white)
            Rectangle()
                .frame(height: 3)
                .foregroundColor(Color.gray)
                .opacity(0.09)
                .padding(.bottom, 3)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 83)
        .padding(.top, 6)
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
                        , distance: "23", isSelected: true)
}
