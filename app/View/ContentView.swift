import SwiftUI

struct ContentView: View {
    let viewModel: PlantsViewModel

    @State private var selectedPlant: Plant?
    @State private var showPlantForm = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack {
                Text("My Plants 🌱")
                    .font(.title)
                    .bold()
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                Divider()
                    .overlay(.gray)

                if viewModel.plants.isEmpty {
                    Spacer()

                    Text("No reminders set yet..")
                        .foregroundStyle(.gray)

                    Spacer()
                } else {
                    // النص وشريط التقدم
                    VStack(spacing: 12) {
                        if viewModel.completedCount == 0 {
                            Text("Your plants are waiting for a sip")
                        } else {
                            Text(
                                "\(viewModel.completedCount) of your plants feel loved today"
                            )
                        }

                        ProgressView(value: viewModel.progress)
                            .progressViewStyle(.linear)
                            .tint(.mint)
                            .animation(
                                .easeInOut,
                                value: viewModel.progress
                            )
                    }
                    .padding(.vertical, 20)

                    // قائمة النباتات
                    List(viewModel.plants) { plant in
                        HStack(spacing: 12) {
                            // زر الصح
                            Button {
                                withAnimation {
                                    viewModel.toggleWatered(plant)
                                }
                            } label: {
                                ZStack {
                                    if viewModel.isWateredToday(plant) {
                                        Circle()
                                            .fill(Color.mint)

                                        Image(systemName: "checkmark")
                                            .font(
                                                .system(
                                                    size: 14,
                                                    weight: .bold
                                                )
                                            )
                                            .foregroundStyle(.black)
                                    } else {
                                        Circle()
                                            .stroke(
                                                Color.gray,
                                                lineWidth: 1.5
                                            )
                                    }
                                }
                                .frame(width: 26, height: 26)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.borderless)

                            // بيانات النبتة
                            VStack(alignment: .leading, spacing: 8) {
                                // أيقونة الموقع واسم الغرفة
                                Label(
                                    "in \(plant.room.rawValue)",
                                    systemImage: "location"
                                )
                                .font(.caption)
                                .foregroundStyle(.gray)

                                Text(plant.name)
                                    .font(.title2)
                                    .foregroundStyle(
                                        viewModel.isWateredToday(plant)
                                            ? Color.gray
                                            : Color.white
                                    )

                                // الإضاءة وكمية الماء
                                HStack(spacing: 12) {
                                    Label(
                                        plant.light.rawValue,
                                        systemImage: "sun.max"
                                    )
                                    .foregroundStyle(
                                        Color(
                                            red: 0.80,
                                            green: 0.77,
                                            blue: 0.45
                                        )
                                    )
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        Color(
                                            red: 0.09,
                                            green: 0.09,
                                            blue: 0.11
                                        )
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 9)
                                    )

                                    Label(
                                        plant.waterAmount.rawValue,
                                        systemImage: "drop"
                                    )
                                    .foregroundStyle(
                                        Color(
                                            red: 0.73,
                                            green: 0.91,
                                            blue: 0.95
                                        )
                                    )
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        Color(
                                            red: 0.09,
                                            green: 0.09,
                                            blue: 0.11
                                        )
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 9)
                                    )
                                }
                                .font(.system(size: 14))
                            }
                            .opacity(
                                viewModel.isWateredToday(plant)
                                    ? 0.6
                                    : 1
                            )
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPlant = plant
                            }
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.black)

                        // سحب الصف لإظهار الحذف
                        .swipeActions(
                            edge: .trailing,
                            allowsFullSwipe: false
                        ) {
                            Button(role: .destructive) {
                                viewModel.deletePlant(plant)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }

                // زر الإضافة
                HStack {
                    Spacer()

                    Button {
                        showPlantForm = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(.teal)
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
            .foregroundStyle(.white)
        }

        // نموذج الإضافة
        .sheet(isPresented: $showPlantForm) {
            PlantFormView(viewModel: viewModel)
        }

        // نموذج التعديل
        .sheet(item: $selectedPlant) { plant in
            PlantFormView(
                viewModel: viewModel,
                plantToEdit: plant
            )
        }
    }
}

#Preview {
    ContentView(viewModel: PlantsViewModel())
}

