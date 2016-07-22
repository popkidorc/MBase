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







