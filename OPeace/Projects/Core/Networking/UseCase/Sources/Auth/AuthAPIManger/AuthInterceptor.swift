//
//  AuthInterceptor.swift
//  UseCase
//
//  Created by 서원지 on 8/30/24.
//

import Alamofire
import Moya
import Foundation
import Utills
import API
import AsyncMoya

final class AuthInterceptor: RequestInterceptor {
  
  static let shared = AuthInterceptor()
  
  private init() {}
  
  // Request를 수정하여 토큰을 추가하는 메서드
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    guard urlRequest.url?.absoluteString.hasPrefix(BaseAPI.base.apiDesc) == true else {
      completion(.success(urlRequest))
      return
    }
    let accessToken = UserDefaults.standard.string(forKey: "ACCESS_TOKEN")
    var urlRequest = urlRequest
    urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
    #logDebug("Adapted request with headers: ", urlRequest.headers)
    completion(.success(urlRequest))
  }
  
  // 401 Unauthorized 응답 시 토큰 갱신 및 재시도 로직
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void) {
      Log.debug("Entered retry function")
      typealias Task = _Concurrency.Task
      // error의 상세 정보를 확인
      if let afError = error.asAFError, afError.isResponseValidationError {
        #logError("Response validation error detected.")
      } else {
        #logError("Error is not responseValidationFailed: \(error)")
      }
      
      // 401 상태 코드 확인
      guard let response = request.task?.response as? HTTPURLResponse else {
        #logDebug("Response is not an HTTPURLResponse.")
        completion(.doNotRetryWithError(error))
        return
      }
      
      Log.debug("HTTP Status Code: \(response.statusCode)")
      
      switch response.statusCode {
      case 400:
        #logDebug("400 Unauthorized detected, attempting to refresh token...")
        Task {
          let retryResult = await AuthAPIManger.shared.getRefeshToken()
          completion(retryResult)
        }
      default:
        #logDebug("Status code is not 401, not retrying.")
        completion(.doNotRetryWithError(error))
      }
    }
}
