//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: soundsride_service.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


/// Usage: instantiate `SoundsRideClient`, then call methods of this protocol to make API calls.
internal protocol SoundsRideClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: SoundsRideClientInterceptorFactoryProtocol? { get }

  func ping(
    _ request: Empty,
    callOptions: CallOptions?
  ) -> UnaryCall<Empty, Empty>

  func startSession(
    _ request: Empty,
    callOptions: CallOptions?
  ) -> UnaryCall<Empty, StartSessionResponse>

  func updateTransitionSpec(
    _ request: UpdateTransitionSpecRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<UpdateTransitionSpecRequest, Empty>

  func getChunk(
    _ request: Empty,
    callOptions: CallOptions?
  ) -> UnaryCall<Empty, AudioChunkResponse>

  func getPosition(
    _ request: Empty,
    callOptions: CallOptions?
  ) -> UnaryCall<Empty, Position>
}

extension SoundsRideClientProtocol {
  internal var serviceName: String {
    return "SoundsRide"
  }

  /// Unary call to Ping
  ///
  /// - Parameters:
  ///   - request: Request to send to Ping.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func ping(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Empty, Empty> {
    return self.makeUnaryCall(
      path: SoundsRideClientMetadata.Methods.ping.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePingInterceptors() ?? []
    )
  }

  /// Unary call to StartSession
  ///
  /// - Parameters:
  ///   - request: Request to send to StartSession.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func startSession(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Empty, StartSessionResponse> {
    return self.makeUnaryCall(
      path: SoundsRideClientMetadata.Methods.startSession.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStartSessionInterceptors() ?? []
    )
  }

  /// Unary call to UpdateTransitionSpec
  ///
  /// - Parameters:
  ///   - request: Request to send to UpdateTransitionSpec.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func updateTransitionSpec(
    _ request: UpdateTransitionSpecRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<UpdateTransitionSpecRequest, Empty> {
    return self.makeUnaryCall(
      path: SoundsRideClientMetadata.Methods.updateTransitionSpec.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdateTransitionSpecInterceptors() ?? []
    )
  }

  /// Unary call to GetChunk
  ///
  /// - Parameters:
  ///   - request: Request to send to GetChunk.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func getChunk(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Empty, AudioChunkResponse> {
    return self.makeUnaryCall(
      path: SoundsRideClientMetadata.Methods.getChunk.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetChunkInterceptors() ?? []
    )
  }

  /// Unary call to GetPosition
  ///
  /// - Parameters:
  ///   - request: Request to send to GetPosition.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func getPosition(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Empty, Position> {
    return self.makeUnaryCall(
      path: SoundsRideClientMetadata.Methods.getPosition.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetPositionInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension SoundsRideClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "SoundsRideNIOClient")
internal final class SoundsRideClient: SoundsRideClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: SoundsRideClientInterceptorFactoryProtocol?
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  internal var interceptors: SoundsRideClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the SoundsRide service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: SoundsRideClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

internal struct SoundsRideNIOClient: SoundsRideClientProtocol {
  internal var channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: SoundsRideClientInterceptorFactoryProtocol?

  /// Creates a client for the SoundsRide service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: SoundsRideClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
internal protocol SoundsRideAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: SoundsRideClientInterceptorFactoryProtocol? { get }

