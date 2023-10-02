import SwiftUI
import AVFoundation
import CoreLocation
import MapKit

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}


class AVUtils {
    
    class func attachCameraInputToSession(session: AVCaptureSession) -> AVCaptureDeviceInput? {
        guard let videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            printFailure(message: "Front Wide Angle Camera not found!")
            return nil
        }

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            printFailure(message: "Couldn't create video input from Front Wide Angle Camera device!")
            return nil
        }
        
        
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            printFailure(message: "Couldn't add video input to AVCaptureSession!")
            return nil
        }
        
        return videoInput
    }
    
    class func attachMetadataOutputToSession(session: AVCaptureSession, delegate: AVCaptureMetadataOutputObjectsDelegate) -> AVCaptureMetadataOutput? {
        // Create Output with Output delegate
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Attach Output to Session
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .code128]
        } else {
            printFailure(message: "Couldn't attach metadata output to AVCaptureSession!")
            return nil
        }
        
        return metadataOutput
    }
    
    class func attachVideoOutputToSession(session: AVCaptureSession, delegate: AVCaptureVideoDataOutputSampleBufferDelegate) -> AVCaptureVideoDataOutput? {
        
        // Create Output
        let videoDataOutput = AVCaptureVideoDataOutput()
            
        // Attach Output to Session
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue.main)
            // videoDataOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
        } else {
            printFailure(message: "Couldn't attach videoDataOutput to AVCaptureSession!")
            return nil
        }
        
        
        return videoDataOutput
    }
    
    class func getAVAssetWriterFromVideoOutput(fileUrl: URL, videoOutput: AVCaptureVideoDataOutput) -> (AVAssetWriter, AVAssetWriterInput, AVAssetWriterInputPixelBufferAdaptor)  {
        // https://gist.github.com/yusuke024/b5cd3909d9d7f9e919291491f6b381f0
        
        print("Setting video URL to \(fileUrl)")
        let writer = try! AVAssetWriter(outputURL: fileUrl, fileType: .mov)
        
        
        let settings = videoOutput.recommendedVideoSettingsForAssetWriter(writingTo: .mov)
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: settings) // [AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: 1920, AVVideoHeightKey: 1080])
        
        writerInput.mediaTimeScale = CMTimeScale(bitPattern: 600)
        writerInput.expectsMediaDataInRealTime = true
        writerInput.transform = CGAffineTransform(rotationAngle: .pi/2)
        
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: nil)
        
        if writer.canAdd(writerInput) {
            writer.add(writerInput)
        }
        
        return (writer, writerInput, adaptor)
    }
    
    class func getPreviewLayerFromSession(session: AVCaptureSession) -> AVCaptureVideoPreviewLayer{
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        // previewLayer.frame = CGRect(x: 20, y: 60, width: 335, height: 200)
        return previewLayer
    }
    
    class func printFailure(message: String){
        print(message)
    }
}

protocol VideoCapturerDelegate {
    func didUpdateMostRecentFrame(videoCapturer: VideoCapturer, mostRecentFrame: CGImage)

    func didStop(videoCapturer: VideoCapturer, sessionId: String)
}

class VideoCapturer: NSObject, AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    
    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var delegate: VideoCapturerDelegate?
    
    var writer: AVAssetWriter?
    var adaptor: AVAssetWriterInputPixelBufferAdaptor?
    var writerInput: AVAssetWriterInput?
    var startTime: Double?
    
    var sessionId: String?
    
    @Published var mostRecentFrame: CGImage?
    @Published var isRunning: Bool = false
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session!.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print("found QR code: \(stringValue)")
        }
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard sampleBuffer.isValid else {
            return
        }
        
        /*
         Relevant fields:
         - sampleBuffer.numSamples
         - sampleBuffer.presentationTimeStamp
         - sampleBuffer.imageBuffer
         - sampleBuffer.formatDescription
         - sampleBuffer.attachments
         
         Currently, uninteresting to us
         - sampleBuffer.formatDescription
         - sampleBuffer.attachments
        
         Empty and non-informative stuff for video frames
         - sampleBuffer.totalSampleSize  // 0
         - sampleBuffer.duration // 0
         - sampleBuffer.dataBuffer // nil
         - sampleBuffer.decodeTimeStamp  // 0
         - sampleBuffer.outputDecodeTimeStamp // 0
         - sampleBuffer.outputPresentationTimeStamp // == sampleBuffer.presentationTimeStamp
         - sampleBuffer.sampleAttachments // == sampleBuffer.attachments)
         */
        
        let imageBuffer: CVPixelBuffer = sampleBuffer.imageBuffer!
        let ciImage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
        let cgImage: CGImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent)!
        // let uiImage: UIImage = UIImage.init(cgImage: cgImage)
        
        // Update mostRecentFrame
        mostRecentFrame = cgImage
        
        // Invoke delegate
        if let delegate = self.delegate {
            delegate.didUpdateMostRecentFrame(videoCapturer: self, mostRecentFrame: cgImage)
        }
        
        // Append to video
        if startTime == nil {
            startTime = sampleBuffer.presentationTimeStamp.seconds
        }
        
        let currentTime = CMTime(seconds: sampleBuffer.presentationTimeStamp.seconds - startTime!, preferredTimescale: CMTimeScale(600))
        adaptor!.append(sampleBuffer.imageBuffer!, withPresentationTime: currentTime)
                
       
    }

    func start() {
        // Set up folder
        sessionId = Persistence.getFSCompatibleTimeStamp()
        try! Persistence.mkdir(directoryName: sessionId!)
        
        // Set up AVCaptureSession
        session = AVCaptureSession()
        let _ = AVUtils.attachCameraInputToSession(session: session!)
        // let attachMetadataOutputSuccessful = VideoCapture.attachMetadataOutputToSession(session: session!, delegate: self)
        let attachedVideoOutput = AVUtils.attachVideoOutputToSession(session: session!, delegate: self)
        
        // Setup AVAssetWriter
        (writer, writerInput, adaptor) = AVUtils.getAVAssetWriterFromVideoOutput(
            fileUrl: Persistence.getUrl(directoryName: sessionId!, fileName: "video.mov"),
            videoOutput: attachedVideoOutput!)
        
        writer!.startWriting()
        writer!.startSession(atSourceTime: .zero)
        
        isRunning = true
        session!.startRunning()
        
    }
    
    func stop() {
        if let session = session {
            session.stopRunning()
        }
        
        self.session = nil
        
        writerInput!.markAsFinished()

        writer!.finishWriting(completionHandler: {
            self.adaptor = nil
            self.writer = nil
            self.writerInput = nil
            self.startTime = nil
            DispatchQueue.main.async {
                self.isRunning = false
            }
        })
        
        if let delegate = self.delegate {
            delegate.didStop(videoCapturer: self, sessionId: self.sessionId!)
        }
        
    }
   
}

