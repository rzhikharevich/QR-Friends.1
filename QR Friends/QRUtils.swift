import UIKit
import AVFoundation

func makeQRCode(string: String) -> UIImage {
    let data = string.data(using: .isoLatin1, allowLossyConversion: true)
    
    let filter = CIFilter(name: "CIQRCodeGenerator")!
    
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("Q",  forKey: "inputCorrectionLevel")

    let ciImage = filter.outputImage!.applying(
        CGAffineTransform(scaleX: 5.0, y: 5.0)
    )
    
    return UIImage(ciImage: ciImage)
}

class QRCodeCapturer: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession! = nil
    var videoPreviewLayer: AVCaptureVideoPreviewLayer! = nil
    
    typealias CompletionHandler = (String) -> ()
    let onCompletion: CompletionHandler
    
    init(view: UIView, onCompletion: @escaping CompletionHandler) {
        self.onCompletion = onCompletion
        
        super.init()
        
        let dev = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        let input = try! AVCaptureDeviceInput(device: dev)
        
        captureSession = AVCaptureSession()
        captureSession.addInput(input as AVCaptureInput)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)!
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            print("scan fail")
            return
        }
        
        if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObjectTypeQRCode {
                if let string = object.stringValue {
                    onCompletion(string)
                }
            }
        }
    }
}
