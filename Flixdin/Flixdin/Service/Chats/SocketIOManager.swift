//
//  SocketIOManager.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 22/05/2024.
//

import Foundation
import SocketIO
import SwiftUI

class SocketIOManager: ObservableObject {
    @Published var isConntected = false

    private var manager: SocketManager!
    private var socket: SocketIOClient!

    init() {
        guard let url = URL(string: Constants.shared.socketsURL) else {
            return
        }

        manager = SocketManager(socketURL: url, config: [.log(false), .compress, .forceWebsockets(true)])
        socket = manager.defaultSocket
    }

    func connect() {
        socket.on(clientEvent: .connect) { _, _ in
            print("socket status: connected")
            self.isConntected = true
        }

        socket.on("message") { [weak self] data, _ in

            guard let self = self,
                  let message = data[0] as? String else {
                return
            }

            print("socket message received \(message)")
        }

        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
        isConntected = false
    }

    func joinRoom(senderId: String, receiverId: String) {
        socket.emit("join", ["senderId": senderId, "receiverId": receiverId])
    }

    func leaveRoom(senderId: String, receiverId: String) {
        socket.emit("leave", ["senderId": senderId, "receiverId": receiverId])
    }

    func sendMessage(senderId: String, receiverId: String, message: String) {
        socket.emit("message", ["senderId": senderId, "receiverId": receiverId, "message": message])
    }
}
