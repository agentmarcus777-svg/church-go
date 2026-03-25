import Foundation

final class SupabaseClient: @unchecked Sendable {
    let auth = AuthClient()

    init(supabaseURL: URL, supabaseKey: String) {}

    func from(_ table: String) -> QueryBuilder {
        QueryBuilder()
    }
}

final class QueryBuilder: @unchecked Sendable {
    func select(_ columns: String = "*") -> QueryBuilder { self }
    func insert(_ values: Any) -> QueryBuilder { self }
    func update(_ values: Any) -> QueryBuilder { self }
    func delete() -> QueryBuilder { self }
    func eq(_ column: String, value: Any) -> QueryBuilder { self }
    func ilike(_ column: String, pattern: String) -> QueryBuilder { self }
    func single() -> QueryBuilder { self }
    func limit(_ count: Int) -> QueryBuilder { self }
    func order(_ column: String, ascending: Bool = true) -> QueryBuilder { self }
    func `in`(_ column: String, value: [Any]) -> QueryBuilder { self }

    func execute<T: Decodable>() async throws -> PostgrestResponse<T> {
        throw SupabaseError.notConfigured
    }
}

struct PostgrestResponse<T: Decodable> {
    let value: T

    init(value: T) {
        self.value = value
    }
}

enum SupabaseError: Error {
    case notConfigured
}

final class AuthClient: @unchecked Sendable {
    var session: Session {
        get async throws {
            Session(user: SupabaseAuthUser(id: UUID().uuidString))
        }
    }

    func signInWithIdToken(credentials: SignInWithIdTokenCredentials) async throws {}

    func signOut() async throws {}
}

struct Session: Sendable {
    let user: SupabaseAuthUser
}

struct SupabaseAuthUser: Sendable {
    let id: String
}

struct SignInWithIdTokenCredentials: Sendable {
    let provider: Provider
    let idToken: String
    let nonce: String
}

enum Provider: Sendable {
    case apple
}
