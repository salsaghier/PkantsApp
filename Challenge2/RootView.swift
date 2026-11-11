import SwiftUI

struct RootView: View {
    @AppStorage("hasStarted") private var hasStarted = false

    @State private var viewModel = PlantsViewModel()
    @State private var showPlantForm = false

    var body: some View {
        Group {
            if hasStarted {
                ContentView(viewModel: viewModel)
            } else {
                WelcomeView {
                    showPlantForm = true
                }
            }
        }
        .sheet(
            isPresented: $showPlantForm,
            onDismiss: {
                hasStarted = true
            }
        ) {
            PlantFormView(viewModel: viewModel)
        }
    }
}
