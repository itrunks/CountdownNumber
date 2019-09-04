//
//  GTViewController.swift
//  Algorithm
//
//  Created by trioangle on 03/09/19.
//  Copyright © 2019 Trioangle. All rights reserved.
//

import UIKit

class GTViewController: UIViewController {
    
    
    
    //IBOutlets
    @IBOutlet weak var btn_rules: UIBarButtonItem!
    @IBOutlet weak var btn_reset: UIBarButtonItem!
    @IBOutlet weak var txtField_firstBox: UITextField!
    @IBOutlet weak var txtField_secondBox: UITextField!
    @IBOutlet weak var txtField_thirdBox: UITextField!
    @IBOutlet weak var txtField_fourthBox: UITextField!
    @IBOutlet weak var txtField_fifthBox: UITextField!
    @IBOutlet weak var txtField_sixBox: UITextField!
    @IBOutlet weak var btn_start: RoundButton!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var lbl_findNumber: UILabel!
    
    @IBOutlet weak var btn_showResult: UIButton!
    var dataSource = GTDataSource()//GTDatasource class handle both Pickerview datasource and delegate
    var pickerView = UIPickerView()
    var result:Result?
    private var midNumber:Int?
    private var index:Int = 0
    private var maxLargeNumber:Int = 4
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 30
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer = Timer()
    
    private var resultViewModel = GTResultViewModel()
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    var numberArray:[Int] = []//[50, 8, 3, 7, 2, 10]
    let randomNumber = 556 //Int.random(in: 1...999)
    
