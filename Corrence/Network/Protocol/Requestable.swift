//
//  Resource.swift
//  Corrence
//
//  Created by hikinit on 06/09/20.
//

import Foundation

protocol Requestable {
  associatedtype ResponseType

  var url: URL { get }
  func parse(_ data: Data) -> Result<ResponseType, Error>
}
