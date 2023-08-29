//
//  QRScannerViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 24/08/23.
//

import UIKit
import AVFoundation

internal class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    weak var delegate: QRScannerDelegate!
    var localizer: CybridLocalizer!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView!

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.localizer = CybridLocalizer()
        self.captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video)
        else { return }

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)

        // -- Create exit button
        self.createExitButton()

        // -- Create white square
        self.createQRCodeFrame()

        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    internal func createExitButton() {

        let xButton = UIButton(type: .custom)
        xButton.setTitle("", for: .normal)
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.imageView?.contentMode = .scaleToFill
        xButton.contentVerticalAlignment = .fill
        xButton.contentHorizontalAlignment = .fill
        xButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        xButton.tintColor = UIColor.white
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        self.view.addSubview(xButton)
        xButton.constraintSafeTop(self.view, margin: 0)
        xButton.constraintRight(self.view, margin: 25)
        xButton.setConstraintsSize(size: CGSize(width: 45, height: 45))
        self.view.bringSubviewToFront(xButton)
    }

    internal func createQRCodeFrame() {

        qrCodeFrameView = UIView()
        qrCodeFrameView.layer.borderColor = UIColor.white.cgColor
        qrCodeFrameView.layer.borderWidth = 3
        qrCodeFrameView.layer.cornerRadius = 10
        self.view.addSubview(qrCodeFrameView)
        qrCodeFrameView.centerVertical(parent: self.view)
        qrCodeFrameView.centerHorizontal(parent: self.view)
        qrCodeFrameView.setConstraintsSize(size: CGSize(width: 180, height: 180))
        self.view.bringSubviewToFront(qrCodeFrameView)
    }

    func failed() {
        
        let alertTitleString = localizer.localize(with: "cybrid.external.wallets.qr.scanner.controller.error.title")
        let alertMessageString = localizer.localize(with: "cybrid.external.wallets.qr.scanner.controller.error.message")
        let allertButtonString = localizer.localize(with: "cybrid.external.wallets.qr.scanner.controller.error.button")
        
        let alert = UIAlertController(title: alertTitleString, message: alertMessageString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: allertButtonString, style: .default))
        present(alert, animated: true)
        self.captureSession = nil
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        self.captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }

    func found(code: String) {
        self.delegate?.onQRFound(code: code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @objc
    func xButtonTapped() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}

internal protocol QRScannerDelegate: AnyObject {
    func onQRFound(code: String)
}