    lazy var segmentedControl:UISegmentedControl = {
        
        let items = ["Largest" , "Smallest"]
        var segmentedControl = UISegmentedControl(items : items)
        segmentedControl.center = toolBar.center
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.backgroundColor = .white
        segmentedControl.tintColor = .black
        return segmentedControl
        //
        
    }()
    
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissPicker))
        toolBar.setItems([cancelButton, spaceButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonUISetup()
        pickerViewUISetup()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    func buttonUISetup(){
        self.btn_showResult.isHidden = true
        self.btn_start.isEnabled = false
        self.startButtonEnabled(bgColor: .lightGray, titleColor: .darkGray)
    }
    
    //Mark: App enter to forceground
    @objc func appWillEnterForeground() {
        timerInit()
        // self.resumeAnimation()
    }
    
    //Mark: App enter to background
    @objc func appDidEnterBackground() {
        //...
        
        // self.pauseAnimation()
        timer.invalidate()
        
    }
    
    private func pauseAnimation(){
        let pausedTime = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        timeLeftShapeLayer.speed = 0.0
        timeLeftShapeLayer.timeOffset = pausedTime
    }
    
    private func resumeAnimation(){
        
        let pausedTime = timeLeftShapeLayer.timeOffset
        timeLeftShapeLayer.speed = 1.0
        timeLeftShapeLayer.timeOffset = 0.0
        timeLeftShapeLayer.beginTime = 0.0
        let timeSincePause = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        timeLeftShapeLayer.beginTime = timeSincePause
    }
    
    //Pickerview UI configuration
    private func pickerViewUISetup(){
        pickerView.delegate = dataSource
        pickerView.dataSource = dataSource
        dataSource.delegate = self
        for textField in self.textFields{
            textField.inputView = pickerView
            textField.inputAccessoryView = toolBar
        }
        
        //txtField_firstBox.inputView = pickerView
        dataSource.segmentedControl = self.segmentedControl
        toolBar.addSubview(segmentedControl)
    }
    
    //MARK:- Dismiss Picker
    @objc  func dismissPicker(){
        self.view.endEditing(true)
    }
    
    //MARK:Game Rules
    @IBAction func openGameRules(_ sender: Any) {
        
    }
    
    //MARK:- Segment Control Selection
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            self.pickerView.reloadAllComponents()
        case 1:
            self.pickerView.reloadAllComponents()
        default:
            break
        }
    }
    
    private func startGame(){
        // Do any additional setup after loading the view.
        resultViewModel.delegate = self
        //print("random number \(randomNumber.getLargeRandomNumber())")
        // let list = [25, 50, 100, 25, 5, 7]
        for integer in numberArray {
            var runList = numberArray
            runList = runList.filter{$0 != integer}
            let findNumber = Int(self.lbl_findNumber.text!)
            resultViewModel.getResult(numbers: runList, midNumber: integer, target: findNumber!)
        }
    }
    
    private func initializeUI(){
        //view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        
        drawBgShape()
        drawTimeLeftShape()
        addTimeLabel()
        // here you define the fromValue, toValue and duration of your animation
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = 30
        // add the animation to your timeLeftShapeLayer
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        timerInit()
    }
    
    private func timerInit(){
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    //MARK: Draw circle background shape layer
    func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.height - 150  ), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.lightGray.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
    }
    
    //MARK: Draw circle countdown seconds layer
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.height - 150  ), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.red.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    //MARK: Create time seconds label
    func addTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.height - 175, width: 100, height: 50))
        timeLabel.textAlignment = .center
        timeLabel.text = timeLeft.time
        view.addSubview(timeLabel)
    }
    
    
    //Update seconds when user click to start button, every user have 30 sec on each play
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = timeLeft.time
            
        } else {
            self.btn_reset.isEnabled = true
            timeLabel.text = "Time up"//"00:00"//"Game Over"
            timer.invalidate()
            self.btn_showResult.isHidden = false
            self.btn_start.isEnabled = false
        }
    }
    
    //MARK:- Start
    @IBAction func startGameAction(_ sender: Any) {
        self.btn_reset.isEnabled = false
        self.btn_start.isEnabled = false
        self.startButtonEnabled(bgColor: .lightGray, titleColor: .darkGray)
        self.timeLabel.text = " "
        for textField in textFields {
            let a:Int? = Int(textField.text!)
            numberArray.append(a!)
        }
        let randomInt = Int.random(in: 1...999)
        self.lbl_findNumber.text = "\(randomInt)"
        DispatchQueue.main.async {
             self.initializeUI()
        }
       
        startGame()
    }
    
    //MARK:- Show Result
    @IBAction func showResult(_ sender: Any) {
        var resultValue:String?
        if result == nil{
            resultValue = "Numbers aren't random generate so for may select wrong digits to play"
        }else{
            resultValue = "\(self.midNumber ?? 0)" + (self.result?.output!)!
        }
        
        
        let alert = UIAlertController(title: "Result", message: resultValue, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        // action
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Reset
    @IBAction func reset(_ sender: Any) {
        self.lbl_findNumber.text = "0"
        self.btn_showResult.isHidden = true
        timeLeft = 30
        self.timeLabel.text = "00:30"
        //timerInit()
        timeLeftShapeLayer.strokeColor = UIColor.clear.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        for textField in self.textFields{
            textField.text = ""
        }
    }
    
    func startButtonEnabled(bgColor:UIColor, titleColor:UIColor){
        self.btn_start.backgroundColor = bgColor
        self.btn_start.setTitleColor(titleColor, for: .normal)
    }
    
}

extension GTViewController: DataSourceDelegate{
    func arrayResult(selectdigits: Int) {
        let current = self.view.getSelectedTextField()
        current?.text = "\(selectdigits)"
        
        for textField in self.textFields{
            if !(textField.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty ?? false){
                self.btn_start.isEnabled = true
                self.startButtonEnabled(bgColor: .red, titleColor: .white)
            }else{
                self.startButtonEnabled(bgColor: .lightGray, titleColor: .darkGray)
                self.btn_start.isEnabled = false
                break
            }
        }
    }
}

extension GTViewController: ResultDelegate{
    func resultWithCompeletion(_ value: Result, midNumber: Int) {
        self.midNumber = midNumber
        self.result = value
        print("T##items: Any...##Any \(value.output!)")
        
    }
}


