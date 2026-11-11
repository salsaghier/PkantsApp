import Foundation
import Observation

@Observable
class PlantsViewModel {
    var plants: [Plant] = []

    func addPlant(
        name: String,
        room: Room,
        light: Light,
        wateringIntervalDays: WateringDays,
        waterAmount: WaterAmount
    ) {
        let newPlant = Plant(
            name: name,
            room: room,
            light: light,
            wateringIntervalDays: wateringIntervalDays,
            waterAmount: waterAmount
        )

        plants.append(newPlant)
    }
}
