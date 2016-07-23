//
//  DocTreeInfoViewController+IBAction.swift
//  MBase
//
//  Created by sunjie on 16/7/23.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import Quartz

extension DocTreeInfoViewController {
    
    @IBAction func changPicture(sender: AnyObject) {
        if docTreeInfoData != nil {
            IKPictureTaker().beginPictureTakerSheetForWindow(self.view.window, withDelegate: self, didEndSelector: #selector(DocTreeInfoViewController.pictureTakerDidEnd(_:returnCode:contextInfo:)), contextInfo: nil);
        }
    }
    
    func pictureTakerDidEnd(picker: IKPictureTaker, returnCode: NSInteger, contextInfo: UnsafePointer<Void>) {
        let image = picker.outputImage()
        if image != nil && returnCode == NSModalResponseOK {
            self.imageView.image = image;
            self.docTreeInfoData?.image = image;
//            if let selectedDoc = selectedBugDoc() {
//                selectedDoc.fullImage = image;
//                selectedDoc.thumbImage = image.imageByScalingAndCroppingForSize(CGSize(width: 44, height: 44));
//                reloadSelectedBugRow();
//            }
        }
    }
    
}
