//
//  GeoFenceService.swift
//  GeoFencingDemo
//
//  Created by David Emery on 4/20/26.
//

import Foundation
import CoreLocation

class GeofenceService: NSObject,ObservableObject, CLLocationManagerDelegate {
    
    @Published var statusText: String = "Not started"
    @Published var lastEventText: String = "No events yet"
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
        
    
    func requestPermissions(){
        manager.requestAlwaysAuthorization()
    }
    
    
    func startGeofence(center: CLLocationCoordinate2D,radius:CLLocationDistance,id:String){
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            statusText = "Geofence not available on this device"
            return
        }
        
        let region = CLCircularRegion(center: center, radius: radius, identifier: id)
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        manager.startMonitoring(for: region)
        statusText = "Monitoring : \(id)"
        
    }
    
    func stopGeofence(id:String){
        for region in manager.monitoredRegions{
            if region.identifier == id {
                manager.stopMonitoring(for:region)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        lastEventText = "Did start monitoring: \(region.identifier)"
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        lastEventText = "🚪 Entered: \(region.identifier)"

    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
           lastEventText = "🚪 Exited: \(region.identifier)"
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           lastEventText = "❌ Error: \(error.localizedDescription)"
       }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
             case .notDetermined: statusText = "Permission: not determined"
             case .restricted: statusText = "Permission: restricted"
             case .denied: statusText = "Permission: denied"
             case .authorizedWhenInUse: statusText = "Permission: when in use"
             case .authorizedAlways: statusText = "Permission: always "
             @unknown default: statusText = "Permission: unknown"
            }
        }
    
    
    
    
    
}
