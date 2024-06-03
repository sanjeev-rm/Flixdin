//
//  SocketIOManager.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 22/05/2024.
//

import Foundation
import SocketIO
import SwiftUI

/*
class SocketIOManager: ObservableObject {
    @Published var isConntected = false

    private var manager: SocketManager!
    private var socket: SocketIOClient!

    init() {
        manager = SocketManager(socketURL: URL(string: "wss://api.flixdin.com")!, config: [.log(true), .compress, .reconnects(true), .secure(true), .forceWebsockets(true)])

        socket = manager.defaultSocket
    }

    func connect() {
        socket.on(clientEvent: .connect) { _, _ in
            print("socket status: connected")
            self.isConntected = true
        }

        print("connect status: \(socket.status)")

        socket.on("message") { [weak self] data, _ in

            guard let _ = self,
                  let message = data[0] as? String else {
                return
            }

            print("socket message received \(message)")
        }

        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
        print("socket status: disconnected")
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
*/



class SocketIOManager: ObservableObject {
    @Published var messages: [ChatMessage] = []
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    @Published var isConnected: Bool = false

    init() {
        manager = SocketManager(socketURL: URL(string: "wss://api.flixdin.com")!, config: [.log(true), .compress, .reconnects(true), .secure(true), .forceWebsockets(true)])
        socket = manager.defaultSocket
        setupListeners()
    }

    func setupListeners() {
        socket.on(clientEvent: .connect) { [weak self] _, _ in
            print("Socket connected")
            self?.isConnected = true
        }

        socket.on("new_message") { [weak self] data, _ in
            guard let self = self,
                  let messageData = data[0] as? [String: Any],
                  let message = ChatMessage(data: messageData) else {
                return
            }
            DispatchQueue.main.async {
                self.messages.append(message)
            }
        }

        socket.on(clientEvent: .disconnect) { _, _ in
            print("Socket disconnected")
        }
    }


    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
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

