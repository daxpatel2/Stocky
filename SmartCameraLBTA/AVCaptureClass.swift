import AVKit
import AVFoundation
import Vision

class ViewController: UIViewController, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndStartCamera()
    }
    
    func setupAndStartCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let videoDevice = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: videoDevice) else {
                DispatchQueue.main.async {
                    print("Error setting up camera")
                }
                return
            }
            
            self.captureSession.beginConfiguration()
            if self.captureSession.canAddInput(input) {
                self.captureSession.addInput(input)
            }
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            if self.captureSession.canAddOutput(dataOutput) {
                self.captureSession.addOutput(dataOutput)
            }
            
            self.captureSession.commitConfiguration()
            
            DispatchQueue.main.async {
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                if let previewLayer = self.previewLayer {
                    previewLayer.frame = self.view.bounds
                    previewLayer.videoGravity = .resizeAspectFill
                    self.view.layer.addSublayer(previewLayer)
                    self.captureSession.startRunning()
                }
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier, firstObservation.confidence)
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func stopCamera() {
        DispatchQueue.global(qos: .background).async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
}
