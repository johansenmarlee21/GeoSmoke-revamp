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
    
    var body: some View{
        
        NavigationStack{
            ZStack{
                MapView()
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading){
                            Image("Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                        }
                    }
                    .sheet(isPresented: $showModality){
                        ModalityView()
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
