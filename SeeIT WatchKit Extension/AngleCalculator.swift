//
//  AngleCalculator.swift
//  TestyMcTestenstein WatchKit Extension
//
//  Created by Mario Schreiner on 31.01.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import Foundation
import CoreLocation

class AngleCalculator: ObservableObject {
    
    private(set) var currentAngle: CLLocationDegrees = 0
    
    private var referenceLocation: CLLocation?
    
    private var lastAngle: CLLocationDegrees?
    
    func setReferenceLocation(_ location: CLLocation) {
        self.referenceLocation = location
        self.objectWillChange.send()
    }
    
    func update(newLocation: CLLocation?, newHeading: CLHeading?) {
        guard let referenceLocation = self.referenceLocation else {
            self.currentAngle = 0
            return
        }
        
        guard let location = newLocation else {
            self.currentAngle = 0
            return
        }
        
        guard let heading = newHeading else {
            self.currentAngle = 0
            return
        }
        
        let locationDegreeDelta = getBearingBetweenTwoPoints1(point1: location, point2: referenceLocation)
        var degrees = heading.magneticHeading.distance(to: locationDegreeDelta)
        if let lastAngle = self.lastAngle {
            while abs(degrees-lastAngle) >= 180 {
                if degrees > lastAngle {
                    degrees -= 360
                } else {
                    degrees += 360
                }
            }
        }

        self.currentAngle = degrees
        self.lastAngle = degrees
        self.objectWillChange.send()
        return
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
}
