//
//  Extensions.swift
//  SeeIT WatchKit Extension
//
//  Created by Mario Schreiner on 04.02.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import Foundation
import CoreLocation

extension ContentView {
    
    func distanceSorter(from userLocation: CLLocation) -> ((Bathroom, Bathroom) -> Bool) {
        return { (lhs: Bathroom, rhs: Bathroom) -> Bool in
            let lhsLocation = CLLocation(latitude: lhs.latitude, longitude: lhs.longitude)
            let rhsLocation = CLLocation(latitude: rhs.latitude, longitude: rhs.longitude)
            
            let lhsDistance = userLocation.distance(from: lhsLocation)
            let rhsDistance = userLocation.distance(from: rhsLocation)
            
            return lhsDistance < rhsDistance
        }
    }
    
}
