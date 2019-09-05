//
//  QRCodeScannerController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScannerController: UIViewController {
    
    // 用來管理擷取活動和協調輸入及輸出數據流的對象。
    var captureSession: AVCaptureSession?
    
    // 核心動畫層，可以在擷取視頻時顯示視頻。
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // 稍後我們為了替我們的 QR Code 加上掃描框使用。
    var qrCodeFrameView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationScanner()
    }
    
    func configurationScanner() {
        // 取得後置鏡頭來擷取影片
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("無法獲取相機裝置")
            return
        }
        do {
            // 使用前一個裝置物件 captureDevice 來取得 AVCaptureDeviceInput 類別的實例
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // 實例化 AVCaptureSession，設定 captureSession 的輸入裝置
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            // 實例化 AVCaptureMetadataOutput 物件並將其設定做為 captureSession 的輸出
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            // 設置 delegate 為 self，並使用預設的調度佇列來執行 Call back
            // 當一個新的元資料被擷取時，便會將其轉交給委派物件做進一步處理
            // 依照 Apple 的文件，我們這邊使用 DispatchQueue.main 來取得預設的主佇列
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // 告訴 App 我們所想要處理 metadata 的對象對象類型
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            // 用於顯示我們的相機畫面
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            // 設置影片在 videoPreivewLayer 的顯示方式
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            // 設置 QR Code 掃描框
            settingScannerFrame()
            // 開始擷取畫面
            captureSession!.startRunning()
        } catch {
            // 假如有錯誤發生、印出錯誤描述並且 return
            print(error.localizedDescription)
            return
        }
    }
    
    func settingScannerFrame() {
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            // 將 qrCodeFrameView 排至畫面最前方
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
}

extension QRCodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        if metadataObjects.isEmpty {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        // 如果能夠取得 metadataObjects 並且能夠轉換成 AVMetadataMachineReadableCodeObject（條碼訊息）
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            // 判斷 metadataObj 的類型是否為 QR Code
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                //  如果 metadata 與 QR code metadata 相同，則更新搜尋框的 frame
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                if let value = metadataObj.stringValue {
                    print(value)
                }
            }
        }
    }
}
