//
//  MainWindowController.swift
//  testOutline
//
//  Created by thierryH24 on 25/07/2021.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    enum ListeOperationsDisplayProperty: String {
        case mode
        case date
        case category
        case comment
    }

    @IBOutlet weak var testOutlineView: NSOutlineView!
    
    var feeds = [Datas]()
    let dateFormatter = DateFormatter()
    
    override var windowNibName: NSNib.Name? {
        return  "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        dateFormatter.dateStyle = .short
        
        feedList("Feeds")
        
        self.testOutlineView.intercellSpacing = NSSize(width: 0, height: 10)
        self.testOutlineView.selectionHighlightStyle = .regular
//        self.outlineView?.usesAutomaticRowHeights = true
               
        self.testOutlineView.autosaveExpandedItems = false
        testOutlineView.reloadData()
        self.testOutlineView.autosaveExpandedItems = true
        
        self.reloadData(false, true)
    }
    
    func feedList(_ fileName: String) {
        
        let url = Bundle.main.url(forResource: fileName, withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        feeds = try! data.decoded()
    }
    
    func reloadData(_ expand: Bool = false,_ auto: Bool = false) {
        
        DispatchQueue.main.async {
            self.testOutlineView.autosaveExpandedItems = false
            self.testOutlineView.reloadData()
            self.testOutlineView.autosaveExpandedItems = auto

            if expand == true {
                self.testOutlineView.expandItem(nil, expandChildren: true)
                return
            }
            
            if self.testOutlineView.autosaveExpandedItems,
               let autosaveName = self.testOutlineView.autosaveName,
               let persistentObjects = UserDefaults.standard.array(forKey: "NSOutlineView Items \(autosaveName)"),
               let itemIds = persistentObjects as? [String] {
                let items = itemIds.sorted{ $0 < $1}
                items.forEach {
                    let item = self.testOutlineView.dataSource?.outlineView?(self.testOutlineView, itemForPersistentObject: $0)
                    if let item = item as? Datas {
                        self.testOutlineView.expandItem(item)
                    }
//                    if let item = item as? GroupedMonthOperations {
//                        self.outlineListView.expandItem(item)
//                    }
                }
            }
        }
    }
    
    override func keyDown(with theEvent: NSEvent) {
      interpretKeyEvents([theEvent])
    }

    override func deleteBackward(_ sender: Any?) {
        //1
        let selectedRow = testOutlineView.selectedRow
        guard selectedRow != -1 else { return }
        
        testOutlineView.beginUpdates()
        if let item = testOutlineView.item(atRow: selectedRow) {
            
            if let item = item as? Datas {
                if let index = self.feeds.firstIndex( where: {$0.name == item.name} ) {
                    self.feeds.remove(at: index)
                    testOutlineView.removeItems(at: IndexSet(integer: selectedRow), inParent: nil, withAnimation: .slideLeft)
                }
            } else if let item = item as? Children {
                for feed in self.feeds {
                    let feed = feed
                    if let index = feed.children.firstIndex( where: {$0.mode == item.mode} ) {
                        feed.children.remove(at: index)
                        testOutlineView.removeItems(at: IndexSet(integer: index), inParent: feed, withAnimation: .slideLeft)
                    }
                }
            }
        }
        testOutlineView.endUpdates()
    }
}

// MARK: - KSHeaderCellView
final class KSHeaderCellView: NSTableCellView {
    
    var fillColor = NSColor.orange
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let bPath = NSBezierPath(rect: dirtyRect)
        fillColor.set()
        bPath.fill()
    }
}