protocol HttpRequestDelegate {
    func didReceiveResponse(requestId: Int, response: Data)
}

class HttpRequest {
    
    func getUrl() -> URL {
        fatalError("Must override")
    }
    
    func getMethod() -> String {
        fatalError("Must override")
    }
    
    func getBody() -> Data? {
        fatalError("Must override")
    }
    
    func getHeaders() -> Dictionary<String, String>? {
        fatalError("Must override")
    }
    
    func toRequest() -> URLRequest {
        // let bodyParams = ["key" : "value"] as Dictionary<String, String>
        // var body = try? JSONSerialization.data(withJSONObject: bodyParams, options: [])
        
        var request = URLRequest(url: self.getUrl())
        request.httpMethod = self.getMethod()
        
        if let body = self.getBody() {
            request.httpBody = body
        }
        
        if let headers = self.getHeaders() {
            for (headerName, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerName)
            }
        }
        
        return request
    }
    
    func sendRequest(httpRequestDelegate: HttpRequestDelegate?, requestId: Int) {
        let session = URLSession.shared
        let request = self.toRequest()
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let httpRequestDelegate = httpRequestDelegate {
                DispatchQueue.main.async {
                    httpRequestDelegate.didReceiveResponse(requestId: requestId, response: data!)
                }
            }
        }

        task.resume()
    }
    
    func sendRequestAndBlock() -> Data? {
        let session = URLSession.shared
        let request = self.toRequest()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var response_data: Data? = nil
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            response_data = data
            
            semaphore.signal()
        }

        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return response_data

    }
    
}

class DevRequest: HttpRequest {
    
    override func getUrl() -> URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "192.168.178.35"
        components.path = "/"
        components.port = 8000
        
        // Getting a URL from our components is as simple as
        // accessing the 'url' property.
        
        return components.url!
    }
    
    override func getMethod() -> String {
        return "GET"
    }
    
    override func getHeaders() -> Dictionary<String, String>? {
        return nil
    }
    
    override func getBody() -> Data? {
        return nil
    }
    
}

protocol soundsrideRequestFactory {
    func makeRequest(uiImage: UIImage) -> HttpRequest
}


struct Location: Identifiable {
    var location: CLLocation
    let id = UUID()
}

struct RequestLogEntry {
    var frame: UIImage
    var timestampMillis: Int64
        
}


class StringResponseProcessor {
    class func process (data: Data?) -> String {
        if let data = data {
            return String(decoding: data, as: UTF8.self)
        } else {
            return ""
        }
    }
}

class Capturer: ObservableObject {
    var videoCapturer = VideoCapturer()
    var locationManager = CLLocationManager()
    
    @Published var isRunning = false
    
    init() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    var videoCapturerDelegate: VideoCapturerDelegate? {
        get {
            return videoCapturer.delegate
        }
        set {
            videoCapturer.delegate = newValue
        }
    }
    
    var locationManagerDelegate: CLLocationManagerDelegate? {
        get {
            return locationManager.delegate
        }
        set {
            locationManager.delegate = newValue
        }
    }
    
    func start() {
        isRunning = true
        videoCapturer.start()
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
        videoCapturer.stop()
        isRunning = false
    }
}

