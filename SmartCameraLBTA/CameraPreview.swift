import SwiftUI
import UIKit

struct CameraPreview: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIViewController(context: Context) -> ViewController {
        return viewModel.viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // No updates needed as the UIViewController handles its own updates
    }
}

class CameraViewModel: ObservableObject {
    let viewController = ViewController()
    
    func startCamera() {
        viewController.startCamera()
    }
    
    func stopCamera() {
        viewController.stopCamera()
    }
}
