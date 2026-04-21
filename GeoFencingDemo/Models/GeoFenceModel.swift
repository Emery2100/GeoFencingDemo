//
//  GeoFenceModel.swift
//  GeoFencingDemo
//
//  Created by David Emery on 4/20/26.
//

import Foundation

struct GeofenceModel : Identifiable{
    
    let id:UUID
    let date:Date
    let message:String
    
    init(id: UUID = UUID(), date: Date = Date(), message: String) {
        self.id = id
        self.date = date
        self.message = message
    }
    
    
}
