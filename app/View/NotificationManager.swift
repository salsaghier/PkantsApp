import Foundation
import UserNotifications

enum NotificationManager {

    // جدولة التذكير حسب مدة السقي
    static func schedule(for plant: Plant) async {
        let center = UNUserNotificationCenter.current()

        do {
            // طلب الإذن، والنظام يتذكر اختيار المستخدمة
            let allowed = try await center.requestAuthorization(
                options: [.alert, .sound]
            )

            guard allowed else {
                return
            }

            // محتوى الإشعار
            let content = UNMutableNotificationContent()
            
            content.title = "Planto"
            content.body = "Hey! let's water your plant"
            content.sound = .default

            // نحول الأيام إلى ثوانٍ
            //let days = plant.wateringIntervalDays.rawValue
           // let seconds = Double(days) * 24 * 60 * 60
            // للتجربة: يتكرر كل دقيقة
            let seconds: Double = 60

                        
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: seconds,
                repeats: true
            )
            
            // هوية النبتة تميز إشعارها عن بقية النباتات
            let request = UNNotificationRequest(
                identifier: plant.id.uuidString,
                content: content,
                trigger: trigger
            )

            // نفس الهوية تستبدل الجدولة السابقة
            try await center.add(request)

        } catch {
            print("تعذر جدولة الإشعار: \(error)")
        }
    }

    // إلغاء التذكير وإزالة الإشعار الظاهر
    static func cancel(for plant: Plant) {
        let center = UNUserNotificationCenter.current()
        let ids = [plant.id.uuidString]

        center.removePendingNotificationRequests(
            withIdentifiers: ids
        )

        center.removeDeliveredNotifications(
            withIdentifiers: ids
        )
    }
}

