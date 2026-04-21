//
//  GeoFenceScreen.swift
//  GeoFencingDemo
//
//  Created by David Emery on 4/20/26.
//

import SwiftUI

struct GeofenceScreen: View {
    @StateObject private var vm = GeofenceViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Text("GeoFence Reminder")
                .font(.title2).bold()

            Text(vm.statusText)
            Text(vm.lastEventText)
                .font(.footnote)

            HStack {
                Button("Request Permissions") { vm.requestPermissions() }
                Button("Start") { vm.startGeofence() }
                Button("Stop") { vm.stopGeofence() }
                
            }
            .buttonStyle(.borderedProminent)

            Button("Clear Log") { vm.clearLog() }
                .buttonStyle(.bordered)

            
            List(vm.events) { event in
                VStack(alignment: .leading) {
                    Text(event.message)
                    Text(event.date.formatted(date: .abbreviated, time: .standard))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
    }
}


#Preview {
    GeofenceScreen()
}
