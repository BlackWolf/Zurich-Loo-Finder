//
//  MapView.swift
//  TestyMcTestenstein
//
//  Created by Mario Schreiner on 30.01.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import SwiftUI
import MapKit

final class MapView: NSObject, UIViewRepresentable, MKMapViewDelegate {
    
    typealias UIViewType = MKMapView
    
    @Binding var bathroomLocation: CLLocation?
    
    init(bathroomLocation: Binding<CLLocation?>) {
        self._bathroomLocation = bathroomLocation
        super.init()
    }
    
    func makeUIView(context: MapView.Context) -> MapView.UIViewType {
        let map = MKMapView()
        map.showsUserLocation = true
        map.showsCompass = true
        map.userTrackingMode = .followWithHeading
        map.delegate = self
        return map
    }
    
    func updateUIView(_ uiView: MapView.UIViewType, context: MapView.Context) {
        self.updateMapRegion(mapView: uiView)
    }
    
    private func updateMapRegion(mapView: MKMapView) {
        if let location = self.bathroomLocation {
            let annotationExists = mapView.annotations.contains{ $0.coordinate.latitude == location.coordinate.latitude && $0.coordinate.longitude == location.coordinate.longitude }
            if annotationExists == false {
                //Add pin at the position of the WC
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = "Bathroom"
                mapView.removeAnnotations(mapView.annotations)
                mapView.addAnnotation(annotation)
            }
            
            //If the user position is known, zoom to a region so that both the pin and the user position are visible
            if let userLocation = mapView.userLocation.location {
                let distanceToUser = location.distance(from: userLocation)
                let newRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceToUser*2, longitudinalMeters: distanceToUser*2)
                
                //Check if pin and user are already in the current location, and the region change would be very small,
                //then omit the region change
                let currentRegion = mapView.region
                let isMajorRegionChange =
                    abs(newRegion.center.latitude-currentRegion.center.latitude) > 0.001 ||
                    abs(newRegion.center.longitude-currentRegion.center.longitude) > 0.001 ||
                    abs(newRegion.span.latitudeDelta-currentRegion.span.latitudeDelta) > 0.005 ||
                    abs(newRegion.span.longitudeDelta-currentRegion.span.longitudeDelta) > 0.005
                if  currentRegion.contains(location.coordinate) == false ||
                    currentRegion.contains(userLocation.coordinate) == false ||
                    isMajorRegionChange {
                    mapView.setRegion(newRegion, animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "wcannotation")
        view.displayPriority = .required
        view.animatesWhenAdded = true
        return view
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.updateMapRegion(mapView: mapView)
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(bathroomLocation: .constant(nil))
    }
}

extension MKCoordinateRegion {
    
    func contains(_ location: CLLocationCoordinate2D) -> Bool {
        var northWestCorner = CLLocationCoordinate2D()
        var southEastCorner = CLLocationCoordinate2D()

        northWestCorner.latitude  = center.latitude  - (self.span.latitudeDelta  / 2.0);
        northWestCorner.longitude = center.longitude - (self.span.longitudeDelta / 2.0);
        southEastCorner.latitude  = center.latitude  + (self.span.latitudeDelta  / 2.0);
        southEastCorner.longitude = center.longitude + (self.span.longitudeDelta / 2.0);

        if (
            location.latitude  >= northWestCorner.latitude &&
            location.latitude  <= southEastCorner.latitude &&

            location.longitude >= northWestCorner.longitude &&
            location.longitude <= southEastCorner.longitude
            ) {
            return true
        } else {
            return false
        }
    }
    
}
