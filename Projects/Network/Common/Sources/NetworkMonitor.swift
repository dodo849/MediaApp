//
//  NetworkMonitor.swift
//  CommonNetwork
//
//  Created by DOYEON LEE on 7/8/24.
//

import Foundation
import Network
import SwiftUI

public class NetworkMonitor: ObservableObject {
    public let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    @Published public var isConnected: Bool = false
    
    public init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}

// MARK: - Preview
struct NetworkMonitorView: View {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        VStack {
            if networkMonitor.isConnected {
                Text("Connected to the Internet")
                    .foregroundColor(.green)
            } else {
                Text("No Internet Connection")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            networkMonitor.isConnected = networkMonitor.monitor.currentPath.status == .satisfied
        }
    }
}

#Preview {
    NetworkMonitorView()
}
