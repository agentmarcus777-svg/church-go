import Foundation
import Combine
// import Supabase  // using local shim

// SupabaseAuthUser defined in SupabaseShim.swift

@MainActor
final class SupabaseService: ObservableObject {
    static let shared = SupabaseService()

    let client: SupabaseClient

    // Configure these with your production Supabase project credentials.
    private static let supabaseURL = URL(string: "https://your-project.supabase.co")!
    private static let supabaseAnonKey = "your-anon-key"

    private init() {
        client = SupabaseClient(
            supabaseURL: Self.supabaseURL,
            supabaseKey: Self.supabaseAnonKey
        )
    }

    // MARK: - Auth

    var currentUser: SupabaseAuthUser? {
        get async {
            try? await client.auth.session.user
        }
    }

    func signInWithApple(idToken: String, nonce: String) async throws {
        try await client.auth.signInWithIdToken(
            credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
        )
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }
}
