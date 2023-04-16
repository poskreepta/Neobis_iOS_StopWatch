//
//  ViewController.swift
//  StopWatch
//
//  Created by poskreepta on 06.04.23.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "timer")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timerStopwatchLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 70)
        label.font = UIFont.boldSystemFont(ofSize: 65)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var stopButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var pauseButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var startButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 35
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let timerSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Timer", "Stopwatch"])
        segmentedControl.addTarget(self, action: #selector(modeDidChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    
    private let stopwatchPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var selectedHours: Int = 0
    var selectedMinutes: Int = 0
    var selectedSeconds: Int = 0
    
    
    var isStopButtonSelected = false
    var isPauseButtonSelected = false
    var isStartButtonSelected = false
    
    
    //Adjusting timer
    var timerStopwatchModel = TimerStopwatchModel()
    var timer: Timer = Timer()
    var isTimerRunning: Bool = false
    var secondsCountTimer: Int = 0
    var pickedTimeForStopwatch: Int = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        stopwatchPicker.isHidden = true
        
        stopwatchPicker.delegate = self
        stopwatchPicker.dataSource = self
        
        timerSegmentedControl.selectedSegmentIndex = 0
        
        setupViews()
        setupConstraints()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            imageLogo.isHidden = true
        } else {
            imageLogo.isHidden = false
        }
    }
    
    
    //MARK: - Set Up Views
    
    func setupViews() {
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 2/255, alpha: 1)
        view.addSubview(imageLogo)
        
        //        SegmentedContorol view setup
        view.addSubview(timerSegmentedControl)
        
        //        Label view setup
        view.addSubview(timerStopwatchLabel)
        
        //        PickerView setup
        view.addSubview(stopwatchPicker)
        
        //        Buttons setup and the configurations
        stopButton.configuration = createButtonConfiguration(image: Const.stopButtonImage)
        pauseButton.configuration = createButtonConfiguration(image: Const.pauseButtonImage)
        startButton.configuration = createButtonConfiguration(image: Const.startButtonImage)
        
        //        StackView setup
        buttonsStackView.addArrangedSubview(stopButton)
        buttonsStackView.addArrangedSubview(pauseButton)
        buttonsStackView.addArrangedSubview(startButton)
        view.addSubview(buttonsStackView)
        
        
    }
    
    @objc func modeDidChanged(_ segmentedControl: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            stopwatchPicker.isHidden = true
            stopButtonTapped()
        case 1:
            stopwatchPicker.isHidden = false
            stopButtonTapped()
            
        default:
            break
        }
        
    }
    
    //MARK: - Configure Buttons Functionality (Stop, Pause, Start)
    func createButtonConfiguration(image: UIImageView) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        if let imageButton = image.image {
            let tintImage = imageButton.withTintColor(.black, renderingMode: .alwaysOriginal)
            configuration.background.image = tintImage
        }
        configuration.background.imageContentMode = .scaleAspectFit
        return configuration
    }
    
    @objc func stopButtonTapped() {
        stopButton.configuration = createButtonConfiguration(image: Const.stopButtonTappedImage)
        pauseButton.configuration = createButtonConfiguration(image: Const.pauseButtonImage)
        startButton.configuration = createButtonConfiguration(image: Const.startButtonImage)
        timer.invalidate()
        secondsCountTimer = 0
        timerStopwatchLabel.text = timerStopwatchModel.secondsToHoursMinutesSecondsString(secondsCountTimer)
        isTimerRunning = false
        
    }
    
    @objc func pauseButtonTapped() {
        stopButton.configuration = createButtonConfiguration(image: Const.stopButtonImage)
        pauseButton.configuration = createButtonConfiguration(image: Const.pauseButtonTappedImage)
        startButton.configuration = createButtonConfiguration(image: Const.startButtonImage)
        timer.invalidate()
        isTimerRunning = false
        
    }
    
    @objc func startButtonTapped() {
        if !isTimerRunning {
            stopButton.configuration = createButtonConfiguration(image: Const.stopButtonImage)
            pauseButton.configuration = createButtonConfiguration(image: Const.pauseButtonImage)
            startButton.configuration = createButtonConfiguration(image: Const.startButtonTapeedImage)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerStarted), userInfo: nil, repeats: true)
            isTimerRunning = true
            
        }
        
    }
    
    @objc func timerStarted() {
        timerCounter(dependingOn: timerSegmentedControl)
    }
    
    @objc func timerCounter(dependingOn segmentedControl: UISegmentedControl) -> Void {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            secondsCountTimer += 1
            let timeString = timerStopwatchModel.secondsToHoursMinutesSecondsString(secondsCountTimer)
            timerStopwatchLabel.text = timeString
        case 1:
            if pickedTimeForStopwatch > 0 { //from the picked time with pikerView
                pickedTimeForStopwatch -= 1
                stopwatchPicker.isHidden = false
                let timeString = timerStopwatchModel.secondsToHoursMinutesSecondsString(pickedTimeForStopwatch)
                timerStopwatchLabel.text = timeString
            }
        default:
            break
        }
        
    }
    
    
    //MARK: - Set Up Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     imageLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.03),
                                     imageLogo.heightAnchor.constraint(equalToConstant: 70),
                                     imageLogo.widthAnchor.constraint(equalToConstant: 70)])
        
        NSLayoutConstraint.activate([timerSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     timerSegmentedControl.topAnchor.constraint(equalToSystemSpacingBelow: imageLogo.bottomAnchor, multiplier: 2),
                                     timerSegmentedControl.heightAnchor.constraint(equalToConstant: 30),
                                     timerSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)])
        
        NSLayoutConstraint.activate([timerStopwatchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     timerStopwatchLabel.topAnchor.constraint(equalTo: timerSegmentedControl.bottomAnchor, constant: view.frame.height * 0.07),
                                     timerStopwatchLabel.heightAnchor.constraint(equalToConstant: 70),
                                     timerStopwatchLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)])
        
        NSLayoutConstraint.activate([stopwatchPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     stopwatchPicker.topAnchor.constraint(equalTo: timerStopwatchLabel.bottomAnchor, constant: view.frame.height * 0),
                                     stopwatchPicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)])
        
        
        NSLayoutConstraint.activate([buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
                                     buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
                                     buttonsStackView.topAnchor.constraint(equalTo: stopwatchPicker.bottomAnchor, constant: 80),
                                     buttonsStackView.heightAnchor.constraint(equalToConstant: 80)])
    }
    
}



//MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return timerStopwatchModel.hoursDigit.count
        case 1:
            return timerStopwatchModel.minutesDigit.count
        case 2:
            return timerStopwatchModel.secondsDigit.count
        default:
            return 0
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        
        switch component {
        case 0:
            selectedHours = timerStopwatchModel.hoursDigit[row]
        case 1:
            selectedMinutes = timerStopwatchModel.minutesDigit[row]
        case 2:
            selectedSeconds = timerStopwatchModel.secondsDigit[row]
            
        default:
            break
        }
        
        // Updating the timeLabel according to picked time
        timerStopwatchLabel.text = timerStopwatchModel.makeTimeString(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSeconds)
        pickedTimeForStopwatch = timerStopwatchModel.hoursMinutesSecondsToSeconds(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSeconds)
    }
    
}