  func makePingCall(
    _ request: Empty,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Empty, Empty>

  func makeStartSessionCall(
    _ request: Empty,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Empty, StartSessionResponse>

  func makeUpdateTransitionSpecCall(
    _ request: UpdateTransitionSpecRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<UpdateTransitionSpecRequest, Empty>

  func makeGetChunkCall(
    _ request: Empty,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Empty, AudioChunkResponse>

  func makeGetPositionCall(
    _ request: Empty,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Empty, Position>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension SoundsRideAsyncClientProtocol {
  internal static var serviceDescriptor: GRPCServiceDescriptor {
    return SoundsRideClientMetadata.serviceDescriptor
  }

  internal var interceptors: SoundsRideClientInterceptorFactoryProtocol? {
    return nil
  }

  internal func makePingCall(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Empty, Empty> {
    return self.makeAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.ping.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePingInterceptors() ?? []
    )
  }

  internal func makeStartSessionCall(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Empty, StartSessionResponse> {
    return self.makeAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.startSession.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStartSessionInterceptors() ?? []
    )
  }

  internal func makeUpdateTransitionSpecCall(
    _ request: UpdateTransitionSpecRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<UpdateTransitionSpecRequest, Empty> {
    return self.makeAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.updateTransitionSpec.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdateTransitionSpecInterceptors() ?? []
    )
  }

  internal func makeGetChunkCall(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Empty, AudioChunkResponse> {
    return self.makeAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.getChunk.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetChunkInterceptors() ?? []
    )
  }

  internal func makeGetPositionCall(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Empty, Position> {
    return self.makeAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.getPosition.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetPositionInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension SoundsRideAsyncClientProtocol {
  internal func ping(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) async throws -> Empty {
    return try await self.performAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.ping.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePingInterceptors() ?? []
    )
  }

  internal func startSession(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) async throws -> StartSessionResponse {
    return try await self.performAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.startSession.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStartSessionInterceptors() ?? []
    )
  }

  internal func updateTransitionSpec(
    _ request: UpdateTransitionSpecRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Empty {
    return try await self.performAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.updateTransitionSpec.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdateTransitionSpecInterceptors() ?? []
    )
  }

  internal func getChunk(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) async throws -> AudioChunkResponse {
    return try await self.performAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.getChunk.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetChunkInterceptors() ?? []
    )
  }

  internal func getPosition(
    _ request: Empty,
    callOptions: CallOptions? = nil
  ) async throws -> Position {
    return try await self.performAsyncUnaryCall(
      path: SoundsRideClientMetadata.Methods.getPosition.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetPositionInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
internal struct SoundsRideAsyncClient: SoundsRideAsyncClientProtocol {
  internal var channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: SoundsRideClientInterceptorFactoryProtocol?

  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: SoundsRideClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

internal protocol SoundsRideClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'ping'.
  func makePingInterceptors() -> [ClientInterceptor<Empty, Empty>]

  /// - Returns: Interceptors to use when invoking 'startSession'.
  func makeStartSessionInterceptors() -> [ClientInterceptor<Empty, StartSessionResponse>]

  /// - Returns: Interceptors to use when invoking 'updateTransitionSpec'.
  func makeUpdateTransitionSpecInterceptors() -> [ClientInterceptor<UpdateTransitionSpecRequest, Empty>]

  /// - Returns: Interceptors to use when invoking 'getChunk'.
  func makeGetChunkInterceptors() -> [ClientInterceptor<Empty, AudioChunkResponse>]

  /// - Returns: Interceptors to use when invoking 'getPosition'.
  func makeGetPositionInterceptors() -> [ClientInterceptor<Empty, Position>]
}

internal enum SoundsRideClientMetadata {
  internal static let serviceDescriptor = GRPCServiceDescriptor(
    name: "SoundsRide",
    fullName: "SoundsRide",
    methods: [
      SoundsRideClientMetadata.Methods.ping,
      SoundsRideClientMetadata.Methods.startSession,
      SoundsRideClientMetadata.Methods.updateTransitionSpec,
      SoundsRideClientMetadata.Methods.getChunk,
      SoundsRideClientMetadata.Methods.getPosition,
    ]
  )

  internal enum Methods {
    internal static let ping = GRPCMethodDescriptor(
      name: "Ping",
      path: "/SoundsRide/Ping",
      type: GRPCCallType.unary
    )

    internal static let startSession = GRPCMethodDescriptor(
      name: "StartSession",
      path: "/SoundsRide/StartSession",
      type: GRPCCallType.unary
    )

    internal static let updateTransitionSpec = GRPCMethodDescriptor(
      name: "UpdateTransitionSpec",
      path: "/SoundsRide/UpdateTransitionSpec",
      type: GRPCCallType.unary
    )

    internal static let getChunk = GRPCMethodDescriptor(
      name: "GetChunk",
      path: "/SoundsRide/GetChunk",
      type: GRPCCallType.unary
    )

    internal static let getPosition = GRPCMethodDescriptor(
      name: "GetPosition",
      path: "/SoundsRide/GetPosition",
      type: GRPCCallType.unary
    )
  }
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol SoundsRideProvider: CallHandlerProvider {
  var interceptors: SoundsRideServerInterceptorFactoryProtocol? { get }

  func ping(request: Empty, context: StatusOnlyCallContext) -> EventLoopFuture<Empty>

  func startSession(request: Empty, context: StatusOnlyCallContext) -> EventLoopFuture<StartSessionResponse>

  func updateTransitionSpec(request: UpdateTransitionSpecRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Empty>

  func getChunk(request: Empty, context: StatusOnlyCallContext) -> EventLoopFuture<AudioChunkResponse>

  func getPosition(request: Empty, context: StatusOnlyCallContext) -> EventLoopFuture<Position>
}

extension SoundsRideProvider {
  internal var serviceName: Substring {
    return SoundsRideServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Ping":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Empty>(),
        responseSerializer: ProtobufSerializer<Empty>(),
        interceptors: self.interceptors?.makePingInterceptors() ?? [],
        userFunction: self.ping(request:context:)
      )

    case "StartSession":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Empty>(),
        responseSerializer: ProtobufSerializer<StartSessionResponse>(),
        interceptors: self.interceptors?.makeStartSessionInterceptors() ?? [],
        userFunction: self.startSession(request:context:)
      )

    case "UpdateTransitionSpec":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<UpdateTransitionSpecRequest>(),
        responseSerializer: ProtobufSerializer<Empty>(),
        interceptors: self.interceptors?.makeUpdateTransitionSpecInterceptors() ?? [],
        userFunction: self.updateTransitionSpec(request:context:)
      )

    case "GetChunk":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Empty>(),
        responseSerializer: ProtobufSerializer<AudioChunkResponse>(),
        interceptors: self.interceptors?.makeGetChunkInterceptors() ?? [],
        userFunction: self.getChunk(request:context:)
      )

    case "GetPosition":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Empty>(),
        responseSerializer: ProtobufSerializer<Position>(),
        interceptors: self.interceptors?.makeGetPositionInterceptors() ?? [],
        userFunction: self.getPosition(request:context:)
      )

    default:
      return nil
    }
  }
}

/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
internal protocol SoundsRideAsyncProvider: CallHandlerProvider, Sendable {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: SoundsRideServerInterceptorFactoryProtocol? { get }

  func ping(
    request: Empty,
    context: GRPCAsyncServerCallContext
  ) async throws -> Empty

  func startSession(
    request: Empty,
    context: GRPCAsyncServerCallContext
  ) async throws -> StartSessionResponse

  func updateTransitionSpec(
    request: UpdateTransitionSpecRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Empty

  func getChunk(
    request: Empty,
    context: GRPCAsyncServerCallContext
  ) async throws -> AudioChunkResponse

  func getPosition(
    request: Empty,
    context: GRPCAsyncServerCallContext
  ) async throws -> Position
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension SoundsRideAsyncProvider {
  internal static var serviceDescriptor: GRPCServiceDescriptor {
    return SoundsRideServerMetadata.serviceDescriptor
  }

  internal var serviceName: Substring {
    return SoundsRideServerMetadata.serviceDescriptor.fullName[...]
  }

  internal var interceptors: SoundsRideServerInterceptorFactoryProtocol? {
    return nil
  }

  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Ping":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Empty>(),
        responseSerializer: ProtobufSerializer<Empty>(),
        interceptors: self.interceptors?.makePingInterceptors() ?? [],
        wrapping: { try await self.ping(request: $0, context: $1) }
      )

    case "StartSession":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Empty>(),
        responseSerializer: ProtobufSerializer<StartSessionResponse>(),
        interceptors: self.interceptors?.makeStartSessionInterceptors() ?? [],
        wrapping: { try await self.startSession(request: $0, context: $1) }
      )

    case "UpdateTransitionSpec":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<UpdateTransitionSpecRequest>(),
        responseSerializer: ProtobufSerializer<Empty>(),
        interceptors: self.interceptors?.makeUpdateTransitionSpecInterceptors() ?? [],
        wrapping: { try await self.updateTransitionSpec(request: $0, context: $1) }
      )

    case "GetChunk":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Empty>(),
        responseSerializer: ProtobufSerializer<AudioChunkResponse>(),
        interceptors: self.interceptors?.makeGetChunkInterceptors() ?? [],
        wrapping: { try await self.getChunk(request: $0, context: $1) }
      )

    case "GetPosition":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Empty>(),
        responseSerializer: ProtobufSerializer<Position>(),
        interceptors: self.interceptors?.makeGetPositionInterceptors() ?? [],
        wrapping: { try await self.getPosition(request: $0, context: $1) }
      )

    default:
      return nil
    }
  }
}

