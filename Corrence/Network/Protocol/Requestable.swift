//
//  Resource.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

protocol Requestable {
  associatedtype ResponseType
  typealias ResponseResult = Result<ResponseType, Error>

  var url: URL { get }
  func parse(_ data: Data) -> ResponseResult
  func load(completion: @escaping (ResponseResult) -> Void)
}

enum RequestableError: Error {
  case emptyData
  case invalidResponse
  case unknownError
  case clientError
  case serverError
}

extension RequestableError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .emptyData:
      return NSLocalizedString("The server returns empty data", comment: "Empty Data")
    case .invalidResponse:
      return NSLocalizedString("The server returns an invalid response", comment: "Invalid Response")
    case .unknownError:
      return NSLocalizedString("Unknown Error", comment: "Unknown Error")
    case .clientError:
      return NSLocalizedString("The server cannot handle your request", comment: "Client Error")
    case .serverError:
      return NSLocalizedString("The server has encountered a problem", comment: "Server Error")
    }
  }
}

extension Requestable {
  func verify(response: HTTPURLResponse, data: Data?) -> ResponseResult {
    switch response.statusCode {
    case 200...299:
      if let data = data {
        return parse(data)
      }
      return .failure(RequestableError.emptyData)
    case 400...499:
      return .failure(RequestableError.clientError)
    case 500...599:
      return .failure(RequestableError.serverError)
    default:
      return .failure(RequestableError.unknownError)
    }
  }

  func load(completion: @escaping (ResponseResult) -> Void) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, response, error in
      guard let response = response as? HTTPURLResponse else {
        completion(.failure(RequestableError.invalidResponse))
        return
      }

      let result = verify(response: response, data: data)
      switch result {
      case .success(let parsedData):
        completion(.success(parsedData))
      case .failure(let error):
        completion(.failure(error))
      }
    }

    task.resume()
  }
}
