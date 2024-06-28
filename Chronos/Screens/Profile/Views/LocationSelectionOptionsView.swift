//
//  LocationSelectionOptionsView.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import SwiftUI
import MapKit

struct LocationSelectionOptionsView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var showMap = false
    @State private var selectedLocation: Location?
    
    @Binding var textFieldModels: [TextFieldModel]
    @Binding var region: MKCoordinateRegion
    @Binding var showLocationSelectionOptionsView: Bool
    
    var body: some View {
        VStack(
            spacing: 30
        ) {
            SecondaryButton(
                label: useYourCurrentLocationLabelView,
                borderColor: Color.red,
                action: {
                    if let location = locationManager.location {
                        textFieldModels[0].text = String(location.coordinate.latitude)
                        textFieldModels[1].text = String(location.coordinate.longitude)
                    }
                    showLocationSelectionOptionsView = false
                }
            )
            
            SecondaryButton(
                label: useMapLabelView,
                borderColor: Color.theme,
                action: {
                    showMap.toggle()
                }
            )
        }
        .padding(.horizontal, 30)
        .fullScreenCover(isPresented: $showMap) {
            MapView(
                selectedLocation: $selectedLocation,
                region: $region,
                textFieldModels: $textFieldModels,
                showLocationSelectionOptionsView: $showLocationSelectionOptionsView
            )
        }
    }
    
    var useYourCurrentLocationLabelView: some View {
        HStack {
            Image(systemName: "location.fill")
            Text(LocalizedStringKey("Use your current location"))
        }
    }
    
    var useMapLabelView: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
            Text(LocalizedStringKey("Use the map"))
        }
    }
}

#Preview {
    LocationSelectionOptionsView(
        textFieldModels: .constant([]),
        region: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )),
        showLocationSelectionOptionsView: .constant(false)
    )
    .environmentObject(LocationManager())
}
