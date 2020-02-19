//
//  BathroomDetailView.swift
//  TestyMcTestenstein WatchKit Extension
//
//  Created by Mario Schreiner on 17.01.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import SwiftUI

struct BathroomDetailView: View {
    
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    
    let bathroom: Bathroom
    
    @State var showNavigation: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Button(action: {
                    self.showNavigation = true
                }) {
                    Text("I gotta pee!")
                }.sheet(isPresented: self.$showNavigation) {
                    BathroomNavigationView(bathroom: self.bathroom)
                        .navigationBarTitle("End Navigation")
                }
                HStack {
                    Spacer()
                    Text(distanceString())
                        .foregroundColor(Color.blue)
                    Spacer()
                }
                .padding(.top, -4.0)
                .padding(.bottom)
                
                Text("Address")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                Text(bathroom.address)
                Spacer()
                    .frame(height: 8.0)
                Text("Price")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                Text(bathroom.costDescription)
            }
        }
    }
    
    func distanceString() -> String {
        guard let location = self.locationManager.currentLocation else {
            return "--"
        }
        
        return "Distance \(String(format:"%.0fm", bathroom.distance(to: location)))"
    }
    
}

struct WCDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BathroomDetailView(bathroom: BathroomParser.parse()[0])
        }
    }
}
