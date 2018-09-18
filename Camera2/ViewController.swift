import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
   
  
    /// 撮影ボタン押下時に呼ばれる
    

    
    @IBOutlet weak var cameraView: UIImageView!
    
    var captureSesssion: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSesssion = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        
        // 解像度の設定
        captureSesssion.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: (device)!)
            
            // 入力
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                
                // 出力
                if (captureSesssion.canAddOutput(stillImageOutput!)) {
                    
                    // カメラ起動
                    captureSesssion.addOutput(stillImageOutput!)
                    captureSesssion.startRunning()

                    // アスペクト比、カメラの向き(縦)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect // アスペクトフィット
                    previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    
                    cameraView.layer.addSublayer(previewLayer!)
                    
                    // ビューのサイズの調整
                    previewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                    previewLayer?.bounds = cameraView.frame
                }
            }
        }
        catch {
            print(error)
        }
}
    /// 撮影ボタン押下時に呼ばれる
    
   
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
   
    
    // カメラの設定
    let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
    
        // 撮影
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
        //　撮影が完了時した時に呼ばれる
        func imagePickerController(_ imagePicker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [String : Any]) {
            
            if let pickedImage = info[UIImagePickerControllerOriginalImage]
                as? UIImage {
               
                cameraView.image = pickedImage
                
            }
}
    /// カメラで撮影完了時にフォトライブラリに保存
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            
            // JPEG形式で画像データを取得
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            
            let image = UIImage(data: photoData!)
            
            // フォトライブラリに保存
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
      }
    }
}
