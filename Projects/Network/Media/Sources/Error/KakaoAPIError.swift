//
//  KakaoAPIError.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/9/24.
//

import Foundation

public enum KakaoAPIError: LocalizedError {
    case pageOverflow
    case badRequest
    case unknowned(Error)
}
