//
//  SocketManager.swift
//  PCrypto
//
//  Created by Ram Sharma on 16/03/22.
//

import Foundation
import SocketIO

class SocketService {
    private let maxSocketConnections = 15
    private var currentSocketConnections = 0
    static let shared = SocketService()
    private var configOptions: SocketIOClientConfiguration = [.log(true), .forceWebsockets(true), .forceNew(true), .reconnects(true), .reconnectAttempts(10)]
    private let manager = SocketManager(socketURL: URL(string: Constants.BASE_SOCKET_URL)!)
    private var events = [String]()
    
    private var socketInstance: SocketIOClient?
    
    private init() {
        self.manager.config = self.configOptions
        self.configureSocket()
    }
    
    private func configureSocket() {
        self.socketInstance = manager.defaultSocket
    }
    
    func connect(completion:(() -> Void)?) {
        observeSocketConnections(completion)
        socketInstance?.connect()
    }
    
    private func observeSocketConnections(_ completion:(() -> Void)?) {
        socketInstance?.on(clientEvent: .connect) { (_, _) in
            print("socket connection on")
            completion?()
        }
        socketInstance?.on(clientEvent: .disconnect, callback: { _, _ in
            print("socket connection off")
        })
        socketInstance?.on(clientEvent: .error) { (data, ack) in
            if let errorStr: String = (data[0] as? String) {
                print("socket connection error: \(errorStr)")
            }
        }
    }
    
    func disconnectSocket() {
        socketInstance?.disconnect()
    }
    
    func stopAllSubscribers() {
        for subId in events{
            stopListening(name: subId)
            emit(subscriberType: .unsubscibe, subId: subId)
        }
        events.removeAll()
    }
    
    var isConnected: Bool {
        if socketInstance?.status == .connected {
            return true
        }
        return false
    }
    
    func emit(subscriberType: SubscriberTypes, subId: String) {
        if allowListener(subscriberType, subId) {
            socketInstance?.emit(subscriberType.name, ["topics": [subId]])
        }
    }
    
    private func allowListener(_ subscriberType: SubscriberTypes, _ subId: String) -> Bool {
        if subscriberType == .subscribe {
            if currentSocketConnections < maxSocketConnections {
                currentSocketConnections += 1
                events.append(subId)
            } else {
                print("maximum scoket connections limit reached")
                return false
            }
        } else if subscriberType == .unsubscibe {
            currentSocketConnections -= 1
            if let item = events.firstIndex(of: subId) {
                events.remove(at: item)
            }
        }
        return true
    }
    
    func startListening(name: String, completion: @escaping ([Any]) -> Void) {
        socketInstance?.on(name) { (response, _ ) in // response and emitter
            completion(response)
        }
    }
    
    func stopListening(name: String) {
        socketInstance?.off(name)
    }
}

enum SubscriberTypes {
    case subscribe
    case unsubscibe
    
    var name: String {
        switch(self) {
        case .subscribe:
            return "subscribe"
        case .unsubscibe:
            return "unsubscibe"
        }
    }
}
