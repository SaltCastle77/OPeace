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
            var cancellable: AnyCancellable?
            cancellable = self.requestPublisher(target)
                .tryMap { response -> Data in
                    guard let httpResponse = response.response else {
                        throw DataError.noData
                    }
                    switch httpResponse.statusCode {
                    case 200, 201, 204, 401:
                        return response.data
                    case 400:
                        throw MoyaError.statusCode(response)
                    case 404:
                        let errorResponse = try response.data.decoded(as: ErrorResponse.self)
                        throw DataError.customError(errorResponse)
                    default:
                        throw DataError.unhandledStatusCode(httpResponse.statusCode)
                    }
                }
                .tryCompactMap { data in
                    if data.isEmpty {
                        if T.self == Void.self {
                            return () as? T
                        } else if let optionalType = T.self as? ExpressibleByNilLiteral.Type {
                            return optionalType.init(nilLiteral: ()) as? T
                        }
                    }
                    return try data.decoded(as: T.self)
                }
                .mapError { error -> MoyaError in
                    if let moyaError = error as? MoyaError {
                        Log.error("MoyaError occurred: \(moyaError.localizedDescription)")
                        if case .statusCode(let response) = moyaError, response.statusCode == 400{
                            Log.error("400 토큰 인증실패: triggering retry logic")
                            return moyaError
                        }
                        return moyaError
                    } else if let decodingError = error as? DecodingError {
                        Log.error("DecodingError occurred: \(decodingError.localizedDescription)")
                        return MoyaError.underlying(decodingError, nil)
                    } else if let dataError = error as? DataError {
                        Log.error("DataError occurred: \(dataError.localizedDescription)")
                        return MoyaError.underlying(dataError, nil)
                    } else {
                        let unknownError = NSError(domain: "Unknown Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred."])
                        Log.error("Unknown error occurred")
                        return MoyaError.underlying(unknownError, nil)
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
        let provider = MoyaProvider<Target>(plugins: [MoyaLoggingPlugin()])
        let publisher = provider.requestPublisher(target)
            .tryMap { response -> Data in
                guard let httpResponse = response.response else {
                    throw DataError.noData
                }
                switch httpResponse.statusCode {
                case 200, 201, 204, 401:
                    return response.data
                case 400:
                    throw DataError.badRequest
                case 404:
                    let errorResponse = try response.data.decoded(as: ErrorResponse.self)
                    throw DataError.customError(errorResponse)
                default:
                    throw DataError.unhandledStatusCode(httpResponse.statusCode)
                }
            }
            .tryCompactMap { data in
                if data.isEmpty {
                    if T.self == Void.self {
                        return () as? T
                    } else if let optionalType = T.self as? ExpressibleByNilLiteral.Type {
                        return optionalType.init(nilLiteral: ()) as? T
                    }
                }
                return try data.decoded(as: T.self)
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
            let provider = MoyaProvider<Target>(plugins: [MoyaLoggingPlugin()])
            let publisher = provider.requestPublisher(target)
                .tryMap { response -> Data in
                    guard let httpResponse = response.response else {
                        throw DataError.noData
                    }
                    switch httpResponse.statusCode {
                    case 200, 201, 204, 401:
                        return response.data
                    case 400:
                        throw DataError.badRequest
                    case 404:
                        let errorResponse = try response.data.decoded(as: ErrorResponse.self)
                        throw DataError.customError(errorResponse)
                    default:
                        throw DataError.unhandledStatusCode(httpResponse.statusCode)
                    }
                }
                .tryCompactMap { data in
                    if data.isEmpty {
                        if T.self == Void.self {
                            return () as? T
                        } else if let optionalType = T.self as? ExpressibleByNilLiteral.Type {
                            return optionalType.init(nilLiteral: ()) as? T
                        }
                    }
                    return try data.decoded(as: T.self)
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



