//
//  File.swift
//  
//
//  Created by Moritz Schüll on 18.11.20.
//

import Foundation


enum ProtobufDecoderError: Error {
    case unknownTypeError(_ fieldType: Int)
    case decodingError(_ reason: String)
    case unsupportedDataType(_ message: String)
    case unsupportedDecodingStrategy(_ message: String)
}
