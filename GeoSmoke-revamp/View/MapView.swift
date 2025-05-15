import SwiftUI
import SwiftData
import MapKit
import _MapKit_SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @Environment(\.modelContext) private var modelContext
    
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
        }
        .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
        .onAppear {
            viewModel.setCameraPosition()
            Task {
                await viewModel.loadInitialData(context: modelContext)
            }
        }
    }
}

#Preview {
    MapView()
        .modelContainer(for: SmokingArea.self)
}
