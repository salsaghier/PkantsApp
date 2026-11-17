import SwiftUI

struct RootView: View {
    // بيانات النباتات، وتسترجع المحفوظ تلقائيًا
    @State private var viewModel = PlantsViewModel()

    // تبدأ false عشان تظهر الويلكوم
    @State private var showPlants = false

    var body: some View {
        if showPlants {
            // تعرض النباتات أو yet حسب القائمة
            ContentView(viewModel: viewModel)
        } else {
            WelcomeView {
                // عند الضغط على Start نعرض صفحة النباتات
                showPlants = true
            }
        }
    }
}
