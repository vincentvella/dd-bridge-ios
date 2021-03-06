/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation
import Datadog

extension Logger: NativeLogger { }
internal protocol NativeLogger {
    func debug(_ message: String, error: Error?, attributes: [String: Encodable]?)
    func info(_ message: String, error: Error?, attributes: [String: Encodable]?)
    func warn(_ message: String, error: Error?, attributes: [String: Encodable]?)
    func error(_ message: String, error: Error?, attributes: [String: Encodable]?)
}

public class DdLogsImplementation: DdLogs {
    private lazy var logger: NativeLogger = loggerProvider()
    private let loggerProvider: () -> NativeLogger

    internal init(_ loggerProvider: @escaping () -> NativeLogger) {
        self.loggerProvider = loggerProvider
    }

    public convenience init() {
        let builder = Logger.builder
            .sendNetworkInfo(true)
            .printLogsToConsole(true)
        self.init { builder.build() }
    }

    public func debug(message: NSString, context: NSDictionary) {
        let attributes = castAttributesToSwift(context).mergeWithGlobalAttributes()
        logger.debug(message as String, error: nil, attributes: attributes)
    }

    public func info(message: NSString, context: NSDictionary) {
        let attributes = castAttributesToSwift(context).mergeWithGlobalAttributes()
        logger.info(message as String, error: nil, attributes: attributes)
    }

    public func warn(message: NSString, context: NSDictionary) {
        let attributes = castAttributesToSwift(context).mergeWithGlobalAttributes()
        logger.warn(message as String, error: nil, attributes: attributes)
    }

    public func error(message: NSString, context: NSDictionary) {
        let attributes = castAttributesToSwift(context).mergeWithGlobalAttributes()
        logger.error(message as String, error: nil, attributes: attributes)
    }
}
