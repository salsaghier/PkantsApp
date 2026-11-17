import Foundation

enum Room: String, CaseIterable, Codable{
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case Balcony = "Balcony"
    case Bathroom = "Bathroom"
    
    
}

enum Light: String, CaseIterable, Codable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case shade = "Low Light"
}

enum WateringDays: Int, CaseIterable, Codable {
    case everyDay = 1
    case everyTwoDays = 2
    case everyThreeDays = 3
    case onceAWeek = 7
    case every10Days = 10
    case everyTwoWeeks = 14

    // النص اللي يظهر في القائمة
    var title: String {
        switch self {
        case .everyDay:
            return "Every day"
        case .everyTwoDays:
            return "Every 2 days"
        case .everyThreeDays:
            return "Every 3 days"
        case .onceAWeek:
            return "Once a week"
        case .every10Days:
            return "Every 10 days"
        case .everyTwoWeeks:
            return "Every 2 weeks"
        }
    }
}

enum WaterAmount: String, CaseIterable , Codable {
    case small = "20–50 ml"
    case medium = "50–100 ml"
    case large = "100–200 ml"
    case Large2 = "200-300 ml"
    
}

struct Plant: Identifiable, Codable {
    var id = UUID()

    var name: String
    var room: Room
    var light: Light
    var wateringIntervalDays: WateringDays
    var waterAmount: WaterAmount

    // تاريخ آخر سقي
    var lastWateredDate: Date? = nil
}

