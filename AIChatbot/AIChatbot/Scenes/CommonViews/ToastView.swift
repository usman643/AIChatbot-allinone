//
//  ToastView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 12/04/2025.
//

import SwiftUI


class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var message: String = ""
    @Published var isVisible: Bool = false

    private init() {}

    func show(message: String, duration: Double = 2.0) {
        self.message = message
        self.isVisible = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isVisible = false
        }
    }
}


struct ToastView: View {
    @ObservedObject var toastManager = ToastManager.shared

    var body: some View {
        if toastManager.isVisible {
            VStack {
                Spacer()
                Text(toastManager.message)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 30)
            }
            .animation(.easeInOut, value: toastManager.isVisible)
            .zIndex(1)
        }
    }
}
