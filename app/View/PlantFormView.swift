import SwiftUI

struct PlantFormView: View {
    @Environment(\.dismiss) private var dismiss

    let viewModel: PlantsViewModel

    // إذا وصلت نبتة نعدّلها، وإذا nil نضيف جديدة
    let plantToEdit: Plant?

    @State private var name = ""
    @State private var room: Room = .bedroom
    @State private var light: Light = .fullSun
    @State private var wateringDays: WateringDays = .everyDay
    @State private var waterAmount: WaterAmount = .small

    // القيمة الافتراضية nil عشان الإضافة القديمة تظل شغالة
    init(
        viewModel: PlantsViewModel,
        plantToEdit: Plant? = nil
    ) {
        self.viewModel = viewModel
        self.plantToEdit = plantToEdit
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Plant Name", text: $name)
                }

                Section {
                    Picker("Room", selection: $room) {
                        ForEach(Room.allCases, id: \.self) { option in
                            Text(option.rawValue)
                                .tag(option)
                        }
                    }

                    Picker("Light", selection: $light) {
                        ForEach(Light.allCases, id: \.self) { option in
                            Text(option.rawValue)
                                .tag(option)
                        }
                    }
                }

                Section {
                    Picker("Watering Days", selection: $wateringDays) {
                        ForEach(WateringDays.allCases, id: \.self) { option in
                            Text(
                                option.rawValue == 1
                                ? "Every day"
                                : "Every \(option.rawValue) days"
                            )
                            .tag(option)
                        }
                    }

                    Picker("Water", selection: $waterAmount) {
                        ForEach(WaterAmount.allCases, id: \.self) { option in
                            Text(option.rawValue)
                                .tag(option)
                        }
                    }
                }

                // الحذف يظهر فقط عند تعديل نبتة موجودة
                if let plant = plantToEdit {
                    Section {
                        Button("Delete Reminder", role: .destructive) {
                            viewModel.deletePlant(plant)
                            dismiss()
                        }
                    }
                }
            }
            .pickerStyle(.menu)
            .navigationTitle(
                plantToEdit == nil ? "Set Reminder" : "Edit Reminder"
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(
                        name.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
            }
        }
        .preferredColorScheme(.dark)
        .tint(.mint)
        .onAppear {
            // نعبي الحقول ببيانات النبتة عند التعديل
            if let plant = plantToEdit {
                name = plant.name
                room = plant.room
                light = plant.light
                wateringDays = plant.wateringIntervalDays
                waterAmount = plant.waterAmount
            }
        }
    }

    private func save() {
        let cleanName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if var plant = plantToEdit {
            // نعدّل نفس النبتة مع الاحتفاظ بهويتها
            plant.name = cleanName
            plant.room = room
            plant.light = light
            plant.wateringIntervalDays = wateringDays
            plant.waterAmount = waterAmount

            viewModel.updatePlant(plant)
        } else {
            // إذا ما فيه نبتة للتعديل، نضيف جديدة
            viewModel.addPlant(
                name: cleanName,
                room: room,
                light: light,
                wateringIntervalDays: wateringDays,
                waterAmount: waterAmount
            )
        }
    }
}
