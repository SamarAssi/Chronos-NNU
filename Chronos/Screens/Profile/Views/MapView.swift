//
//  MapView.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    @State private var currentAmount: CGFloat = 0
    @State private var copiedRegion: MKCoordinateRegion?
    
    @Binding var selectedLocation: Location?
    @Binding var region: MKCoordinateRegion
    @Binding var textFieldModels: [TextFieldModel]
    @Binding var showLocationSelectionOptionsView: Bool
    @State private var previousLocation: Location?
    
    private var isPreviousLocationSameAsSelected: Bool {
        guard let previousLocation = previousLocation, let selectedLocation = selectedLocation else {
            return false
        }
        return previousLocation.coordinate.latitude == selectedLocation.coordinate.latitude &&
        previousLocation.coordinate.longitude == selectedLocation.coordinate.longitude
    }
    
    
    var body: some View {
        NavigationStack {
            Map(
                coordinateRegion: $region,
                annotationItems: selectedLocation.map { [$0] } ?? []
            ) { location in
                MapMarker(coordinate: location.coordinate)
            }
            .onAppear {
                copiedRegion = region
                selectedLocation = Location(coordinate: region.center)
                previousLocation = selectedLocation
            }
            .gesture(
                MagnificationGesture()
                    .onChanged(handleDragingGesture)
            )
            .onTapGesture { tapLocation in
                withAnimation(.easeIn(duration: 0.1)) {
                    let coordinate = convertToCoordinate(tapLocation)
                    selectedLocation = Location(coordinate: coordinate)
                    region.center = coordinate
                }
            }
            .overlay(alignment: .bottom) {
                if let location = selectedLocation {
                    displayCoordinate(location: location)
                }
            }
            .overlay(alignment: .top) {
                searchTextFieldView
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButtonView
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if selectedLocation != nil {
                        doneButtonView
                    }
                }
            }
            .fontDesign(.rounded)
            .overlay(alignment: .bottomTrailing) {
                locationButtons
            }
        }
    }
}

extension MapView {
    
    var locationButtons: some View {
        VStack(spacing: 10) {
            Button(action: goToCurrentLocation) {
                Image(systemName: "location.fill")
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            
            Button(action: goToSelectedLocation) {
                Image(systemName: "mappin.circle.fill")
                    .padding()
                    .background(Color.white)
                    .foregroundStyle(isPreviousLocationSameAsSelected ? Color.theme.opacity(0.5) : Color.theme)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .disabled(isPreviousLocationSameAsSelected)
        }
        .padding()
        .padding(.bottom, 40)
    }
    
    var searchTextFieldView: some View {
        TextField("Search Maps", text: $searchText)
            .onSubmit {
                search()
            }
            .tint(Color.theme)
            .foregroundStyle(Color.black)
            .padding(.leading, 40)
            .frame(height: 45)
            .background(Color.white.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
            .padding(.top, 100)
            .overlay(alignment: .leading) {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .offset(x: 26, y: 52)
                
            }
    }
    
    var doneButtonView: some View {
        Button {
            if let selectedLocation = selectedLocation {
                textFieldModels[0].text = String(selectedLocation.coordinate.latitude)
                textFieldModels[1].text = String(selectedLocation.coordinate.longitude)
                showLocationSelectionOptionsView = false
                dismiss.callAsFunction()
            }
        } label: {
            Text(LocalizedStringKey("Done"))
                .fontWeight(.bold)
                .foregroundStyle(Color.blackAndWhite)
        }
    }
    
    var cancelButtonView: some View {
        Image(systemName: "xmark")
            .scaleEffect(0.8)
            .onTapGesture {
                if let copiedRegion = copiedRegion {
                    region = copiedRegion
                }
                showLocationSelectionOptionsView = false
                dismiss.callAsFunction()
            }
    }
}

extension MapView {
    
    private func displayCoordinate(
        location: Location
    ) -> some View {
        Text("Selected: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            .padding()
            .background(Color.white.opacity(0.8))
            .foregroundStyle(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
            .padding(.bottom)
    }
    
    private func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, let mapItem = response.mapItems.first else {
                print("No results found or an error occurred: \(String(describing: error))")
                return
            }
            
            let coordinate = mapItem.placemark.coordinate
            region.center = coordinate
            selectedLocation = Location(coordinate: coordinate)
        }
    }
    
    private func convertToCoordinate(
        _ location: CGPoint
    ) -> CLLocationCoordinate2D {
        let mapSize = UIScreen.main.bounds.size
        let normalizedPoint = CGPoint(
            x: location.x / mapSize.width,
            y: location.y / mapSize.height
        )
        
        let latitude = region.center.latitude + (0.5 - normalizedPoint.y) * region.span.latitudeDelta
        let longitude = region.center.longitude + (normalizedPoint.x - 0.5) * region.span.longitudeDelta
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    private func handleDragingGesture(value: CGFloat) {
        currentAmount = value - 1
    }
    
    private func goToCurrentLocation() {
        if let location = locationManager.location {
            withAnimation {
                region.center = previousLocation?.coordinate ?? location.coordinate
            }
        }
    }
    
    private func goToSelectedLocation() {
        if let location = selectedLocation {
            withAnimation {
                region.center = location.coordinate
            }
        }
    }
}

struct Location: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

#Preview {
    MapView(
        selectedLocation: .constant(nil),
        region: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )),
        textFieldModels: .constant([]),
        showLocationSelectionOptionsView: .constant(false)
    )
    .environmentObject(LocationManager())
}
