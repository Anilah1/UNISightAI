import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool

    @State private var showingGoogleSheet = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background: e kuqe lart, e bardhë poshtë
                VStack(spacing: 0) {
                    Color(red: 0.68, green: 0.0, blue: 0.0)
                        .frame(height: geo.size.height * 0.55)
                    Color.white
                        .frame(height: geo.size.height * 0.45)
                }
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: - Red top
                    VStack(spacing: 12) {
                        Spacer().frame(height: 10)

                        if let uiImage = UIImage(named: "Logo_01") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 1.2)
                                .colorMultiply(.white)
                                .padding(.horizontal, -40)
                                .scaleEffect(1.8)
                                .colorMultiply(.white)
                        }

                        Spacer()

                        VStack(spacing: 8) {
                            Text("UniSight AI")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Intelligent Student Performance Monitor")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)

                            HStack(spacing: 0) {
                                statItem(value: "500+", label: "Students")
                                Rectangle().fill(Color.white.opacity(0.25)).frame(width: 1, height: 28)
                                statItem(value: "91.4%", label: "Accuracy")
                                Rectangle().fill(Color.white.opacity(0.25)).frame(width: 1, height: 28)
                                statItem(value: "LSTM", label: "AI Model")
                            }
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.10))
                            .cornerRadius(16)
                            .padding(.horizontal, 28)
                        }

                        Spacer().frame(height: geo.size.height * 0.08)
                    }
                    .frame(height: geo.size.height * 0.55)

                    // MARK: - Wave + White
                    ZStack(alignment: .top) {
                        Color.white
                            .frame(height: geo.size.height * 0.45)

                        // Wave e kuqe mbi të bardhën
                        WaveShape()
                            .fill(Color(red: 0.68, green: 0.0, blue: 0.0))
                            .frame(width: geo.size.width, height: 65)
                            .offset(y: -1)

                        VStack(spacing: 18) {
                            Spacer().frame(height: 52)

                            VStack(spacing: 5) {
                                Text("Welcome back")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.black)
                                Text("Sign in with your Universum Google account")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }

                            Button(action: { showingGoogleSheet = true }) {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 40, height: 40)
                                            .shadow(color: .black.opacity(0.1), radius: 2)
                                        Text("G")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 0.26, green: 0.52, blue: 0.96),
                                                        Color(red: 0.96, green: 0.26, blue: 0.21)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    }
                                    Text("Continue with Google")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(Color(red: 0.85, green: 0.0, blue: 0.0))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(18)
                                .shadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 6)
                            }
                            .padding(.horizontal, 28)

                            HStack(spacing: 6) {
                                Image(systemName: "shield.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 0.85, green: 0.0, blue: 0.0))
                                Text("Only @universum-ks.org accounts are permitted")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(12)
                            .background(Color(red: 0.85, green: 0.0, blue: 0.0).opacity(0.06))
                            .cornerRadius(12)
                            .padding(.horizontal, 28)

                            if showError {
                                HStack(spacing: 6) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                    Text(errorMessage)
                                        .font(.system(size: 13))
                                        .foregroundColor(.red)
                                }
                            }

                            Spacer()
                        }
                        .frame(height: geo.size.height * 0.45)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showingGoogleSheet) {
            RoleSelectionView(
                isLoggedIn: $isLoggedIn,
                isAdmin: $isAdmin,
                isPresented: $showingGoogleSheet
            )
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Wave Shape
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.5))
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.5),
            control1: CGPoint(x: rect.width * 0.30, y: rect.height * 1.8),
            control2: CGPoint(x: rect.width * 0.70, y: rect.height * -0.8)
        )
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.closeSubpath()
        return path
    }
}

// MARK: - Google Account Picker
// MARK: - Google Account Picker (direkt te Role Selection)
struct GoogleAccountPickerView: View {
    @Binding var isPresented: Bool
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool
    @Binding var showError: Bool
    @Binding var errorMessage: String

    @State private var showRoleSelection = false
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("G")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(red: 0.80, green: 0.0, blue: 0.0))
                    Text("Sign in as")
                        .font(.system(size: 18, weight: .semibold))
                    Text("ah69725@universum-ks.org")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 24)

                Divider()

                Spacer()

                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Signing in...")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.80, green: 0.0, blue: 0.0).opacity(0.2))

                        Text("Anila Hajdini")
                            .font(.system(size: 20, weight: .bold))

                        Text("Tap continue to select your role")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button(action: handleLogin) {
                    HStack(spacing: 8) {
                        Text("Continue")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.80, green: 0.0, blue: 0.0))
                    .cornerRadius(14)
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 36)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showRoleSelection) {
                RoleSelectionView(
                    isLoggedIn: $isLoggedIn,
                    isAdmin: $isAdmin,
                    isPresented: $showRoleSelection
                )
            }
        }
    }

    private func handleLogin() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            isPresented = false
            showRoleSelection = true
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false), isAdmin: .constant(false))
    }
}
