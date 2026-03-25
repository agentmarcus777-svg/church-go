import Foundation

final class SupabaseClient {
    let auth = AuthClient()

    init(supabaseURL: URL, supabaseKey: String) {}
}

final class AuthClient {
    var session: Session {
        get async throws {
            Session(user: User(id: UUID().uuidString))
        }
    }

    func signInWithIdToken(credentials: SignInWithIdTokenCredentials) async throws {}

    func signOut() async throws {}
}

struct Session {
    let user: User
}

struct User {
    let id: String
}

struct SignInWithIdTokenCredentials {
    let provider: Provider
    let idToken: String
    let nonce: String
}

enum Provider {
    case apple
}
