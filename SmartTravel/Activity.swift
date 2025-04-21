//
//  Activity.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.


import Foundation

/// A single day’s plan, with a date and a list of Events.
struct DayPlan: Identifiable, Codable {
    let id    = UUID()
    let date:  String
    let title: String
    let events: [Event]

    enum CodingKeys: String, CodingKey {
        case date, title, events, activities
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        date  = try c.decode(String.self, forKey: .date)
        title = try c.decode(String.self, forKey: .title)

        // some of your older code writes “activities” instead of “events”:
        if c.contains(.events) {
            events = try c.decode([Event].self, forKey: .events)
        } else if c.contains(.activities) {
            let acts = try c.decode([Activity].self, forKey: .activities)
            events = acts.map { act in
                Event(
                  start:    act.start,
                  end:      act.end,    // now optional
                  name:     act.name,
                  type:     "activity",
                  location: "",
                  price:    act.price
                )
            }
        } else {
            events = []
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(date,   forKey: .date)
        try c.encode(title,  forKey: .title)
        try c.encode(events, forKey: .events)
    }
}

/// A single itinerary entry.  `end` is now optional, so `null` in JSON becomes `nil`.
struct Event: Identifiable, Codable {
    let id       = UUID()
    let start:   String
    let end:     String?    // ← was String
    let name:    String
    let type:    String
    let location:String
    let price:   String?
}


/// Backwards‑compat helper if you ever decode the old “activities” schema
struct Activity: Identifiable, Codable {
    let id    = UUID()
    let start: String
    let end:   String
    let name:  String
    let price: String
}
