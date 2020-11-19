//
//  KeyedProtoDecodingContainer.swift
//  
//
//  Created by Moritz Schüll on 19.11.20.
//

import Foundation


class KeyedProtobufDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    internal var codingPath: [CodingKey]
    internal var allKeys: [Key]

    let data: [Int: Data]

    init(data: [Int: Data]) {
        self.data = data
        allKeys = []
        codingPath = []
    }

    func contains(_ key: Key) -> Bool {
        return data.keys.contains(key.intValue!)
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        return false
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        if nil != data[key.intValue!] {
            return true
        }
        return false
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            return String(data: value, encoding: .utf8)!
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            return value.withUnsafeBytes({ (rawPtr: UnsafeRawBufferPointer) in
                return rawPtr.load(as: Double.self)
            })
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            return value.withUnsafeBytes({ (rawPtr: UnsafeRawBufferPointer) in
                return rawPtr.load(as: Float.self)
            })
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            return value.withUnsafeBytes({ (rawPtr: UnsafeRawBufferPointer) in
                return rawPtr.load(as: Int.self)
            })
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        throw ProtobufDecoderError.decodingError("Int8 not supported")
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        throw ProtobufDecoderError.decodingError("Int16 not supported")
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            var number: Int32 = 0
            for (index, byte) in value.enumerated() {
                number = (Int32(byte) << (index*8)) | number
            }
            return number
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            var number: Int64 = 0
            for (index, byte) in value.enumerated() {
                number = (Int64(byte) << (index*8)) | number
            }
            return number
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            return value.withUnsafeBytes({ (rawPtr: UnsafeRawBufferPointer) in
                return rawPtr.load(as: UInt.self)
            })
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        throw ProtobufDecoderError.decodingError("UInt8 not supported")
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        throw ProtobufDecoderError.decodingError("UInt16 not supported")
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            return value.withUnsafeBytes({ (rawPtr: UnsafeRawBufferPointer) in
                return rawPtr.load(as: UInt32.self)
            })
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            return value.withUnsafeBytes({ (rawPtr: UnsafeRawBufferPointer) in
                return rawPtr.load(as: UInt64.self)
            })
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        // we encountered a nested structure
        if let keyValue = key.intValue,
           let value = data[keyValue] {
            return try ProtobufDecoder().decode(T.self, from: value)
        }
        throw ProtobufDecoderError.decodingError("No data for given key")
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw ProtobufDecoderError.unsupportedDataType("Don't know what it is")
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw ProtobufDecoderError.unsupportedDataType("Don't know what it is")
    }

    func superDecoder() throws -> Decoder {
        throw ProtobufDecoderError.unsupportedDataType("Don't know what it is")
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        throw ProtobufDecoderError.unsupportedDataType("Don't know what it is")
    }
}
