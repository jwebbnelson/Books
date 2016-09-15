//
//  ScanViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 6/26/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit
import AVFoundation

public let ISBNUpdatedNotification = "ISBNUpdatedNotificationName"

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var cancelButton: UIButton!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var isbnFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setUpCapture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Capture
    
    func setUpCapture() {
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
          let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
        } catch {
            print("ERROR WITH AVCAPTUREDeviceInput")
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code]
        
        setUpVideoCapture()
    }
    
    func setUpVideoCapture() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        view.bringSubview(toFront: cancelButton)
        
        captureSession?.startRunning()
        isbnHighlightBoxSetUp()
    }
    
    
    // MARK: - AVCaptureDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            displayMessage()
            return
        }
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if metadataObject.type == AVMetadataObjectTypeEAN13Code {
                if let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) {
                    isbnFrameView?.frame = barcodeObject.bounds
                }
            }
            if metadataObject.stringValue != nil {
                dismiss(animated: true, completion: { 
                    self.isbnCapturedNotification(metadataObject.stringValue)
                })
            }
            
        }
        
        
    }
    
    // MARK: - ScannerDisplay
    
    func displayMessage() {
        DispatchQueue.main.async { 
            let messageLabel = UILabel()
            messageLabel.text = "ISBN not detected"
            messageLabel.center.x = self.view.center.x
            messageLabel.center.y = self.view.center.y
            self.view.addSubview(messageLabel)
            self.view.bringSubview(toFront: messageLabel)
        }
    }
    
    func isbnHighlightBoxSetUp() {
        isbnFrameView = UIView()
        isbnFrameView?.layer.borderColor = UIColor.blue.cgColor
        isbnFrameView?.layer.borderWidth = 2
        view.addSubview(isbnFrameView!)
        view.bringSubview(toFront: isbnFrameView!)
    }
    
    func isbnCapturedNotification(_ isbn:String) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: ISBNUpdatedNotification), object: isbn)
    }
}

