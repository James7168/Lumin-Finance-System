//
//  ProfileView.swift
//  Lumin
//
//  Created by James on 12/01/2026.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserSettings.self) private var settings

    var body: some View {
        @Bindable var settings = settings

        NavigationStack {
            VStack(spacing: 21) {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .padding(23)
                    .frame(width: 80, height: 80)
                    .background(.ultraThinMaterial.opacity(0.3))
                    .foregroundStyle(.white)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 12) {
                    Text("Main Currency")
                        .whiteBodyText()

                    Picker("Base Currency", selection: $settings.baseCurrency) {
                        ForEach(Currency.allCases) { c in
                            Text(c.rawValue).tag(c)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 24))

                Spacer()
            }
            .padding()
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Label("Dismiss", systemImage: "xmark")
                }
            }
            .background(.ultraThinMaterial.opacity(0.01))
        }
    }
}

#Preview {
    ProfileView()
        .environment(UserSettings())
        .preferredColorScheme(.dark)
}
