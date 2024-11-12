//
//  Extension+RemoteConfig.swift
//  UseCase
//
//  Created by Wonji Suh  on 11/12/24.
//

import FirebaseRemoteConfig

public extension RemoteConfig {
    func fetchAsync(withExpirationDuration duration: TimeInterval) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.fetch(withExpirationDuration: duration) { status, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if status == .success {
                    continuation.resume(returning: ())
                } else {
                    let fetchError = NSError(
                        domain: "RemoteConfigError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Fetch failed with status: \(status)"]
                    )
                    continuation.resume(throwing: fetchError)
                }
            }
        }
    }
}
