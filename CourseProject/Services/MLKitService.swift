////
////  MLKitService.swift
////  CourseProject
////
////  Created by Allan on 25.04.23.
////
//
import Foundation
import MLKit
import AVFoundation
import MLImage

final class MLKitService {

    func getText(imageToRecognize: UIImage, completion: @escaping (String) -> Void) {
        let latinOptions = TextRecognizerOptions()
        let latinTextRecognizer = TextRecognizer.textRecognizer(options: latinOptions)
        
        let visionImage = VisionImage(image: imageToRecognize)
        visionImage.orientation = imageToRecognize.imageOrientation
        var resultText: String = ""
       
        latinTextRecognizer.process(visionImage) { result, error -> Void in
            guard error == nil, let result = result else {
                print(error?.localizedDescription)
                return
            }
            var blockText: String = ""
            for block in result.blocks {
                blockText = block.text
                print(blockText)
            }
            DispatchQueue.main.async {
                completion(blockText)
            }
            
        }

    }
}




//                for line in block.lines {
//                    let lineText = line.text
//                    let lineLanguages = line.recognizedLanguages
//                    let lineCornerPoints = line.cornerPoints
//                    let lineFrame = line.frame
//                    for element in line.elements {
//                        let elementText = element.text
//                        let elementCornerPoints = element.cornerPoints
//                        let elementFrame = element.frame
//                        print("elementText: \(elementText)")
//                    }
//                    print("lineText: \(lineText)")
//                }




