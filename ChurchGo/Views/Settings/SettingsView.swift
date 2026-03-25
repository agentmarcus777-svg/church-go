import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var dailyReminder = true
    @State private var streakReminder = true
    @State private var showSignOutAlert = false

    var body: some View {
        List {
            // Account section
            Section {
                HStack(spacing: 14) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.cgCrimson, .cgDeepRed],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text("B")
                                .font(AppFont.title3)
                                .foregroundStyle(.white)
                        }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Blake")
                            .font(AppFont.headline)
                            .foregroundStyle(Color.cgCharcoal)
                        Text("blake@churchgo.app")
                            .font(AppFont.caption)
                            .foregroundStyle(Color.cgSecondaryText)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.cgSecondaryText)
                }
                .padding(.vertical, 4)
            } header: {
                Text("Account")
            }

            // Notifications
            Section {
                Toggle(isOn: $notificationsEnabled) {
                    SettingsRow(icon: "bell.fill", title: "Push Notifications", color: .cgCrimson)
                }
                .tint(Color.cgCrimson)

                Toggle(isOn: $dailyReminder) {
                    SettingsRow(icon: "clock.fill", title: "Daily Reminder", color: .cgGold)
                }
                .tint(Color.cgCrimson)
                .disabled(!notificationsEnabled)
                .opacity(notificationsEnabled ? 1.0 : 0.5)

                Toggle(isOn: $streakReminder) {
                    SettingsRow(icon: "flame.fill", title: "Streak Reminder", color: .orange)
                }
                .tint(Color.cgCrimson)
                .disabled(!notificationsEnabled)
                .opacity(notificationsEnabled ? 1.0 : 0.5)
            } header: {
                Text("Notifications")
            }

            // General
            Section {
                NavigationLink {
                    Text("App Icon Picker") // Placeholder
                        .navigationTitle("App Icon")
                } label: {
                    SettingsRow(icon: "app.fill", title: "App Icon", color: .cgCrimson)
                }

                NavigationLink {
                    Text("Units & Region") // Placeholder
                        .navigationTitle("Units")
                } label: {
                    SettingsRow(icon: "ruler.fill", title: "Distance Units", color: .blue)
                }
            } header: {
                Text("General")
            }

            // Privacy
            Section {
                NavigationLink {
                    Text("Privacy Policy")
                        .navigationTitle("Privacy")
                } label: {
                    SettingsRow(icon: "hand.raised.fill", title: "Privacy Policy", color: .green)
                }

                NavigationLink {
                    Text("Terms of Service")
                        .navigationTitle("Terms")
                } label: {
                    SettingsRow(icon: "doc.text.fill", title: "Terms of Service", color: .cgSecondaryText)
                }

                Button {
                    // Export data
                } label: {
                    SettingsRow(icon: "square.and.arrow.down.fill", title: "Export My Data", color: .cgGold)
                }
            } header: {
                Text("Privacy & Legal")
            }

            // Danger zone
            Section {
                Button {
                    showSignOutAlert = true
                } label: {
                    SettingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", color: .cgDeepRed)
                }

                Button(role: .destructive) {
                    // Delete account
                } label: {
                    SettingsRow(icon: "trash.fill", title: "Delete Account", color: .cgDeepRed)
                }
            } header: {
                Text("Account Actions")
            }

            // App info
            Section {
                HStack {
                    Text("Version")
                        .font(AppFont.body)
                    Spacer()
                    Text("1.0.0")
                        .font(AppFont.body)
                        .foregroundStyle(Color.cgSecondaryText)
                }
            } footer: {
                VStack(spacing: 4) {
                    Text("Church Go")
                        .font(AppFont.headline)
                        .foregroundStyle(Color.cgCrimson)
                    Text("Follow in His Footsteps")
                        .font(AppFont.caption)
                        .foregroundStyle(Color.cgSecondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, Theme.spacingLG)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.cgBackground)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Sign Out", isPresented: $showSignOutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {}
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

// MARK: - Settings Row

private struct SettingsRow: View {
    let icon: String
    let title: String
    var color: Color = .cgCrimson

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

            Text(title)
                .font(AppFont.body)
                .foregroundStyle(Color.cgCharcoal)
        }
    }
}

