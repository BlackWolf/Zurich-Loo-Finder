//
//  ContentView.swift
//  SeeIT WatchKit Extension
//
//  Created by Mario Schreiner on 04.02.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    
    let bathrooms: [Bathroom]
    
    var sortedBathrooms: [Bathroom] {
        guard let location = self.locationManager.currentLocation else {
            return self.bathrooms
        }
        
        return self.bathrooms.sorted(by: distanceSorter(from: location))
    }
    
    var body: some View {
        List(self.sortedBathrooms) { bathroom in
            NavigationLink(destination: BathroomDetailView(bathroom: bathroom)) {
                VStack(alignment: .leading) {
                    Text(bathroom.address)
                        .font(.caption)
                    
                    Text(self.distanceString(for: bathroom))
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                }
                .padding(.vertical)
                .animation(nil)
            }
        }
        .animation(.default)
    }
    
    func distanceString(for bathroom: Bathroom) -> String {
        guard let location = self.locationManager.currentLocation else {
            return "--"
        }
        
        return String(format:"%.0fm", bathroom.distance(to: location))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bathrooms: BathroomParser.parse())
    }
}
