import SwiftUI
import SwiftData
import MapKit
import _MapKit_SwiftUI

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedArea: SmokingArea?
    @State private var dashPhase: CGFloat = 0
    let latitudeOffset = -0.0013
    
    var body: some View {
        Map(position: $viewModel.cameraPosition, selection: $viewModel.selectedLocation) {
            UserAnnotation()
            
            ForEach(viewModel.locations) { location in
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                Annotation(location.name, coordinate: coordinate){
                    Image("MapAnnotation")
                        .resizable()
                        .frame(width: 28, height: 38)
                    
                }
                .tag(location)
            }
            if let userCoordinate = viewModel.userLocation,
                   let selected = selectedArea {
                    let selectedCoordinate = CLLocationCoordinate2D(latitude: selected.latitude, longitude: selected.longitude)
                    MapPolyline(coordinates: [userCoordinate, selectedCoordinate])
                    .stroke(Color.splashGreen.opacity(1),
                            style: StrokeStyle(
                                lineWidth: 1,
                                lineCap: .round,
                                dash: [6,4],
                                dashPhase: viewModel.dashPhase
                            )
                    )

                }
        }
        .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
        .onAppear {
            viewModel.setCameraPosition()
            Task {
                await viewModel.loadInitialData(context: modelContext)
            }
//            viewModel.startDashPhaseAnimation()
//            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
//                dashPhase -= 5
//            }
        }
        .onDisappear{
            viewModel.stopDashPhaseAnimation()
        }
        .onChange(of: selectedArea) { oldValue, newValue in
            viewModel.updateCameraPosition(for: newValue)
        }


        
    }
}

//#Preview {
//    MapView()
//        .modelContainer(for: SmokingArea.self)
//}
