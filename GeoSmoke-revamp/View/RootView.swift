//
//  RootView.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 12/05/25.
//

import Foundation
import SwiftData
import SwiftUI

struct RootView: View{
    @State private var showModality = true
    @State private var selectedDetent: PresentationDetent = .fraction(0.06)
    @State private var selectedArea: SmokingArea? = nil
    
    
//    @StateObject private var viewModel = ModalityViewModel()
    
    @StateObject private var filterViewModel: FilterViewModel
        @StateObject private var viewModel: ModalityViewModel
        @StateObject private var mapViewModel = MapViewModel()

        init() {
            let filterVM = FilterViewModel()
            _filterViewModel = StateObject(wrappedValue: filterVM)
            _viewModel = StateObject(wrappedValue: ModalityViewModel(filterViewModel: filterVM))
        }

    
    var body: some View{
        
        NavigationStack{
            ZStack{
                MapView(viewModel: mapViewModel, selectedArea: $selectedArea)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading){
                            Image("Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                        }
                    }
                    .sheet(isPresented: $showModality){
                        ModalityView(viewModel: viewModel,selectedDetent: $selectedDetent, selectedArea: $selectedArea, filterViewModel: filterViewModel, mapViewModel: mapViewModel)
                            .presentationDetents(
                                [.fraction(0.06), .fraction(0.65)],
                                selection: $selectedDetent
                            )
                            .presentationDragIndicator(.visible)
                            .interactiveDismissDisabled(true)
                            .presentationBackgroundInteraction(.enabled)
                    }
            }
        }
        
    }
}

#Preview {
    RootView()
}
