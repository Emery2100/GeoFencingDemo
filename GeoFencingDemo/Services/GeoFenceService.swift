//
//  GeoFenceService.swift
//  GeoFencingDemo
//
//  Created by David Emery on 4/20/26.
//

import Foundation
import CoreLocation
import Combine


class GeofenceService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    @Published var statusText: String = "Not started"
    @Published var lastEventText: String = "No events yet"
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    // MARK: - Permissions
    func requestPermissions() {
        manager.requestAlwaysAuthorization()
    }
    
    // MARK: - Start / Stop
    
    func startGeofence(center: CLLocationCoordinate2D, radius: CLLocationDistance, id: String) {
        
        let region = CLCircularRegion(center: center, radius: radius, identifier: id)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        manager.startMonitoring(for: region)
        statusText = "Monitoring started"
    }
    
    func stopGeofence(id: String) {
        for region in manager.monitoredRegions {
            if region.identifier == id {
                manager.stopMonitoring(for: region)
            }
        }
        statusText = "Monitoring stopped"
    }
    
    // MARK: - Delegate Events
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        DispatchQueue.main.async {
            self.lastEventText = "Entered zone (\(region.identifier))"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        DispatchQueue.main.async {
            self.lastEventText = "Exited zone (\(region.identifier))"
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            statusText = "Authorized Always ✅"
        case .authorizedWhenInUse:
            statusText = "Authorized When In Use ⚠️"
        case .denied:
            statusText = "Permission Denied ❌"
        case .restricted:
            statusText = "Restricted ❌"
        case .notDetermined:
            statusText = "Not Determined"
        @unknown default:
            statusText = "Unknown"
        }
    }
}
