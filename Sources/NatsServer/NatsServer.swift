// Copyright 2024 The NATS Authors
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import XCTest

public class NatsServer {
    public var port: Int? { return natsServerPort }
    public var clientURL: String {
        let scheme = tlsEnabled ? "tls://" : "nats://"
        if let natsServerPort {
            return "\(scheme)localhost:\(natsServerPort)"
        } else {
            return ""
        }
    }

    public var clientWebsocketURL: String {
        let scheme = tlsEnabled ? "wss://" : "ws://"
        if let natsWebsocketPort {
            return "\(scheme)localhost:\(natsWebsocketPort)"
        } else {
            return ""
        }
    }

    private var natsServerPort: Int?
    private var natsWebsocketPort: Int?
    private var tlsEnabled = false

    public init() {}

    // TODO: When implementing JetStream, creating and deleting store dir should be handled in start/stop methods
    public func start(
        port: Int = -1, cfg: String? = nil, file: StaticString = #file, line: UInt = #line
    ) {
        // Single implementation that does not spawn a process. Assumes an external nats-server.
        if port <= 0 {
            XCTFail("Provide a positive port to connect to an already-running nats-server.", file: file, line: line)
            return
        }
        self.natsServerPort = port
        // If you have a convention for websocket port, set it here. Otherwise, leave nil.
        // self.natsWebsocketPort = ...
        // Infer TLS from cfg if desired. Default to false.
        self.tlsEnabled = false
    }

    public func stop() {
        // No external process to stop. Clear state.
        self.natsServerPort = nil
        self.natsWebsocketPort = nil
        self.tlsEnabled = false
    }

    public func sendSignal(_ signal: Signal, file: StaticString = #file, line: UInt = #line) {
        // No spawned process to signal; no-op.
    }

    deinit {
        stop()
    }

    public enum Signal: String {
        case lameDuckMode = "ldm"
        case reload = "reload"
    }
}
