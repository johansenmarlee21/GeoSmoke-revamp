import Foundation
import MapKit
import Combine
import CoreLocation
import SwiftData
import _MapKit_SwiftUI

class MapViewModel: ObservableObject {
    @Published var locations: [SmokingArea] = []
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var selectedLocation: SmokingArea?
    @Published var userLocation: CLLocationCoordinate2D?

    private var locationManager = LocationManager.shared
    private var cancellables = Set<AnyCancellable>()

    private var defaultCoordinate = CLLocationCoordinate2D(latitude: -6.301405, longitude: 106.651846)

    init() {
        setupBindings()
        locationManager.requestLocationAccess()
        setCameraPosition()
    }

    func setCameraPosition() {
        self.cameraPosition = .region(
            MKCoordinateRegion(
                center: defaultCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }

    private func setupBindings() {
        locationManager.$userLocation
            .compactMap { $0 }
            .sink { [weak self] coordinate in
                guard let self = self else { return }
                self.userLocation = coordinate
            }
            .store(in: &cancellables)
    }

//    @MainActor
//    private func handleLocationUpdate(coordinate: CLLocationCoordinate2D) {
//        self.userLocation = coordinate
//
//        if !self.hasCenteredOnUser {
//            self.cameraPosition = .region(
//                MKCoordinateRegion(
//                    center: coordinate,
//                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//                )
//            )
//            self.hasCenteredOnUser = true
//        }
//    }

    @MainActor
    func loadInitialData(context: ModelContext) async {
        await SmokingAreaSeeder.seedIfNeeded(context: context)
        try? await Task.sleep(nanoseconds: 300_000_000)
        fetchLocations(context: context) 
    }

    @MainActor
    private func fetchLocations(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<SmokingArea>()
            locations = try context.fetch(descriptor)
            print("✅ Fetched \(locations.count) locations")
        } catch {
            print("❌ Failed to fetch smoking areas: \(error.localizedDescription)")
        }
    }
}

