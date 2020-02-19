//
//  LocationManager.swift
//  TestyMcTestenstein
//
//  Created by Mario Schreiner on 17.01.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    public static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var shouldTrackLocation = false
    private var tracksLocation = false
    
    public func requestAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationAuthorizationUpdated()
        }
    }
    
    public func startTracking() {
        self.shouldTrackLocation = true
        self.requestAuthorization()
    }
    
    public func stopTracking() {
        self.shouldTrackLocation = false
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingHeading()
    }
    
    private func locationAuthorizationUpdated() {
        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }

        if self.shouldTrackLocation && self.tracksLocation == false && self.isAuthorized {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 0
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
            self.tracksLocation = true
        }
        
        self.objectWillChange.send()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationAuthorizationUpdated()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            guard location.horizontalAccuracy <= 65.0 else {
                continue
            }
            
            self.currentLocation = location
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.currentHeading = newHeading
    }
    
    var objectDidChange = ObservableObjectPublisher()
    
    @Published private(set) var currentLocation: CLLocation? {
        didSet {
            objectDidChange.send()
        }
    }
    @Published private(set) var currentHeading: CLHeading? {
        didSet {
            objectDidChange.send()
        }
    }
    
    var isAuthorized: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
}