//import AVFoundation
//import CoreVideo
//import MLImage
//import MLKit
//
//@objc(CameraViewController)
//class CameraViewController: UIViewController {
//  private let detectors: [Detector] = [.onDeviceText]
//
//  private var currentDetector: Detector = .onDeviceText
//  private var previewLayer: AVCaptureVideoPreviewLayer!
//  private lazy var captureSession = AVCaptureSession()
//  private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
//  private var lastFrame: CMSampleBuffer?
//
//  private lazy var previewOverlayView: UIImageView = {
//
//    precondition(isViewLoaded)
//    let previewOverlayView = UIImageView(frame: .zero)
//    previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
//    previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
//    return previewOverlayView
//  }()
//
//  private lazy var annotationOverlayView: UIView = {
//    precondition(isViewLoaded)
//    let annotationOverlayView = UIView(frame: .zero)
//    annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
//    return annotationOverlayView
//  }()
//
//  // MARK: - IBOutlets
//  @IBOutlet private weak var cameraView: UIView!
//
//  // MARK: - UIViewController
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//    setUpPreviewOverlayView()
//    setUpAnnotationOverlayView()
//    setUpCaptureSessionOutput()
//    setUpCaptureSessionInput()
//  }
//
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//
//    startSession()
//  }
//
//  override func viewDidDisappear(_ animated: Bool) {
//    super.viewDidDisappear(animated)
//
//    stopSession()
//  }
//
//  override func viewDidLayoutSubviews() {
//    super.viewDidLayoutSubviews()
//
//    previewLayer.frame = cameraView.frame
//  }
//
//  // MARK: - IBActions
//  @IBAction func selectDetector(_ sender: Any) {
//    presentDetectorsAlertController()
//  }
//
//  private func recognizeTextOnDevice(
//    in image: VisionImage, width: CGFloat, height: CGFloat, detectorType: Detector
//  ) {
//
//    var options = TextRecognizerOptions.init()
//
//    var recognizedText: Text?
//    var detectionError: Error?
//    do {
//      recognizedText = try TextRecognizer.textRecognizer(options: options)
//        .results(in: image)
//    } catch let error {
//      detectionError = error
//    }
//    weak var weakSelf = self
//    DispatchQueue.main.sync {
//      guard let strongSelf = weakSelf else {
//        print("Self is nil!")
//        return
//      }
//      strongSelf.updatePreviewOverlayViewWithLastFrame()
//      if let detectionError = detectionError {
//        print("Failed to recognize text with error: \(detectionError.localizedDescription).")
//        return
//      }
//      guard let recognizedText = recognizedText else {
//        print("Text recognition returned no results.")
//        return
//      }
//
//      // Blocks.
//      for block in recognizedText.blocks {
//        let points = strongSelf.convertedPoints(
//          from: block.cornerPoints, width: width, height: height)
//        UIUtilities.addShape(
//          withPoints: points,
//          to: strongSelf.annotationOverlayView,
//          color: UIColor.purple
//        )
//
//        // Lines.
//        for line in block.lines {
//          let points = strongSelf.convertedPoints(
//            from: line.cornerPoints, width: width, height: height)
//          UIUtilities.addShape(
//            withPoints: points,
//            to: strongSelf.annotationOverlayView,
//            color: UIColor.orange
//          )
//
//          // Elements.
//          for element in line.elements {
//            let normalizedRect = CGRect(
//              x: element.frame.origin.x / width,
//              y: element.frame.origin.y / height,
//              width: element.frame.size.width / width,
//              height: element.frame.size.height / height
//            )
//            let convertedRect = strongSelf.previewLayer.layerRectConverted(
//              fromMetadataOutputRect: normalizedRect
//            )
//            UIUtilities.addRectangle(
//              convertedRect,
//              to: strongSelf.annotationOverlayView,
//              color: UIColor.green
//            )
//            let label = UILabel(frame: convertedRect)
//            label.text = element.text
//            label.adjustsFontSizeToFitWidth = true
//            strongSelf.rotate(label, orientation: image.orientation)
//            strongSelf.annotationOverlayView.addSubview(label)
//          }
//        }
//      }
//    }
//  }
//
//
//  // MARK: - Private
//  private func setUpCaptureSessionOutput() {
//    weak var weakSelf = self
//    sessionQueue.async {
//      guard let strongSelf = weakSelf else {
//        print("Self is nil!")
//        return
//      }
//      strongSelf.captureSession.beginConfiguration()
//      // When performing latency tests to determine ideal capture settings,
//      // run the app in 'release' mode to get accurate performance metrics
//      strongSelf.captureSession.sessionPreset = AVCaptureSession.Preset.medium
//
//      let output = AVCaptureVideoDataOutput()
//      output.videoSettings = [
//        (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
//      ]
//      output.alwaysDiscardsLateVideoFrames = true
//      let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
//      output.setSampleBufferDelegate(strongSelf, queue: outputQueue)
//      guard strongSelf.captureSession.canAddOutput(output) else {
//        print("Failed to add capture session output.")
//        return
//      }
//      strongSelf.captureSession.addOutput(output)
//      strongSelf.captureSession.commitConfiguration()
//    }
//  }
//
//  private func setUpCaptureSessionInput() {
//    weak var weakSelf = self
//    sessionQueue.async {
//      guard let strongSelf = weakSelf else {
//        print("Self is nil!")
//        return
//      }
//      let cameraPosition: AVCaptureDevice.Position = strongSelf.isUsingFrontCamera ? .front : .back
//      guard let device = strongSelf.captureDevice(forPosition: cameraPosition) else {
//        print("Failed to get capture device for camera position: \(cameraPosition)")
//        return
//      }
//      do {
//        strongSelf.captureSession.beginConfiguration()
//        let currentInputs = strongSelf.captureSession.inputs
//        for input in currentInputs {
//          strongSelf.captureSession.removeInput(input)
//        }
//
//        let input = try AVCaptureDeviceInput(device: device)
//        guard strongSelf.captureSession.canAddInput(input) else {
//          print("Failed to add capture session input.")
//          return
//        }
//        strongSelf.captureSession.addInput(input)
//        strongSelf.captureSession.commitConfiguration()
//      } catch {
//        print("Failed to create capture device input: \(error.localizedDescription)")
//      }
//    }
//  }
//
//  private func startSession() {
//    weak var weakSelf = self
//    sessionQueue.async {
//      guard let strongSelf = weakSelf else {
//        print("Self is nil!")
//        return
//      }
//      strongSelf.captureSession.startRunning()
//    }
//  }
//
//  private func stopSession() {
//    weak var weakSelf = self
//    sessionQueue.async {
//      guard let strongSelf = weakSelf else {
//        print("Self is nil!")
//        return
//      }
//      strongSelf.captureSession.stopRunning()
//    }
//  }
//
//  private func setUpPreviewOverlayView() {
//    cameraView.addSubview(previewOverlayView)
//    NSLayoutConstraint.activate([
//      previewOverlayView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
//      previewOverlayView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
//      previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
//      previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
//
//    ])
//  }
//
//  private func setUpAnnotationOverlayView() {
//    cameraView.addSubview(annotationOverlayView)
//    NSLayoutConstraint.activate([
//      annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
//      annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
//      annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
//      annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
//    ])
//  }
//
//  private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
//    if #available(iOS 10.0, *) {
//      let discoverySession = AVCaptureDevice.DiscoverySession(
//        deviceTypes: [.builtInWideAngleCamera],
//        mediaType: .video,
//        position: .unspecified
//      )
//      return discoverySession.devices.first { $0.position == position }
//    }
//    return nil
//  }
//
//  private func presentDetectorsAlertController() {
//    let alertController = UIAlertController(
//      title: Constant.alertControllerTitle,
//      message: Constant.alertControllerMessage,
//      preferredStyle: .alert
//    )
//    weak var weakSelf = self
//    detectors.forEach { detectorType in
//      let action = UIAlertAction(title: detectorType.rawValue, style: .default) {
//        [unowned self] (action) in
//        guard let value = action.title else { return }
//        guard let detector = Detector(rawValue: value) else { return }
//        guard let strongSelf = weakSelf else {
//          print("Self is nil!")
//          return
//        }
//        strongSelf.currentDetector = detector
//        strongSelf.removeDetectionAnnotations()
//      }
//      if detectorType.rawValue == self.currentDetector.rawValue { action.isEnabled = false }
//      alertController.addAction(action)
//    }
//    alertController.addAction(UIAlertAction(title: Constant.cancelActionTitleText, style: .cancel))
//    present(alertController, animated: true)
//  }
//
//  private func removeDetectionAnnotations() {
//    for annotationView in annotationOverlayView.subviews {
//      annotationView.removeFromSuperview()
//    }
//  }
//
//  private func updatePreviewOverlayViewWithLastFrame() {
//    guard let lastFrame = lastFrame,
//      let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
//    else {
//      return
//    }
//    self.updatePreviewOverlayViewWithImageBuffer(imageBuffer)
//    self.removeDetectionAnnotations()
//  }
//
//  private func updatePreviewOverlayViewWithImageBuffer(_ imageBuffer: CVImageBuffer?) {
//    guard let imageBuffer = imageBuffer else {
//      return
//    }
//    let orientation: UIImage.Orientation = isUsingFrontCamera ? .leftMirrored : .right
//    let image = UIUtilities.createUIImage(from: imageBuffer, orientation: orientation)
//    previewOverlayView.image = image
//  }
//
//  private func convertedPoints(
//    from points: [NSValue]?,
//    width: CGFloat,
//    height: CGFloat
//  ) -> [NSValue]? {
//    return points?.map {
//      let cgPointValue = $0.cgPointValue
//      let normalizedPoint = CGPoint(x: cgPointValue.x / width, y: cgPointValue.y / height)
//      let cgPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
//      let value = NSValue(cgPoint: cgPoint)
//      return value
//    }
//  }
//
//  private func normalizedPoint(
//    fromVisionPoint point: VisionPoint,
//    width: CGFloat,
//    height: CGFloat
//  ) -> CGPoint {
//    let cgPoint = CGPoint(x: point.x, y: point.y)
//    var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
//    normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
//    return normalizedPoint
//  }
//
//  private func rotate(_ view: UIView, orientation: UIImage.Orientation) {
//    var degree: CGFloat = 0.0
//    switch orientation {
//    case .up, .upMirrored:
//      degree = 90.0
//    case .rightMirrored, .left:
//      degree = 180.0
//    case .down, .downMirrored:
//      degree = 270.0
//    case .leftMirrored, .right:
//      degree = 0.0
//    }
//    view.transform = CGAffineTransform.init(rotationAngle: degree * 3.141592654 / 180)
//  }
//}
//
//// MARK: AVCaptureVideoDataOutputSampleBufferDelegate
//extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//
//  func captureOutput(
//    _ output: AVCaptureOutput,
//    didOutput sampleBuffer: CMSampleBuffer,
//    from connection: AVCaptureConnection
//  ) {
//    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//      print("Failed to get image buffer from sample buffer.")
//      return
//    }
//    // Evaluate `self.currentDetector` once to ensure consistency throughout this method since it
//    // can be concurrently modified from the main thread.
//    let activeDetector = self.currentDetector
//    resetManagedLifecycleDetectors(activeDetector: activeDetector)
//
//    lastFrame = sampleBuffer
//    let visionImage = VisionImage(buffer: sampleBuffer)
//    let orientation = UIUtilities.imageOrientation(
//      fromDevicePosition: isUsingFrontCamera ? .front : .back
//    )
//    visionImage.orientation = orientation
//
//    guard let inputImage = MLImage(sampleBuffer: sampleBuffer) else {
//      print("Failed to create MLImage from sample buffer.")
//      return
//    }
//    inputImage.orientation = orientation
//
//    let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
//    let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
//    var shouldEnableClassification = false
//    var shouldEnableMultipleObjects = false
//    switch activeDetector {
//    case .onDeviceObjectProminentWithClassifier, .onDeviceObjectMultipleWithClassifier,
//      .onDeviceObjectCustomProminentWithClassifier, .onDeviceObjectCustomMultipleWithClassifier:
//      shouldEnableClassification = true
//    default:
//      break
//    }
//    switch activeDetector {
//    case .onDeviceObjectMultipleNoClassifier, .onDeviceObjectMultipleWithClassifier,
//      .onDeviceObjectCustomMultipleNoClassifier, .onDeviceObjectCustomMultipleWithClassifier:
//      shouldEnableMultipleObjects = true
//    default:
//      break
//    }
//
//    switch activeDetector {
//    case .onDeviceText:
//      recognizeTextOnDevice(
//        in: visionImage, width: imageWidth, height: imageHeight, detectorType: activeDetector)
//    }
//}
//
//// MARK: - Constants
//public enum Detector: String {
//  case onDeviceText = "Text Recognition"
//}
//
//private enum Constant {
//  static let alertControllerTitle = "Vision Detectors"
//  static let alertControllerMessage = "Select a detector"
//  static let cancelActionTitleText = "Cancel"
//  static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
//  static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
//  static let noResultsMessage = "No Results"
//  static let localModelFile = (name: "bird", type: "tflite")
//  static let labelConfidenceThreshold = 0.75
//  static let smallDotRadius: CGFloat = 4.0
//  static let lineWidth: CGFloat = 3.0
//  static let originalScale: CGFloat = 1.0
//  static let padding: CGFloat = 10.0
//  static let resultsLabelHeight: CGFloat = 200.0
//  static let resultsLabelLines = 5
//  static let imageLabelResultFrameX = 0.4
//  static let imageLabelResultFrameY = 0.1
//  static let imageLabelResultFrameWidth = 0.5
//  static let imageLabelResultFrameHeight = 0.8
//  static let segmentationMaskAlpha: CGFloat = 0.5
//}
