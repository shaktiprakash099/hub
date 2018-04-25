//
//  PhotosViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 13/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Photos
import ProgressHUD
class PhotosViewController: UIViewController{
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareCaptionTextView: UITextView!
    @IBOutlet weak var shareImageview: UIImageView!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    @IBOutlet weak var mediaPickCollectionView: UICollectionView!
    var selectedImage: UIImage?
    var assetsFetchResults: PHFetchResult<AnyObject>?
    fileprivate var thumbnailSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.customiseView()
         self.checkPhotoaccessAuthorizationstatus()
       
    }
    
    deinit {
        print("Photos deinitilized")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textViewDidchange()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
      }
    
    func customiseView(){
      
        self.shareButton.layer.cornerRadius = 5;
        self.shareButton.isEnabled = false
        self.shareButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.shareCaptionTextView.delegate = self
        self.removeButton.isEnabled = false
          let itemSize = self.mediaPickCollectionView.frame.size.width / 3
        thumbnailSize = CGSize(width: itemSize - 2, height: itemSize - 2)
    
    }
    
    func checkPhotoaccessAuthorizationstatus(){
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                self.assetsFetchResults = PHAsset.fetchAssets(with: .image, options: fetchOptions) as? PHFetchResult<AnyObject>
             
                DispatchQueue.main.async {
                       self.mediaPickCollectionView.reloadData()
                }
             
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
                self.showerrormessageonGalleryopenRequest()
            }
        }
        
        
        
    }
    
   
    
    @IBAction func RemoveButtonAction(_ sender: Any) {
        self.removeButton.isEnabled = false
        self.performCleanup()
        self.textViewDidchange()
    }
    
    
    func textViewDidchange(){
        guard let photocaption = self.shareCaptionTextView.text, !photocaption.isEmpty
    
        else{
            self.shareButton.isEnabled = false
            self.shareButton.setTitleColor(UIColor.darkGray, for: .normal)
            return
         }
         self.shareButton.isEnabled = true
         self.shareButton.setTitleColor(UIColor.white, for: .normal)
    }
    

    
    
    //MARK: share button
    fileprivate func performCleanup() {
        self.shareCaptionTextView.text = ""
        self.shareImageview.image = UIImage(named: "placeholder")
        self.selectedImage = nil
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        view.endEditing(true)
        if let profileimage = self.selectedImage,let imageData = UIImageJPEGRepresentation(profileimage, 0.8){
            ProgressHUD.show("Uploading...", interaction: false)
            AuthProvider.shareinstance.shareImage(shareimagecaption: self.shareCaptionTextView.text!, imageData: imageData, onSuccessCallback: {
                ProgressHUD.showSuccess("Successfully uploaded")
                self.performCleanup()
                self.tabBarController?.selectedIndex = 0
            }, onErrorCallback: { (error) in
                ProgressHUD.showError(error)
            })
        }
        else{
        ProgressHUD.showError("You have not choosen any image")
        }
    }
    

    func openimagepickerGallery(){
        let pickerController  = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func showerrormessageonGalleryopenRequest(){
        
        let alert =  UIAlertController(title: "Access denied", message: "Sorry,user denied to access their photos,your photos won't be shared without your permission!!Please go to setting and give permission to access your photos to use our app", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go To settings", style: .default) { action in
            
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            
        })
        alert.addAction(UIAlertAction(title: "Cancle", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK : UIimagepicker
extension PhotosViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate{

    
    //MARK:Imagepicker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.shareImageview.image = pic
            self.selectedImage = pic
            self.removeButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    func textViewDidChange(_ textView: UITextView) {
        self.textViewDidchange()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        textView.resignFirstResponder()
        return false
    }
   
}
extension PhotosViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsFetchResults?.count ?? 0
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhAssertMediapickCollectionViewCell", for: indexPath) as! PhAssertMediapickCollectionViewCell
        
      if let assert = self.assetsFetchResults?[indexPath.item] as? PHAsset{
        
        PHImageManager.default().requestImage(for: assert, targetSize: self.thumbnailSize, contentMode: .aspectFit, options: nil, resultHandler: {(image, info)in
            if image != nil {
                cell.mediaPickImageView.image = image
            }
        })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.mediaPickCollectionView.frame.size.width / 3
        return CGSize(width: height - 2, height: height - 2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedimgesize = self.shareImageview.frame
        
        if let assert = self.assetsFetchResults?[indexPath.item] as? PHAsset{
            
            PHImageManager.default().requestImage(for: assert, targetSize:selectedimgesize.size, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
                self.shareImageview.image = image
                self.selectedImage = image
                self.removeButton.isEnabled = true
            })
            
        }
        
    }
}
