//
//  Activity.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.
//


import Foundation

struct Activity: Codable, Identifiable {
    let id = UUID()
    let start: String
    let end:   String
    let name:  String
}

struct DayPlan: Codable, Identifiable {
    let id = UUID()
    let date:  String  
    let title: String
    let activities: [Activity]
}
