import SwiftUI
import AVKit


struct LaunchCameraScreen: View {
    @ObservedObject var objectDetection = ViewController()
    @StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            CameraPreview(viewModel: cameraViewModel)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    cameraViewModel.startCamera()
                }
                .onDisappear {
                    cameraViewModel.stopCamera()
                }
        }
    }
}
