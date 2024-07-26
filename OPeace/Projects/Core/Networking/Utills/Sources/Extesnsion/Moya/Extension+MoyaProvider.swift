//
//  Extension+MoyaProvider.swift
//  Utill
//
//  Created by 서원지 on 7/18/24.
//

import Foundation
import Combine
import Combine
import Moya
import CombineMoya

extension MoyaProvider {
    //MARK: - MoyaProvider에 요청을 비동기적으로 처리하는 확장 함수 추가
    public func requestAsync<T: Decodable>(_ target: Target, decodeTo type: T.Type) async throws -> T {
            return try await withCheckedThrowingContinuation { continuation in
                // async/await API의 일부로, 비동기 작업을 동기식으로 변환할 때 사용됩니다. 여기서 continuation은 비동기 작업이 완료되면 값을 반환하거나 오류를 던지기 위해 사용
                let provider = MoyaProvider<Target>(plugins: [MoyaLoggingPlugin()])
                var cancellable: AnyCancellable?
                cancellable = provider.requestPublisher(target)
                    .tryMap { response -> Data in
                        guard let httpResponse = response.response else {
                            throw DataError.noData
                        }
                        switch httpResponse.statusCode {
                        case 200:
                            return response.data
                        case 400:
                            throw DataError.badRequest
                        case 404:
                            throw DataError.errorData(response.data.description)
                        default:
                            throw DataError.unhandledStatusCode(httpResponse.statusCode)
                        }
                    }
                    .tryCompactMap { data in
                        try data.decoded(as: T.self)
                    }
                    .mapError { error in
                        if let moyaError = error as? MoyaError {
                            return DataError.moyaError(moyaError)
                        } else if let decodingError = error as? DecodingError {
                            return DataError.decodingError(decodingError)
                        } else if let dataError = error as? DataError {
                            return dataError
                        } else {
                            return DataError.unknownError
                        }
                    }
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                            cancellable?.cancel()
                            Log.error("네트워크 에러", error)
                        }
                    }, receiveValue: { decodedObject in
                        continuation.resume(returning: decodedObject)
                        Log.network("\(type) 데이터 통신", decodedObject)
                    })
            }
        }
    
    //MARK: - MoyaProvider에 요청을 AsyncThrowingStream 비동기적으로 처리하는 확장 함수 추가
    public func requestAsyncThrowingStream<T: Decodable>(
        _ target: Target,
        decodeTo type: T.Type
    ) -> AsyncThrowingStream<T, Error> {
        // 퍼블리셔를 미리 준비합니다.
        let publisher = self.requestWithProgressPublisher(target)
            .compactMap { $0.response?.data }
            .tryCompactMap { data in
                try data.decoded(as: T.self)
            }
            .mapError {
                DataError.error($0)
            }
            .eraseToAnyPublisher()

        // AsyncThrowingStream을 생성하고 반환합니다.
        return AsyncThrowingStream { continuation in
            nonisolated(unsafe) var cancellable: AnyCancellable?

            cancellable = publisher.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        continuation.finish()
                    case .failure(let error):
                        continuation.finish(throwing: error)
                    }
                },
                receiveValue: { decodedObject in
                    continuation.yield(decodedObject)
                    Log.network("\(type) 데이터 통신", decodedObject)
                }
            )

            continuation.onTermination = { @Sendable (async) in
                cancellable?.cancel()
            }
        }
    }
    
    //MARK: - MoyaProvider에 요청을 AsyncStream 비동기적으로 처리하는 확장 함수 추가
      public func requestAsyncStream<T: Decodable>(
        _ target: Target,
        decodeTo type: T.Type) -> AsyncStream<Result<T, Error>> {
        // 퍼블리셔를 미리 준비합니다.
        let publisher = self.requestWithProgressPublisher(target)
            .compactMap { $0.response?.data }
            .tryCompactMap { data in
                try data.decoded(as: T.self)
            }
            .mapError {
                DataError.error($0)
            }
            .eraseToAnyPublisher()

        // AsyncStream을 생성하고 반환합니다.
        return AsyncStream { continuation in
            nonisolated(unsafe) var cancellable: AnyCancellable?

            cancellable = publisher.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        continuation.finish()
                    case .failure(let error):
                        continuation.yield(.failure(error))
                        continuation.finish()
                    }
                },
                receiveValue: { decodedObject in
                    continuation.yield(.success(decodedObject))
                    Log.network("\(type) 데이터 통신", decodedObject)
                }
            )

            continuation.onTermination = { @Sendable (async) in
                cancellable?.cancel()
            }
        }
    }

}
