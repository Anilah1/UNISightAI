//
//  SplashView.swift
//  UniSightAI
//
//  Created by Anila on 31.5.2026.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0.0
    @State private var textOpacity: Double = 0.0

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color(red: 0.80, green: 0.0, blue: 0.0)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    if let uiImage = UIImage(named: "Logo_01") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 500)
                            .colorMultiply(.white)
                            .scaleEffect(scale)
                            .opacity(opacity)
                    }

                    Text("UniSight AI")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(textOpacity)

                    Text("Intelligent Student Performance Monitor")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .opacity(textOpacity)
                        .padding(.horizontal, 40)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    scale = 1.0
                    opacity = 1.0
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                    textOpacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    withAnimation(.easeIn(duration: 0.4)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
