//
//  ContentView.swift
//  TestyMcTestenstein
//
//  Created by Mario Schreiner on 17.01.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @State private var bathroomLocation: CLLocation?
    
    var body: some View {
        VStack {
            if self.bathroomLocation == nil {
                Text("Please select a public bathroom on your watch")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                MapView(bathroomLocation: self.$bathroomLocation)
                    .edgesIgnoringSafeArea(.all)
            }
        }.onReceive(TransferManager.shared.objectWillChange) { new in
            self.updateLocation()
        }
    }
    
    private func updateLocation() {
        guard let coordinate = TransferManager.shared.applicationContext["coordinate"] as? [String: Any] else {
            self.bathroomLocation = nil
            return
        }
        
        guard let latitude = coordinate["latitude"] as? Double, let longitude = coordinate["longitude"] as? Double else {
            self.bathroomLocation = nil
            return
        }
        
        self.bathroomLocation = CLLocation(latitude: latitude, longitude: longitude)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
