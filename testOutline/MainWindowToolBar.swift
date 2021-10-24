import AppKit

extension MainWindowController {
    
    @IBAction func appearanceSelection(_ sender: NSSegmentedControl) {
        let appearance: NSAppearance.Name = sender.selectedSegment == 0 ? .aqua : .darkAqua
        window?.appearance = NSAppearance(named: appearance)
    }
    
}

