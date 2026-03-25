import Foundation

public final class SupabaseClient: Sendable {
    public let auth = AuthClient()

    public init(supabaseURL: URL, supabaseKey: String) {}
}

public final class AuthClient: Sendable {
    public init() {}

    public var session: Session {
        get async throws {
            Session(user: User(id: UUID().uuidString))
        }
    }

    public func signInWithIdToken(credentials: SignInWithIdTokenCredentials) async throws {}

    public func signOut() async throws {}
}

public struct Session: Sendable {
    public let user: User

    public init(user: User) {
        self.user = user
    }
}

public struct User: Sendable {
    public let id: String

    public init(id: String) {
        self.id = id
    }
}

public struct SignInWithIdTokenCredentials: Sendable {
    public let provider: Provider
    public let idToken: String
    public let nonce: String

    public init(provider: Provider, idToken: String, nonce: String) {
        self.provider = provider
        self.idToken = idToken
        self.nonce = nonce
    }
}

public enum Provider: Sendable {
    case apple
}
