import SwiftUI
import CoreLocation

struct FilterView: View {
    
    @ObservedObject var viewModel: FilterViewModel
    @ObservedObject var modalityViewModel: ModalityViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @Environment(\.dismiss) var dismiss
    
    var onClose: () -> Void
    
//    init(modalityViewModel: ModalityViewModel,
//         mapViewModel: MapViewModel,
//         initialFilterViewModel: FilterViewModel,
//         onClose: @escaping () -> Void) {
//        self.viewModel = initialFilterViewModel
//        self.modalityViewModel = modalityViewModel
//        self.mapViewModel = mapViewModel
//        self.onClose = onClose
//    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            header
            sortSection
            preferenceHeader
            HStack{
                ambienceSection
                Spacer()
                crowdLevelSection
            }
            facilitiesSelectionSection
            CigaretteSelectionSection
            ResultButton
            
        }
        .padding(.horizontal)
    }
    
    private var header: some View {
        HStack {
            ZStack {
                Text("Filters")
                    .font(.title2)
                    .fontWeight(.bold)
                HStack {
                    Spacer()
                    Button("Close") {
                        onClose()
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.orangetheme)
                }
            }
        }
    }
    
    private var sortSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Sort Based On")
                .font(.body)
                .fontWeight(.semibold)
            
            Menu {
                ForEach(UserFilterPrefence.SortMethod.allCases, id: \.self) { method in
                    Button(action: {
                        viewModel.sortMethod = method
                    }) {
                        Label(method.rawValue.capitalized,
                              systemImage: viewModel.sortMethod == method ? "checkmark" : "")
                    }
                }
            } label: {
                menuLabel(title: viewModel.sortMethod.rawValue.capitalized,
                          icon: "chevron.down",
                          background: .greyFilter,
                          iconColor: .darkGreen)
            }
        }
    }
    
    private var preferenceHeader: some View {
        HStack {
            Text("Your Preferences")
                .font(.body)
                .fontWeight(.semibold)
            Spacer()
            Button("Reset All") {
                viewModel.resetFilters()
            }
            .font(.footnote)
            .foregroundColor(.orangetheme)
        }
    }
    
    private var ambienceSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Ambience")
                .font(.footnote)
            Menu {
                ForEach(UserFilterPrefence.Ambience.allCases, id: \.self) { option in
                    Button(action: {
                        viewModel.selectedAmbience = option
                    }) {
                        Label(option.rawValue.capitalized,
                              systemImage: viewModel.selectedAmbience == option ? "checkmark" : "circle")
                    }
                }
            } label: {
                menuLabel(title: viewModel.selectedAmbience.rawValue.capitalized,
                          icon: "chevron.down",
                          imagePrefix: viewModel.selectedAmbience.systemImage,
                          background: viewModel.selectedAmbience == .all ? Color.greyFilter : Color.greenFilter)
                    .frame(maxWidth: 174)
            }
        }
    }
    
    private var crowdLevelSection: some View{
        VStack(alignment: .leading, spacing: 6) {
            Text("Crowd Level")
                .font(.footnote)
            Menu {
                ForEach(UserFilterPrefence.CrowdLevel.allCases, id: \.self) { option in
                    Button(action: {
                        viewModel.selectedCrowdLevel = option
                    }) {
                        Label(option.rawValue.capitalized,
                              systemImage: viewModel.selectedCrowdLevel == option ? "checkmark.square" : "square")
                    }
                }
            } label: {
                menuLabel(title: viewModel.selectedCrowdLevel.rawValue.capitalized,
                          icon: "chevron.down",
                          imagePrefix: viewModel.selectedCrowdLevel.systemImage,
                          background: viewModel.selectedCrowdLevel == .all ? Color.greyFilter : Color.greenFilter)
                    .frame(maxWidth: 174)
            }
        }
    }
    
    private var facilitiesSelectionSection: some View {
        VStack(alignment: .leading, spacing: 5) {
                Text("Facilities")
                    .font(.footnote)
                
                let columns = [GridItem(.adaptive(minimum: 100), spacing: 7)]
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 5) {
                    ForEach(UserFilterPrefence.Facilities.allCases, id: \.self) { facility in
                        Button(action: {
                            if viewModel.selectedFacilities.contains(facility) {
                                viewModel.selectedFacilities.remove(facility)
                            } else {
                                viewModel.selectedFacilities.insert(facility)
                            }
                        }) {
                            HStack{
                                Image(systemName: facility.systemImage)
                                Text(facility.rawValue.capitalized)
                                    .font(.footnote)
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 41)
                            .background(viewModel.selectedFacilities.contains(facility) ? Color.greenFilter : Color.white)
                            .foregroundColor(.primary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.selectedFacilities.contains(facility) ? Color.black : Color.gray.opacity(0.4), lineWidth: 2)
                            )
                            .cornerRadius(10)
                        }
                    }
                }
            }
    }
    
    
    private var CigaretteSelectionSection: some View {
        VStack(alignment: .leading, spacing: 5) {
                Text("What do you smoke?")
                    .font(.footnote)
                
                let columns = [GridItem(.adaptive(minimum: 100), spacing: 7)]
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 5) {
                    ForEach(UserFilterPrefence.CigaretteTypes.allCases, id: \.self) { type in
                        Button(action: {
                            if viewModel.selectedCigaretteTypes.contains(type) {
                                viewModel.selectedCigaretteTypes.remove(type)
                            } else {
                                viewModel.selectedCigaretteTypes.insert(type)
                            }
                        }) {
                            HStack{
                                Image(systemName: type.systemImage)
                                Text(type.rawValue.capitalized)
                                    .font(.footnote)
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 41)
                            .background(viewModel.selectedCigaretteTypes.contains(type) ? Color.greenFilter : Color.white)
                            .foregroundColor(.primary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.selectedCigaretteTypes.contains(type) ? Color.black : Color.gray.opacity(0.4), lineWidth: 2)
                            )
                            .cornerRadius(10)
                        }
                    }
                }
            }
    }
    private var ResultButton: some View {
        Button(action: {
            modalityViewModel.applyFilters(using: viewModel)
            onClose()
            modalityViewModel.saveFilters()
        }) {
            Text("Show \(viewModel.applyFilters(to: modalityViewModel.allSmokingAreas, userLocation: LocationManager.shared.userLocation.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }).count) Results")
                .font(.footnote)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 41)
                .background(Color.splashGreen)
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.top, 10)
        }

    }
    private func menuLabel(title: String,
                           icon: String,
                           imagePrefix: String? = nil,
                           background: Color,
                           iconColor: Color = .black) -> some View {
        HStack {
            if let systemImage = imagePrefix {
                Image(systemName: systemImage)
                    .foregroundColor(.black)
            }
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: icon)
                .foregroundColor(iconColor)
        }
        .padding(10)
        .frame(height: 41)
        .background(background)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.4), lineWidth: 0)
        )
    }
}






