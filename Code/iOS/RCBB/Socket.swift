//
//  Socket.swift
//  RCBB
//
//  Created by Michal Szmaj on 2017-03-08.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import Foundation
import UIKit

class Socket: NSObject, StreamDelegate {
    //Public variables
    var delegate: ConnectionDelegate?
    var host: String { get { return _host } set { _host = newValue } }
    var port: Int { get { return _port } set { _port = newValue } }
    var socketError: String?
    var connected: Bool {
        get {
            if _inputStream == nil || _outputStream == nil {
                return false
            }
            else {
                return true
            }
        }
    }
    
    //Private variables
    private var _host: String
    private var _port: Int
    private var _inputStream: InputStream?
    private var _outputStream: OutputStream?
    private var _buffer = [UInt8](repeating: 0, count: 512)
    
    //Initialiser
    init (withHost h: String, withPort p: Int, withDelegate delegate: ConnectionDelegate) {
        _host = h
        _port = p
        self.delegate = delegate
    }
    
    //Public methods
    
    /**
     Connects to the host and opens the input/output streams.
     Allows reconnection: if streams are not nil, disconnects and then reconnects.
     Returns 0 for sucessful connection, 1 for unsuccessful
    */
    func ConnectToHost () -> Int {
        if _inputStream != nil || _outputStream != nil {
            DisconnectFromHost()
            _inputStream = nil
            _outputStream = nil
        }
        Stream.getStreamsToHost(withName: _host, port: _port, inputStream: &_inputStream, outputStream: &_outputStream)
        if _inputStream != nil && _outputStream != nil {
            _inputStream?.delegate = self
            _outputStream?.delegate = self
            _inputStream?.schedule(in: .main, forMode: .defaultRunLoopMode)
            _outputStream?.schedule(in: .main, forMode: .defaultRunLoopMode)
            _inputStream!.open()
            _outputStream!.open()
            return 0
        }
        return 1
    }
    
    /**
     Closes both input and output streams
    */
    func DisconnectFromHost () {
        _inputStream?.close()
        _outputStream?.close()
    }
    
    /**
     Delegate for input/output streams. If any errors occur, socket error is set.
    */
    func stream(_ stream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.errorOccurred:
            socketError = stream.streamError.debugDescription
            Connected(message: "Retry")
        case Stream.Event.endEncountered:
            socketError = "Disconnected"
        default:
            socketError = nil
            Connected(message: "Connected")
        }
    }
    
    /**
     Reads bytes from the input stream.
     Checks if stream has bytes available, adds them to the buffer, retains the information and flushes the buffer.
     Returns a JSON string.
     */
    func ReadBytes () -> String {
        var bytes = [UInt8]()
        while (_inputStream?.hasBytesAvailable)! {
            _buffer = [UInt8](repeating: 0, count: 512)
            _inputStream!.read(&_buffer, maxLength: _buffer.count)
            RetainInformation(from: _buffer, to: &bytes)
        }
        return String(bytes: bytes, encoding: String.Encoding.utf8)!
    }
    
    /**
     Writes bytes to the output stream.
    */
    func WriteBytes (data: String) {
        let data = data.data(using: String.Encoding.utf8, allowLossyConversion: false)
        data?.withUnsafeBytes { _outputStream?.write($0, maxLength: (data?.count)!) }
    }
    
    /**
     Delegate callback for connection status
    */
    func Connected (message: String) {
        delegate?.ConnectedStatus(message: message)
    }
    
    //Private methods
    
    /**
     Copies the information provided to a reference buffer.
    */
    private func RetainInformation (from original: [UInt8], to copy: inout [UInt8]) {
        for item in original {
            copy.append(item)
        }
    }
}
