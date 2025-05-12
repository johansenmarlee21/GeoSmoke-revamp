import SwiftData
import Foundation

struct SmokingAreaSeeder {
    
    static func seedIfNeeded(context: ModelContext) async{
        let descriptor = FetchDescriptor<SmokingArea>()
        
        do{
            let existing = try context.fetchCount(descriptor)
            if existing == 0 {
                let areas = seed()
                for area in areas{
                    context.insert(area)
                }
                try context.save()
                print("sucessssssss")
            }else{
                print("already seeded")
            }
        }catch{
            print("error in seeding the smoking area")
        }
        
    }
    
    
    static func seed() -> [SmokingArea] {
        return [
            SmokingArea(
                name: "The Shady",
                location: "GOP 1",
                longitude: 106.6510372,
                latitude: -6.3009886,
                photo: "TheShady1",
                allPhoto: ["TheShady1", "TheShady2"],
                disposalPhoto: "TheShadyWaste",
                disposalDirection: "Find the closest zebra crossing, cross it, and then turn left. The garbage can should be on your right.",
                isFavorite: false,
                ambience: UserFilterPrefence.Ambience.dark.rawValue,
                crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
                facilities: [
                    UserFilterPrefence.Facilities.wasteBin.rawValue,
                    UserFilterPrefence.Facilities.roof.rawValue
                ],
                cigaretteTypes: [
                    UserFilterPrefence.CigaretteTypes.cigarette.rawValue,
                    UserFilterPrefence.CigaretteTypes.eCigarette.rawValue
                ]
            ),
            SmokingArea(
                name: "Garden Seating",
                location: "Garden",
                longitude: 106.6522975,
                latitude: -6.3013122,
                photo: "GardenSeating1",
                allPhoto: ["GardenSeating1", "GardenSeating2"],
                disposalPhoto: "GardenSeating2",
                disposalDirection: "The disposal unit should be located directly at the location.",
                isFavorite: false,
                ambience: UserFilterPrefence.Ambience.dark.rawValue,
                crowdLevel: UserFilterPrefence.CrowdLevel.crowded.rawValue,
                facilities: [
                    UserFilterPrefence.Facilities.chair.rawValue,
                    UserFilterPrefence.Facilities.wasteBin.rawValue,
                    UserFilterPrefence.Facilities.roof.rawValue
                ],
                cigaretteTypes: [
                    UserFilterPrefence.CigaretteTypes.cigarette.rawValue,
                    UserFilterPrefence.CigaretteTypes.eCigarette.rawValue
                ]
            ),
            SmokingArea(
                name: "Ecopuff Corner",
                location: "GOP 6",
                longitude: 106.654619,
                latitude: -6.303563,
                photo: "EcopuffCorner1",
                allPhoto: ["EcopuffCorner1", "EcopuffCorner2"],
                disposalPhoto: "EcopuffCorner2",
                disposalDirection: "Find the stairs located near you, find for the nearest disposal unit that located near the lobby.",
                isFavorite: false,
                ambience: UserFilterPrefence.Ambience.bright.rawValue,
                crowdLevel: UserFilterPrefence.CrowdLevel.crowded.rawValue,
                facilities: [
                    UserFilterPrefence.Facilities.wasteBin.rawValue,
                    UserFilterPrefence.Facilities.roof.rawValue
                ],
                cigaretteTypes: [
                    UserFilterPrefence.CigaretteTypes.eCigarette.rawValue
                ]
            ),
            SmokingArea(
                name: "The Jog",
                location: "GOP 1",
                longitude: 106.654589,
                latitude: -6.30362,
                photo: "TheJog1",
                allPhoto: ["TheJog1", "TheJog2"],
                disposalPhoto: "TheJog2",
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
            ),
            SmokingArea(
                name: "The Smokescape",
                location: "Garden",
                longitude: 106.650891,
                latitude: -6.302086,
                photo: "SmokeScape1",
                allPhoto: ["SmokeScape1", "SmokeScape2"],
                disposalPhoto: "SmokeScape2",
                disposalDirection: "Go to the garden area, find the disposal unit that located inside the garden.",
                isFavorite: false,
                ambience: UserFilterPrefence.Ambience.bright.rawValue,
                crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
                facilities: [
                    UserFilterPrefence.Facilities.roof.rawValue
                ],
                cigaretteTypes: [
                    UserFilterPrefence.CigaretteTypes.eCigarette.rawValue
                ]
            ),
            SmokingArea(
                name: "NineLoner",
                location: "GOP 9",
                longitude: 106.6527786,
                latitude: -6.3023203,
                photo: "NineLoner1",
                allPhoto: ["NineLoner1", "NineLoner2"],
                disposalPhoto: "NineLoner1",
                disposalDirection: "The disposal unit should be located directly at the location.",
                isFavorite: false,
                ambience: UserFilterPrefence.Ambience.bright.rawValue,
                crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
                facilities: [
                    UserFilterPrefence.Facilities.wasteBin.rawValue,
                    UserFilterPrefence.Facilities.chair.rawValue
                ],
                cigaretteTypes: [
                    UserFilterPrefence.CigaretteTypes.eCigarette.rawValue,
                    UserFilterPrefence.CigaretteTypes.cigarette.rawValue
                ]
            ),
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
            ),
            SmokingArea(
                name: "SixJog",
                location: "GOP 6",
                longitude: 106.6525899,
                latitude: -6.3028502,
                photo: "SixJog1",
                allPhoto: ["SixJog1", "SixJog2"],
                disposalPhoto: "SixJogWaste",
                disposalDirection: "The disposal unit should be located directly at the location.",
                isFavorite: false,
                ambience: UserFilterPrefence.Ambience.bright.rawValue,
                crowdLevel: UserFilterPrefence.CrowdLevel.quiet.rawValue,
                facilities: [
                    UserFilterPrefence.Facilities.wasteBin.rawValue,
                    UserFilterPrefence.Facilities.chair.rawValue
                ],
                cigaretteTypes: [
                    UserFilterPrefence.CigaretteTypes.eCigarette.rawValue,
                    UserFilterPrefence.CigaretteTypes.cigarette.rawValue
                ]
            )
        ]
    }
}
