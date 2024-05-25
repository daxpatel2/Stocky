import AVKit
import AVFoundation
import Vision

class ViewController: UIViewController,ObservableObject {
    
    let captureSession = AVCaptureSession()
    
    func setupCaptureSessionRequirements() {
        
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {return}
    
        guard let input = try? AVCaptureDeviceInput(device: videoDevice) else {return}
        
        captureSession.addInput(input)
    }
    
    func startCamera() {
        DispatchQueue.global(qos: .background).async {
            self.setupCaptureSessionRequirements()
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.view.layer.addSublayer(previewLayer)
                previewLayer.frame = self.view.frame
            }
        }
    }
    
    func stopCamera() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.stopRunning()
        }
    }
}
