//
//  UIToggleButton.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 11/4/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import UIKit

class UIToggleButton: UIButton {

    private var isOn: Bool = false
    private var toggleStateDelegate: UIToggleButtonDelegate?
    
    public var activeText: String = "On"
    public var disabledText: String = "Off"

    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        // switch state
        isOn = bool
        
        // update ui
        let color = bool ? UIColor.blue : UIColor.clear
        let title = bool ? activeText : disabledText
        let titleColor = bool ? UIColor.white : UIColor.blue
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
        
        // call listener
        toggleStateDelegate?.onStateChange(state: isOn)
    }
    
    func setStateChangeListener(_ listener: UIToggleButtonDelegate) {
        self.toggleStateDelegate = listener
    }
    
}

protocol UIToggleButtonDelegate : NSObjectProtocol {
    func onStateChange(state: Bool)
}
