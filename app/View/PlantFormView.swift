import SwiftUI

struct PlantFormView: View {
    @Environment(\.dismiss) private var dismiss

    let viewModel: PlantsViewModel
    let plantToEdit: Plant?

    // قيم الحقول أثناء تعبئة النموذج
    @State private var name = ""
    @State private var room: Room = .bedroom
    @State private var light: Light = .fullSun
    @State private var wateringDays: WateringDays = .everyDay
    @State private var waterAmount: WaterAmount = .small

    // ألوان النموذج
    private let background = Color(
        red: 0.11, green: 0.11, blue: 0.11
    )

    private let rowColor = Color(
        red: 0.17, green: 0.17, blue: 0.17
    )

    // بدون نبتة: إضافة، ومع نبتة: تعديل
    init(
        viewModel: PlantsViewModel,
        plantToEdit: Plant? = nil
    ) {
        self.viewModel = viewModel
        self.plantToEdit = plantToEdit
    }

    var body: some View {
        VStack(spacing: 0) {
            // شريط علوي مخصص
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 44, height: 44)
                        .background(rowColor)
                        .clipShape(Circle())
                }

                Spacer()

                Text("Set Reminder")
                    .font(.headline)

                Spacer()

                Button {
                    save()
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .frame(width: 44, height: 44)
                        .background(.teal)
                        .clipShape(Circle())
                }
                .disabled(cleanName.isEmpty)
                .opacity(cleanName.isEmpty ? 0.4 : 1)
            }
            .padding(20)

            // المحتوى قابل للتمرير
            ScrollView {
                VStack(spacing: 40) {
                    // خانة الاسم
                    HStack {
                        Text("Plant Name")

                        TextField("Pothos", text: $name)
                    }
                    .padding()
                    .background(rowColor)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )

                    // الغرفة والإضاءة
                    VStack(spacing: 0) {
                        HStack {
                            Label("Room", systemImage: "location")

                            Spacer()

                            Picker("Room", selection: $room) {
                                ForEach(
                                    Room.allCases,
                                    id: \.self
                                ) { option in
                                    Text(option.rawValue)
                                        .tag(option)
                                }
                            }
                            .labelsHidden()
                        }

                        Divider()

                        HStack {
                            Label("Light", systemImage: "sun.max")

                            Spacer()

                            Picker("Light", selection: $light) {
                                ForEach(
                                    Light.allCases,
                                    id: \.self
                                ) { option in
                                    Text(option.rawValue)
                                        .tag(option)
                                }
                            }
                            .labelsHidden()
                        }
                    }
                    .padding()
                    .background(rowColor)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )

                    // تكرار السقي وكمية الماء
                    VStack(spacing: 0) {
                        HStack {
                            Label(
                                "Watering Days",
                                systemImage: "drop"
                            )

                            Spacer()

                            Picker(
                                "Watering Days",
                                selection: $wateringDays
                            ) {
                                ForEach(
                                    WateringDays.allCases,
                                    id: \.self
                                ) { option in
                                    Text(option.title)
                                        .tag(option)
                                }
                            }
                            .labelsHidden()
                        }

                        Divider()

                        HStack {
                            Label("Water", systemImage: "drop")

                            Spacer()

                            Picker(
                                "Water",
                                selection: $waterAmount
                            ) {
                                ForEach(
                                    WaterAmount.allCases,
                                    id: \.self
                                ) { option in
                                    Text(option.rawValue)
                                        .tag(option)
                                }
                            }
                            .labelsHidden()
                        }
                    }
                    .padding()
                    .background(rowColor)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )

                    // الحذف يظهر عند التعديل فقط
                    if let plant = plantToEdit {
                        Button(role: .destructive) {
                            viewModel.deletePlant(plant)
                            dismiss()
                        } label: {
                            Text("Delete Reminder")
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(rowColor)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(20)
                .padding(.top, 24)
            }
        }
        .background(background.ignoresSafeArea())
        .foregroundStyle(.white)
        .tint(.mint)
        .pickerStyle(.menu)
        .preferredColorScheme(.dark)
        .onAppear {
            // تعبئة البيانات عند فتح نبتة للتعديل
            if let plant = plantToEdit {
                name = plant.name
                room = plant.room
                light = plant.light
                wateringDays = plant.wateringIntervalDays
                waterAmount = plant.waterAmount
            }
        }
    }

    // إزالة الفراغات من بداية الاسم ونهايته
    private var cleanName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func save() {
        if var plant = plantToEdit {
            // تعديل نفس النبتة مع الاحتفاظ بهويتها
            plant.name = cleanName
            plant.room = room
            plant.light = light
            plant.wateringIntervalDays = wateringDays
            plant.waterAmount = waterAmount

            viewModel.updatePlant(plant)
        } else {
            // إضافة نبتة جديدة
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
