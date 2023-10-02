//
//  ServiceView.swift
//  soundsride
//
//  Created by Mohamed Kari on 04.02.21.
//  Copyright © 2021 Mohamed Kari. All rights reserved.
//

import SwiftUI
import Foundation
import NIO
import GRPC
import AVFoundation

class SoundsRideService {
    
    let ip: String = "192.168.0.103"
    let port = 8888
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 3)
    let channel: ClientConnection
    let client: SoundsRideClient
    let sessionID: Int32
    
    
    init() {
        channel = ClientConnection.insecure(group: group)
            .connect(host: ip, port: port)
        
        client = SoundsRideClient(channel: channel)
        
        let call = client.startSession(Empty())

        let startSessionResponse = try! call.response.wait()
        
        sessionID = startSessionResponse.sessionID
    }

    func _chunkToBuffer(audioChunk: Data) -> AVAudioPCMBuffer {
        // AudioEngine requires
        // - little endian (
        // - pcmFormatFloat32 (pcmInt16 does not work and it throws with a format NSException)
        // - non-interleaved audio (otherwise AURemote IO throws with BAD_EXC)
        //
        // constraint 1 and 2 require to export to 'f32le' format on the server side
        
        
        // Currently, we're slowly sending uncompressed PCM data
        // In order to speed up things, we should use AudioConverterFillComplexBuffer 
        
        let nChannels = 1
        let sampleRate = 44100.0
        let bytesPerSample = 4
        let bytesPerFrame = nChannels * bytesPerSample
        let nFrames = UInt32(audioChunk.count / bytesPerFrame)
        print(nFrames)
        let nBytes = audioChunk.count
        print("nBytes: \(nBytes)")
        print("Duration: \( Double(nBytes) / Double(nChannels) / sampleRate / Double(bytesPerSample))")
        
        let bufferSizeInBytes = nFrames * UInt32(bytesPerFrame)
        
        print("Chunk size: \(audioChunk.count)")
        print("Allocating buffer of bytes size \(bufferSizeInBytes)")
        
        let audioFormat = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatFloat32, sampleRate: sampleRate, channels: UInt32(nChannels), interleaved: false)
        let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: nFrames)!
        pcmBuffer.frameLength = nFrames
        
        let raw_pointer = UnsafeMutableBufferPointer<Float32>(start: pcmBuffer.floatChannelData!.pointee, count: Int(bufferSizeInBytes))
        
        audioChunk.copyBytes(to: raw_pointer, count: Int(bufferSizeInBytes))
        print("Raw Pointer: \(raw_pointer)")
        print("PcmBuffer: \(pcmBuffer)")
        
        return pcmBuffer
    }

    
    func _getBufferFromFile() -> AVAudioPCMBuffer? {
        let musicFileUrl = Bundle(for: Self.self).url(forResource: "underground", withExtension: "mp3")
        
    
        guard let audioFile = try? AVAudioFile(forReading: musicFileUrl!) else{ return nil }
        
        let audioFormat = audioFile.processingFormat
        
        print(audioFile.length)
        
        let audioFrameCount = UInt32(audioFile.length)
        guard let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)  else{ return nil }
        
        do{
            try audioFile.read(into: audioFileBuffer)
        } catch{
            print("over")
        }
        
        
        return audioFileBuffer
    }

    
    func getChunk() -> Data {
        let call = client.getChunk(Empty())
        let audioChunkResponse = try! call.response.wait()
        
        return audioChunkResponse.audioChunk
    }
    
    func updateTransitionSpec(transitions: [Transition], currentLatitude: Double?, currentLongitude: Double?, nextUp: String?){
        let req = UpdateTransitionSpecRequest.with { req in
            req.transitions = transitions
            req.currentLatitude = currentLatitude ?? 0.0
            req.currentLongitude = currentLongitude ?? 0.0
            req.nextUp = nextUp ?? ""
            req.sessionID = sessionID
        }
        
        let call = client.updateTransitionSpec(req)
        // let resp = try! call.response.wait()
        // let audioChunk = resp.audioChunk
        
    }


    func ping() {
        var callOptions = CallOptions.init()
        callOptions.timeLimit = TimeLimit.timeout(TimeAmount.seconds(5))
        let call = client.ping(Empty(), callOptions: callOptions)
        let empty = try! call.response.wait()
    }

}

struct ServiceView: View {
    @State var roundtripTime: Double = 0.0
    @State var soundsRideService: SoundsRideService?
    @State var audioEngine: AVAudioEngine = AVAudioEngine()
    @State var audioPlayerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    
    var body: some View {
        Button(action: {
            let start = DispatchTime.now()
            
            if soundsRideService == nil {
                soundsRideService = SoundsRideService()
            }
            
            soundsRideService!.ping()
        }, label: {
            Text("Start Session and Ping")
        })
        
        Button(action: {
                
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback) // THIS LINE IS ABSOLUTELY NECESSARY
            
            // try! AVAudioSession.sharedInstance().setActive(true)
            // try! AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        
            let audioChunk = soundsRideService!.getChunk()
            let audioFileBuffer = soundsRideService!._chunkToBuffer(audioChunk: audioChunk)
            
            // let audioFileBuffer = soundsRideService._getBufferFromFile()!
            // print("audioFileBuffer.format.isInterleaved \(audioFileBuffer.format.isInterleaved)")
         
            let mainMixer = audioEngine.mainMixerNode
            audioEngine.attach(audioPlayerNode)
            audioEngine.connect(audioPlayerNode, to:mainMixer, format: audioFileBuffer.format)
            try? audioEngine.start()
            audioPlayerNode.play()
            audioPlayerNode.scheduleBuffer(audioFileBuffer, at: nil, options:AVAudioPlayerNodeBufferOptions.interrupts)
             
            
        }, label: {
            Text("Playback Chunk")
        })
        Text("Last roundtrip took \(roundtripTime)")
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView()
    }
}
