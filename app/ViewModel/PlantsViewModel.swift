import Foundation
import Observation

@Observable
class PlantsViewModel {
    var plants: [Plant] = []

    init() {
        loadPlants()
    }

    func addPlant(
        name: String,
        room: Room,
        light: Light,
        wateringIntervalDays: WateringDays,
        waterAmount: WaterAmount
    )
    {
        let newPlant = Plant(
            name: name,
            room: room,
            light: light,
            wateringIntervalDays: wateringIntervalDays,
            waterAmount: waterAmount
        )

        plants.append(newPlant)
        savePlants()
        // يبدأ التذكير من وقت إضافة النبتة
        Task {
            await NotificationManager.schedule(for: newPlant)
        }
    }

    private func savePlants() {
        do {
            let data = try JSONEncoder().encode(plants)
            UserDefaults.standard.set(data, forKey: "savedPlants")
        } catch {
            print("تعذر حفظ النباتات: \(error)")
        }
    }

    private func loadPlants() {
        guard let data = UserDefaults.standard.data(
            forKey: "savedPlants"
        ) else {
            return
        }

        do {
            plants = try JSONDecoder().decode(
                [Plant].self,
                from: data
            )
        } catch {
            print("تعذر قراءة النباتات: \(error)")
        }
    }
    // تعديل نبتة موجودة
    func updatePlant(_ plant: Plant) {
        if let index = plants.firstIndex(
            where: { $0.id == plant.id }
        ) {
            plants[index] = plant
            savePlants()

            NotificationManager.cancel(for: plant)

            Task {
                await NotificationManager.schedule(for: plant)
            }
        }
    }

    // حذف نبتة
    func deletePlant(_ plant: Plant) {
        // نلغي إشعارات النبتة أولًا
        NotificationManager.cancel(for: plant)

        plants.removeAll { $0.id == plant.id }
        savePlants()
    }

    // هل النبتة انسقت اليوم؟
    // هل النبتة مكتملة إلى موعد السقي القادم؟
    func isWateredToday(_ plant: Plant) -> Bool {
        guard let lastDate = plant.lastWateredDate else {
            return false
        }

        let calendar = Calendar.current

        // بداية اليوم اللي انسقت فيه النبتة
        let wateredDay = calendar.startOfDay(for: lastDate)

        // عدد الأيام المختار: يوم، يومين، ثلاثة أو أسبوع
        let days = plant.wateringIntervalDays.rawValue

        guard let nextWateringDay = calendar.date(
            byAdding: .day,
            value: days,
            to: wateredDay
        ) else {
            return false
        }

        // تبقى الصح إلى بداية يوم السقي القادم
        return Date() < nextWateringDay
    }

    // عدد النباتات اللي عليها صح اليوم
    var completedCount: Int {
        plants.filter { isWateredToday($0) }.count
    }

    // نسبة تقدم الشريط
    var progress: Double {
        guard !plants.isEmpty else {
            return 0
        }

        return Double(completedCount) / Double(plants.count)
    }

    // وضع الصح أو إزالتها
    func toggleWatered(_ plant: Plant) {
        if let index = plants.firstIndex(
            where: { $0.id == plant.id }
        ) {
            if isWateredToday(plants[index]) {
                // إزالة الصح
                plants[index].lastWateredDate = nil
            } else {
                // تسجيل وقت إكمال السقي
                plants[index].lastWateredDate = Date()
            }

            savePlants()

            let updatedPlant = plants[index]

            // نلغي الموعد السابق والإشعار الظاهر
            NotificationManager.cancel(for: updatedPlant)

            // نحسب موعدًا جديدًا من الآن
            Task {
                await NotificationManager.schedule(for: updatedPlant)
            }
        }
    }
    // تكون true إذا كل النباتات عليها صح
    var allCompleted: Bool {
        !plants.isEmpty && completedCount == plants.count
    }

} // نهاية PlantsViewModel
    
    

