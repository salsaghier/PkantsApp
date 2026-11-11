import Foundation

enum Room: String, CaseIterable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
}

enum Light: String, CaseIterable {
    case fullSun = "Full sun"
    case partialSun = "Partial sun"
    case shade = "Shade"
}

enum WateringDays: Int, CaseIterable {
    case everyDay = 1
    case everyTwoDays = 2
    case everyThreeDays = 3
    case everyWeek = 7
}

enum WaterAmount: String, CaseIterable {
    case small = "20–50 ml"
    case medium = "50–100 ml"
    case large = "100–200 ml"
}

struct Plant: Identifiable {
    let id = UUID()

    var name: String
    var room: Room
    var light: Light
    var wateringIntervalDays: WateringDays
    var waterAmount: WaterAmount
}
