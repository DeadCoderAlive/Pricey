//
//  CameraViewController.swift
//  Pricey
//
//  Created by Srinivasan Sundaramoorthy on 7/19/17.
//  Copyright © 2017 Srinivasan Sundaramoorthy. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var session:AVCaptureSession!
    var previewLayer:AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
        let metadataOutput = AVCaptureMetadataOutput()
        if(session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeEAN13Code]
        }else {deviceUnableToScan()}
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        self.view.layer.addSublayer(previewLayer)
        session.startRunning()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpCamera() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var videoInput:AVCaptureDeviceInput?
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
            }
        catch {
            
        }
        session = AVCaptureSession()
        if(session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        }
    }
    
    func deviceUnableToScan() {
       let alert = UIAlertController(title:Constants.UNABLETOSCAN_ALERT_TITLE , message:Constants.UNABLETOSCAN_ALERT_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constants.OK_BUTTON_TITLE, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        if(!session.isRunning) {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(session.isRunning) {
            session.stopRunning()
        }
    }
    
    //MARK : AVCaptureMetaDataObjectsDelegate methods
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if let codeData = metadataObjects.first {
            let codeReadable = codeData as! AVMetadataMachineReadableCodeObject
            print(codeReadable.stringValue)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
