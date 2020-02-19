//
//  WCNavigationView.swift
//  TestyMcTestenstein
//
//  Created by Mario Schreiner on 28.01.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import SwiftUI
import CoreLocation

struct BathroomNavigationView: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    
    let bathroom: Bathroom
    
    @State private var angleCalculator: AngleCalculator = AngleCalculator()
    
    init(bathroom: Bathroom) {
        self.bathroom = bathroom
        
        let bathroomLocation = CLLocation(latitude: bathroom.latitude, longitude: bathroom.longitude)
        self.angleCalculator.setReferenceLocation(bathroomLocation)
    }
    
    var body: some View {
        self.angleCalculator.update(
            newLocation: self.locationManager.currentLocation,
            newHeading: self.locationManager.currentHeading
        )
        
        return VStack {
            Image(systemName: "arrow.up")
                .font(Font.system(size: 100))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(self.angleCalculator.currentAngle))
                .animation(.linear)
        }.onAppear {
            self.showNavigationOnPhone(true)
        }.onDisappear {
            self.showNavigationOnPhone(false)
        }
    }
    
    private func showNavigationOnPhone(_ showNavigation: Bool) {
        if showNavigation {
            TransferManager.shared.updateApplicationContext([
                "uuid": UUID().uuidString,
                "coordinate": [
                    "latitude": self.bathroom.latitude,
                    "longitude": self.bathroom.longitude
                ]
            ])
        } else {
            TransferManager.shared.updateApplicationContext([:])
        }
    }
    
}

struct WCNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomNavigationView(bathroom: BathroomParser.parse()[0])
    }
}
