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
    
    private func initButton() {
        // set initial state
        activateButton(bool: isOn)
        // add press handler
        addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        // switch state
        isOn = bool
        
        // update ui
        let title = bool ? activeText : disabledText
        
        setTitle(title, for: .normal)
        
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
