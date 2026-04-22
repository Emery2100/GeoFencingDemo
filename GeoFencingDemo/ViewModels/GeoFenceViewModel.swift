//
//  GeoFenceViewModel.swift
//  GeoFencingDemo
//
//  Created by David Emery on 4/20/26.
//

import Foundation
import CoreLocation
import Combine

class GeofenceViewModel: ObservableObject{
    
    @Published var statusText : String = "Not started"
    @Published var lastEventText :  String = "No events yet"
    @Published var events: [GeofenceModel] = []
    
    private let service: GeofenceService
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(service:GeofenceService = GeofenceService()){
        self.service = service
        bindService()
    }
    
    func bindService(){
    
        service.$statusText
            .receive(on: DispatchQueue.main)
            .assign(to: &$statusText)
        
        service.$lastEventText
            .receive(on: DispatchQueue.main)
            .sink{
                [weak self] text in
                guard let self else {return}
                
                self.lastEventText = text
                
                if text != "No events yet" {
                    self.events.insert(
                        GeofenceModel(date: Date(), message: text),
                        at: 0
                    )
                }
                
            }.store(in: &cancellables)
    }
    
    
    
    func requestPermissions(){
        service.requestPermissions()
    }
    
    func startGeofence(){
        let center:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 32.708333, longitude: -117.154722) // Point in the map
        let radius: CLLocationDistance = 200 // Big of a radius
        
        service.startGeofence(center: center, radius: radius, id: "DemoRegion")
    }
    
    func stopGeofence(){
        service.stopGeofence(id: "DemoRegion")
    }
    
    func clearLog() {
         events.removeAll()
     }
    
    

func StartGeofence(){
    let center = CLLocationCoordinate2D(latitude: 32.708333, longitude: -117.154722)
    
        service.startGeofence(
        center: center,
        radius: 200,
        id: "Home"
    )
}
}
