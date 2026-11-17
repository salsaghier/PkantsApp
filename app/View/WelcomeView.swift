import SwiftUI

struct WelcomeView: View {
    // الانتقال لصفحة النباتات
    let onStart: () -> Void

    // ألوان التصميم
    private let buttonColor = Color(
        red: 39 / 255,
        green: 119 / 255,
        blue: 99 / 255
    )

    private let buttonBorder = Color(
        red: 76 / 255,
        green: 161 / 255,
        blue: 139 / 255
    )

    private let subtitleColor = Color(
        red: 151 / 255,
        green: 151 / 255,
        blue: 137 / 255
    )

    var body: some View {
        GeometryReader { screen in
            ZStack {
                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // العنوان
                    Text("My Plants 🌱")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 18)

                    // الخط تحت العنوان
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 1)
                        .padding(.leading, 16)

                    // المسافة فوق النبتة
                    Spacer()
                        .frame(height: screen.size.height * 0.09)

                    Image("Plants")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190, height: 190)

                    Text("Start your plant journey!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, 30)

                    Text(
                        "Now all your plants will be in one place and\nwe will help you take care of them :) 🪴"
                    )
                    .font(.system(size: 14))
                    .foregroundStyle(subtitleColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)

                    // المسافة فوق الزر
                    Spacer()
                        .frame(height: screen.size.height * 0.12)

                    Button {
                        onStart()
                    } label: {
                        Text("Set Plant Reminder")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(
                                width: screen.size.width * 0.66,
                                height: 40
                            )
                            .background(
                                LinearGradient(
                                    colors: [
                                        buttonColor,
                                        buttonColor.opacity(0.95)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(Capsule())
                            .overlay {
                                Capsule()
                                    .stroke(
                                        buttonBorder,
                                        lineWidth: 1
                                    )
                            }
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WelcomeView(onStart: {})
}
