//
//  DocumentViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import Quartz

class DocumentViewController: NSViewController {
    
    @IBOutlet weak var bugsTableView: NSTableView!
    
    @IBOutlet weak var bugTitleView: NSTextField!
    
    @IBOutlet weak var bugRating: EDStarRating!
    
    @IBOutlet weak var bugImageView: NSImageView!
    
    @IBOutlet weak var deleteButton: NSButton!
    
    @IBOutlet weak var changePicButton: NSButton!
    
    @IBOutlet weak var nameLabel: NSTextField!
    
    @IBOutlet weak var ratingLabel: NSTextField!
    
    var bugs = [ScaryBugDoc]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func setupSampleBugs() {
        let bug1 = ScaryBugDoc(title: "Potato Bug", rating: 4.0,
                               thumbImage:NSImage(named: "potatoBugThumb"), fullImage:NSImage(named: "potatoBug"))
        let bug2 = ScaryBugDoc(title: "House Centipede", rating: 3.0,
                               thumbImage:NSImage(named: "centipedeThumb"), fullImage:NSImage(named: "centipede"))
        let bug3 = ScaryBugDoc(title: "Wolf Spider", rating: 5.0,
                               thumbImage:NSImage(named: "wolfSpiderThumb"), fullImage:NSImage(named: "wolfSpider"))
        let bug4 = ScaryBugDoc(title: "Lady Bug", rating: 1.0,
                               thumbImage:NSImage(named: "ladybugThumb"), fullImage:NSImage(named: "ladybug"))
        bugs = [bug1, bug2, bug3, bug4]
    }
    
    func selectedBugDoc() -> ScaryBugDoc? {
        let selectedRow = self.bugsTableView.selectedRow;
        if selectedRow >= 0 && selectedRow < self.bugs.count {
            return self.bugs[selectedRow]
        }
        return nil
    }
    
    func updateDetailInfo(doc: ScaryBugDoc?) {
        var title = ""
        var image: NSImage?
        var rating = 0.0
        if let scaryBugDoc = doc {
            title = scaryBugDoc.data.title
            image = scaryBugDoc.fullImage
            rating = scaryBugDoc.data.rating
        }
        self.bugTitleView.stringValue = title
        self.bugImageView.image = image
        self.bugRating.rating = Float(rating)
    }
    
    func reloadSelectedBugRow() {
        let indexSet = NSIndexSet(index: self.bugsTableView.selectedRow);
        let columnSet = NSIndexSet(index: 0);
        self.bugsTableView.reloadDataForRowIndexes(indexSet, columnIndexes:columnSet);
    }
    
    func saveBugs() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.bugs);
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "bugs");
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    override func loadView() {
        super.loadView()
        self.bugRating.starHighlightedImage = NSImage(named:"shockedface2_full")
        self.bugRating.starImage = NSImage(named:"shockedface2_empty")
        self.bugRating.delegate = self as EDStarRatingProtocol;
        self.bugRating.maxRating = 5
        self.bugRating.horizontalMargin = 12
        self.bugRating.editable = false
        self.bugRating.displayMode = UInt(EDStarRatingDisplayFull)
        self.bugRating.rating = Float(0.0)
    }
    
}

// MARK: - NSTableViewDataSource
extension DocumentViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.bugs.count;
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // 1
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView;
        // 2
        if tableColumn!.identifier == "BugColumn" {
            // 3
            let bugDoc = self.bugs[row]
            cellView.imageView!.image = bugDoc.thumbImage
            cellView.textField!.stringValue = bugDoc.data.title
            return cellView
        }
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension DocumentViewController: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedDoc = selectedBugDoc();
        updateDetailInfo(selectedDoc);
        let enabled = (selectedDoc != nil);
        deleteButton.enabled = enabled;
        changePicButton.enabled = enabled;
        bugRating.editable = enabled;
        bugTitleView.enabled = enabled;
        let hidden = (selectedDoc == nil);
        nameLabel.hidden = hidden;
        bugTitleView.hidden = hidden;
        ratingLabel.hidden = hidden;
        bugRating.hidden = hidden;
        bugImageView.hidden = hidden;
        changePicButton.hidden = hidden;
    }
    
}

// MARK: -EDStarRatingProtocol
extension DocumentViewController: EDStarRatingProtocol {
    
    func starsSelectionChanged(control: EDStarRating!, rating: Float) {
        if let selectedDoc = selectedBugDoc() {
            selectedDoc.data.rating = Double(control.rating)
        }
    }
}


// MARK: - IBActions
extension DocumentViewController {
    
    @IBAction func bugTitleDidEndEdit(sender: AnyObject) {
        if let selectedDoc = selectedBugDoc() {
            selectedDoc.data.title = self.bugTitleView.stringValue;
            reloadSelectedBugRow();
        }
    }
    
    @IBAction func changePicture(sender: AnyObject) {
        if (selectedBugDoc() != nil) {
            IKPictureTaker().beginPictureTakerSheetForWindow(self.view.window, withDelegate: self, didEndSelector: #selector(DocumentViewController.pictureTakerDidEnd(_:returnCode:contextInfo:)), contextInfo: nil);
        }
    }
    
    func pictureTakerDidEnd(picker: IKPictureTaker, returnCode: NSInteger, contextInfo: UnsafePointer<Void>) {
        let image = picker.outputImage()
        if image != nil && returnCode == NSModalResponseOK {
            self.bugImageView.image = image;
            if let selectedDoc = selectedBugDoc() {
                selectedDoc.fullImage = image;
                selectedDoc.thumbImage = image.imageByScalingAndCroppingForSize(CGSize(width: 44, height: 44));
                reloadSelectedBugRow();
            }
        }
    }
    
    @IBAction func resetData(sender: AnyObject) {
        setupSampleBugs();
        updateDetailInfo(nil);
        bugsTableView.reloadData();
    }
    
    @IBAction func addBug(sender: AnyObject) {
        // 1. 使用默认值创建一个新的ScaryBugDoc实例
        let newDoc = ScaryBugDoc(title: "New Bug", rating: 0.0, thumbImage: nil, fullImage: nil);
        
        // 2. 将该实例添加到model 数组
        self.bugs.append(newDoc);
        
        let newRowIndex = self.bugs.count - 1;
        
        // 3.向table view插入新行
        self.bugsTableView.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withAnimation: NSTableViewAnimationOptions.EffectGap);
        
        // 4. 选中并滚动到新行
        self.bugsTableView.selectRowIndexes(NSIndexSet(index: newRowIndex), byExtendingSelection:false);
        self.bugsTableView.scrollRowToVisible(newRowIndex);
    }
    
    
    @IBAction func deleteBug(sender: AnyObject) {
        
        // 1. Get selected doc
        if (selectedBugDoc() != nil) {
            
            // 2. Remove the bug from the model
            let nowRow = self.bugsTableView.selectedRow;
            self.bugs.removeAtIndex(nowRow)
            
            // 3. Remove the selected row from the table view
            self.bugsTableView.removeRowsAtIndexes(NSIndexSet(index:self.bugsTableView.selectedRow),withAnimation: NSTableViewAnimationOptions.SlideRight);
            
            
            // 4. 清理model
            updateDetailInfo(nil);
            
            // 5. 选中下一行并滚动到新行
            var newSelectedRow = nowRow;
            if(self.bugsTableView.numberOfRows <= nowRow){
                newSelectedRow = self.bugsTableView.numberOfRows - 1;
            }
            self.bugsTableView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
            self.bugsTableView.scrollRowToVisible(newSelectedRow);
            
        }
    }
}




