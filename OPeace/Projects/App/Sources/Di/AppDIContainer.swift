//
//  AppDIContainer.swift
//  OPeace
//
//  Created by 서원지 on 7/21/24.
//

import Foundation
import DiContainer
import UseCase

public final class AppDIContainer {
    public static let shared: AppDIContainer = .init()

    private let diContainer: DependencyContainer = .live

    private init() {
    }

    public func registerDependencies() async {
        await registerRepositories()
        await registerUseCases()
    }

    // MARK: - Use Cases
    private func registerUseCases() async {
        await registerAuthUseCase()
        await registerSignUpUseCase()

//        await registerQrCodeUseCase()
    }

    private func registerAuthUseCase() async {
        await diContainer.register(AuthUseCaseProtocol.self) {
            guard let repository = self.diContainer.resolve(AuthRepositoryProtocol.self) else {
                assertionFailure("AuthRepositoryProtocol must be registered before registering AuthUseCaseProtocol")
                return AuthUseCase(repository: DefaultAuthRepository())
            }
            return AuthUseCase(repository: repository)
        }
    }
    
    private func registerSignUpUseCase() async {
        await diContainer.register(SignUpUseCaseProtocol.self) {
            guard let repository = self.diContainer.resolve(SignUpRepositoryProtocol.self) else {
                assertionFailure("SignUpRepositoryProtocol must be registered before registering SignUpUseCaseProtocol")
                return SignUpUseCase(repository: DefaultSignUpRepository())
            }
            return SignUpUseCase(repository: repository)
        }
    }


    // MARK: - Repositories Registration
    private func registerRepositories() async {
        await registerAuthRepositories()
        await registerSignUpRepositories()
//        await registerFireStoreRepositories()
//        await registerQrCodeRepositories()
    }

    private func registerAuthRepositories() async {
        await diContainer.register(AuthRepositoryProtocol.self) {
            AuthRepository()
        }
    }
    
    private func registerSignUpRepositories() async {
        await diContainer.register(SignUpRepositoryProtocol.self) {
            SingUpRepository()
        }
    }
    
//    private func registerQrCodeRepositories() async {
//        await diContainer.register(QrCodeRepositoryProtcool.self) {
//            QrCodeRepository()
//        }
//    }
}

