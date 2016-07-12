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
    
    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
          let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
        } catch {
            print("ERROR WITH AVCAPTUREDeviceInput")
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code]
        
        setUpVideoCapture()
    }
    
    func setUpVideoCapture() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        view.bringSubviewToFront(cancelButton)
        
        captureSession?.startRunning()
        isbnHighlightBoxSetUp()
    }
    
    
    // MARK: - AVCaptureDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            displayMessage()
            return
        }
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if metadataObject.type == AVMetadataObjectTypeEAN13Code {
                if let barcodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObject) {
                    isbnFrameView?.frame = barcodeObject.bounds
                }
            }
            if metadataObject.stringValue != nil {
                dismissViewControllerAnimated(true, completion: { 
                    self.isbnCapturedNotification(metadataObject.stringValue)
                })
            }
            
        }
        
        
    }
    
    // MARK: - ScannerDisplay
    
    func displayMessage() {
        dispatch_async(dispatch_get_main_queue()) { 
            let messageLabel = UILabel()
            messageLabel.text = "ISBN not detected"
            messageLabel.center.x = self.view.center.x
            messageLabel.center.y = self.view.center.y
            self.view.addSubview(messageLabel)
            self.view.bringSubviewToFront(messageLabel)
        }
    }
    
    func isbnHighlightBoxSetUp() {
        isbnFrameView = UIView()
        isbnFrameView?.layer.borderColor = UIColor.blueColor().CGColor
        isbnFrameView?.layer.borderWidth = 2
        view.addSubview(isbnFrameView!)
        view.bringSubviewToFront(isbnFrameView!)
    }
    
    func isbnCapturedNotification(isbn:String) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(ISBNUpdatedNotification, object: isbn)
    }
}