internal protocol SoundsRideServerInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when handling 'ping'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makePingInterceptors() -> [ServerInterceptor<Empty, Empty>]

  /// - Returns: Interceptors to use when handling 'startSession'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeStartSessionInterceptors() -> [ServerInterceptor<Empty, StartSessionResponse>]

  /// - Returns: Interceptors to use when handling 'updateTransitionSpec'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeUpdateTransitionSpecInterceptors() -> [ServerInterceptor<UpdateTransitionSpecRequest, Empty>]

  /// - Returns: Interceptors to use when handling 'getChunk'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGetChunkInterceptors() -> [ServerInterceptor<Empty, AudioChunkResponse>]

  /// - Returns: Interceptors to use when handling 'getPosition'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGetPositionInterceptors() -> [ServerInterceptor<Empty, Position>]
}

internal enum SoundsRideServerMetadata {
  internal static let serviceDescriptor = GRPCServiceDescriptor(
    name: "SoundsRide",
    fullName: "SoundsRide",
    methods: [
      SoundsRideServerMetadata.Methods.ping,
      SoundsRideServerMetadata.Methods.startSession,
      SoundsRideServerMetadata.Methods.updateTransitionSpec,
      SoundsRideServerMetadata.Methods.getChunk,
      SoundsRideServerMetadata.Methods.getPosition,
    ]
  )

  internal enum Methods {
    internal static let ping = GRPCMethodDescriptor(
      name: "Ping",
      path: "/SoundsRide/Ping",
      type: GRPCCallType.unary
    )

    internal static let startSession = GRPCMethodDescriptor(
      name: "StartSession",
      path: "/SoundsRide/StartSession",
      type: GRPCCallType.unary
    )

    internal static let updateTransitionSpec = GRPCMethodDescriptor(
      name: "UpdateTransitionSpec",
      path: "/SoundsRide/UpdateTransitionSpec",
      type: GRPCCallType.unary
    )

    internal static let getChunk = GRPCMethodDescriptor(
      name: "GetChunk",
      path: "/SoundsRide/GetChunk",
      type: GRPCCallType.unary
    )

    internal static let getPosition = GRPCMethodDescriptor(
      name: "GetPosition",
      path: "/SoundsRide/GetPosition",
      type: GRPCCallType.unary
    )
  }
}
