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
    @Published var dashPhase: CGFloat = 0
    private var timer: Timer?

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
    
    func midPointCoordinate (from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let lat = (from.latitude + to.latitude) / 2
        let lon = (from.longitude + to.longitude) / 2
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func updateCameraPosition(for selectedArea: SmokingArea?) {
        guard let area = selectedArea, let userLocation = userLocation else { return }

        let annotationCoordinate = CLLocationCoordinate2D(latitude: area.latitude, longitude: area.longitude)

        let minLat = min(userLocation.latitude, annotationCoordinate.latitude)
        let maxLat = max(userLocation.latitude, annotationCoordinate.latitude)
        let minLon = min(userLocation.longitude, annotationCoordinate.longitude)
        let maxLon = max(userLocation.longitude, annotationCoordinate.longitude)

        let latPadding = (maxLat - minLat) * 0.6
        let lonPadding = (maxLon - minLon) * 0.6

        var centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2

        let offsetAmount = ((maxLat - minLat) + latPadding) * -0.85
        centerLat += offsetAmount

        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) + latPadding,
                longitudeDelta: (maxLon - minLon) + lonPadding
            )
        )

        print("📍 Adjusted region center: \(region.center.latitude), \(region.center.longitude)")
        self.cameraPosition = .region(region)
        self.selectedLocation = area
    }

    func startDashPhaseAnimation(interval: TimeInterval = 0.2, decrement: CGFloat = 5) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.dashPhase -= decrement
        }
    }

    func stopDashPhaseAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

