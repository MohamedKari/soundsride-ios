// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: soundsride_service.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

public struct StartSessionResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var sessionID: Int32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct UpdateTransitionSpecRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var sessionID: Int32 = 0

  public var initialGenre: String = String()

  public var transitions: [Transition] = []

  public var currentLatitude: Double = 0

  public var currentLongitude: Double = 0

  public var currentAltitude: Double = 0

  public var nextUp: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct Transition {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var transitionID: String = String()

  public var transitionToGenre: String = String()

  public var estimatedTimeToTransition: Float = 0

  public var estimatedGeoDistanceToTransition: Float = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct AudioChunkResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var firstFrameID: Int32 = 0

  public var audioChunk: Data = Data()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct Position {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var latitude: Float = 0

  public var longitude: Float = 0

  public var altitude: Float = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct Empty {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension StartSessionResponse: @unchecked Sendable {}
extension UpdateTransitionSpecRequest: @unchecked Sendable {}
extension Transition: @unchecked Sendable {}
extension AudioChunkResponse: @unchecked Sendable {}
extension Position: @unchecked Sendable {}
extension Empty: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension StartSessionResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "StartSessionResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "session_id"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt32Field(value: &self.sessionID) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.sessionID != 0 {
      try visitor.visitSingularInt32Field(value: self.sessionID, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: StartSessionResponse, rhs: StartSessionResponse) -> Bool {
    if lhs.sessionID != rhs.sessionID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension UpdateTransitionSpecRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "UpdateTransitionSpecRequest"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "session_id"),
    2: .standard(proto: "initial_genre"),
    3: .same(proto: "transitions"),
    4: .standard(proto: "current_latitude"),
    5: .standard(proto: "current_longitude"),
    6: .standard(proto: "current_altitude"),
    7: .standard(proto: "next_up"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt32Field(value: &self.sessionID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.initialGenre) }()
      case 3: try { try decoder.decodeRepeatedMessageField(value: &self.transitions) }()
      case 4: try { try decoder.decodeSingularDoubleField(value: &self.currentLatitude) }()
      case 5: try { try decoder.decodeSingularDoubleField(value: &self.currentLongitude) }()
      case 6: try { try decoder.decodeSingularDoubleField(value: &self.currentAltitude) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.nextUp) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.sessionID != 0 {
      try visitor.visitSingularInt32Field(value: self.sessionID, fieldNumber: 1)
    }
    if !self.initialGenre.isEmpty {
      try visitor.visitSingularStringField(value: self.initialGenre, fieldNumber: 2)
    }
    if !self.transitions.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.transitions, fieldNumber: 3)
    }
    if self.currentLatitude != 0 {
      try visitor.visitSingularDoubleField(value: self.currentLatitude, fieldNumber: 4)
    }
    if self.currentLongitude != 0 {
      try visitor.visitSingularDoubleField(value: self.currentLongitude, fieldNumber: 5)
    }
    if self.currentAltitude != 0 {
      try visitor.visitSingularDoubleField(value: self.currentAltitude, fieldNumber: 6)
    }
    if !self.nextUp.isEmpty {
      try visitor.visitSingularStringField(value: self.nextUp, fieldNumber: 7)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: UpdateTransitionSpecRequest, rhs: UpdateTransitionSpecRequest) -> Bool {
    if lhs.sessionID != rhs.sessionID {return false}
    if lhs.initialGenre != rhs.initialGenre {return false}
    if lhs.transitions != rhs.transitions {return false}
    if lhs.currentLatitude != rhs.currentLatitude {return false}
    if lhs.currentLongitude != rhs.currentLongitude {return false}
    if lhs.currentAltitude != rhs.currentAltitude {return false}
    if lhs.nextUp != rhs.nextUp {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Transition: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "Transition"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "transitionId"),
    2: .standard(proto: "transition_to_genre"),
    3: .standard(proto: "estimated_time_to_transition"),
    4: .standard(proto: "estimated_geo_distance_to_transition"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.transitionID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.transitionToGenre) }()
      case 3: try { try decoder.decodeSingularFloatField(value: &self.estimatedTimeToTransition) }()
      case 4: try { try decoder.decodeSingularFloatField(value: &self.estimatedGeoDistanceToTransition) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.transitionID.isEmpty {
      try visitor.visitSingularStringField(value: self.transitionID, fieldNumber: 1)
    }
    if !self.transitionToGenre.isEmpty {
      try visitor.visitSingularStringField(value: self.transitionToGenre, fieldNumber: 2)
    }
    if self.estimatedTimeToTransition != 0 {
      try visitor.visitSingularFloatField(value: self.estimatedTimeToTransition, fieldNumber: 3)
    }
    if self.estimatedGeoDistanceToTransition != 0 {
      try visitor.visitSingularFloatField(value: self.estimatedGeoDistanceToTransition, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Transition, rhs: Transition) -> Bool {
    if lhs.transitionID != rhs.transitionID {return false}
    if lhs.transitionToGenre != rhs.transitionToGenre {return false}
    if lhs.estimatedTimeToTransition != rhs.estimatedTimeToTransition {return false}
    if lhs.estimatedGeoDistanceToTransition != rhs.estimatedGeoDistanceToTransition {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension AudioChunkResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "AudioChunkResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "first_frame_id"),
    2: .standard(proto: "audio_chunk"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt32Field(value: &self.firstFrameID) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.audioChunk) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.firstFrameID != 0 {
      try visitor.visitSingularInt32Field(value: self.firstFrameID, fieldNumber: 1)
    }
    if !self.audioChunk.isEmpty {
      try visitor.visitSingularBytesField(value: self.audioChunk, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: AudioChunkResponse, rhs: AudioChunkResponse) -> Bool {
    if lhs.firstFrameID != rhs.firstFrameID {return false}
    if lhs.audioChunk != rhs.audioChunk {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Position: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "Position"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "latitude"),
    2: .same(proto: "longitude"),
    3: .same(proto: "altitude"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularFloatField(value: &self.latitude) }()
      case 2: try { try decoder.decodeSingularFloatField(value: &self.longitude) }()
      case 3: try { try decoder.decodeSingularFloatField(value: &self.altitude) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.latitude != 0 {
      try visitor.visitSingularFloatField(value: self.latitude, fieldNumber: 1)
    }
    if self.longitude != 0 {
      try visitor.visitSingularFloatField(value: self.longitude, fieldNumber: 2)
    }
    if self.altitude != 0 {
      try visitor.visitSingularFloatField(value: self.altitude, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Position, rhs: Position) -> Bool {
    if lhs.latitude != rhs.latitude {return false}
    if lhs.longitude != rhs.longitude {return false}
    if lhs.altitude != rhs.altitude {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Empty: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "Empty"
  public static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Empty, rhs: Empty) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}