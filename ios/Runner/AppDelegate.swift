import Flutter
import UIKit
import AVKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private var pipController: AVPictureInPictureController?
    private var pipPlayer: AVPlayer?
    private var pipPlayerLayer: AVPlayerLayer?
    private var pipContainerView: UIView?
    private var pipObservation: NSKeyValueObservation?
    private var statusObservation: NSKeyValueObservation?
    private var rateObservation: NSKeyValueObservation?
    private var pipChannel: FlutterMethodChannel?
    private var isRestoring = false
    private var currentVideoUrl: String?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        setupAudioSession()
        
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.movie/pip",
            binaryMessenger: controller.binaryMessenger
        )
        self.pipChannel = channel
        
        channel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            
            switch call.method {
            case "isPipAvailable":
                result(AVPictureInPictureController.isPictureInPictureSupported())
                
            case "preparePip":
                // Pre-create player + PiP controller when video starts
                guard let args = call.arguments as? [String: Any],
                      let urlString = args["url"] as? String else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Missing url", details: nil))
                    return
                }
                self.preparePip(urlString: urlString, result: result)
                
            case "enablePip":
                // Just start PiP (controller already prepared)
                guard let args = call.arguments as? [String: Any],
                      let position = args["position"] as? Int else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Missing position", details: nil))
                    return
                }
                self.startPiP(position: position, result: result)
                
            case "stopPip":
                self.stopPiP()
                result(true)
                
            case "disposePip":
                self.disposePiP()
                result(true)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .moviePlayback)
            try audioSession.setActive(true)
        } catch {
            print("[PiP] Audio session error: \(error)")
        }
    }
    
    // MARK: - Prepare PiP (called when video starts playing)
    
    private func preparePip(urlString: String, result: @escaping FlutterResult) {
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            result(FlutterError(code: "NOT_SUPPORTED", message: "PiP not supported", details: nil))
            return
        }
        
        // If same URL, just reuse existing player
        if urlString == currentVideoUrl && pipController != nil {
            print("[PiP] Reusing existing PiP controller")
            result(true)
            return
        }
        
        print("[PiP] Preparing PiP for new URL...")
        
        // Clean up any previous PiP
        disposePiP()
        
        guard let url = URL(string: urlString) else {
            result(FlutterError(code: "INVALID_URL", message: "Invalid URL", details: nil))
            return
        }
        
        currentVideoUrl = urlString
        setupAudioSession()
        
        // Create player
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        player.allowsExternalPlayback = true
        self.pipPlayer = player
        
        // Create player layer
        let playerLayer = AVPlayerLayer(player: player)
        let screenBounds = UIScreen.main.bounds
        playerLayer.frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.width * 9.0 / 16.0)
        playerLayer.videoGravity = .resizeAspect
        self.pipPlayerLayer = playerLayer
        
        // Container view behind Flutter — hidden until PiP starts
        let containerView = UIView(frame: playerLayer.frame)
        containerView.layer.addSublayer(playerLayer)
        containerView.isHidden = true  // Don't show native player on Flutter screen
        self.window?.rootViewController?.view.insertSubview(containerView, at: 0)
        self.pipContainerView = containerView
        
        // Wait for player to be ready (DON'T play — just wait for readyToPlay)
        statusObservation = playerItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if item.status == .readyToPlay {
                    self.statusObservation?.invalidate()
                    self.statusObservation = nil
                    
                    // Create PiP controller immediately (no need to play)
                    self.createPipController()
                    
                    print("[PiP] Prepared ✅")
                    result(true)
                } else if item.status == .failed {
                    self.statusObservation?.invalidate()
                    self.statusObservation = nil
                    result(FlutterError(code: "PLAYER_FAILED", message: item.error?.localizedDescription ?? "", details: nil))
                }
            }
        }
        
        // Timeout for preparation
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            guard let self = self else { return }
            if self.pipController == nil {
                self.statusObservation?.invalidate()
            }
        }
    }
    
    private func createPipController() {
        guard let playerLayer = self.pipPlayerLayer else { return }
        
        guard let controller = AVPictureInPictureController(playerLayer: playerLayer) else {
            print("[PiP] Failed to create controller")
            return
        }
        
        controller.delegate = self
        // Disable automatic PiP — only allow manual activation via button
        if #available(iOS 14.2, *) {
            controller.canStartPictureInPictureAutomaticallyFromInline = false
        }
        self.pipController = controller
    }
    
    // MARK: - Start PiP (called when user taps PiP button — should be fast)
    
    private func startPiP(position: Int, result: @escaping FlutterResult) {
        guard let player = pipPlayer, let controller = pipController else {
            print("[PiP] Not prepared, cannot start")
            result(FlutterError(code: "NOT_PREPARED", message: "Call preparePip first", details: nil))
            return
        }
        
        isRestoring = false
        
        // Show the container so AVPlayerLayer is active for PiP
        pipContainerView?.isHidden = false
        
        // Seek to current position and play
        let time = CMTime(seconds: Double(position), preferredTimescale: 600)
        player.seek(to: time) { [weak self] _ in
            player.play()
            
            DispatchQueue.main.async {
                if controller.isPictureInPicturePossible {
                    controller.startPictureInPicture()
                    print("[PiP] Started ✅")
                    result(true)
                } else {
                    // Wait briefly for it to become possible
                    self?.pipObservation = controller.observe(\.isPictureInPicturePossible, options: [.new]) { [weak self] ctrl, _ in
                        DispatchQueue.main.async {
                            if ctrl.isPictureInPicturePossible {
                                self?.pipObservation?.invalidate()
                                self?.pipObservation = nil
                                ctrl.startPictureInPicture()
                                print("[PiP] Started (delayed) ✅")
                                result(true)
                            }
                        }
                    }
                    
                    // Timeout
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        if self?.pipObservation != nil {
                            self?.pipObservation?.invalidate()
                            self?.pipObservation = nil
                            result(FlutterError(code: "PIP_TIMEOUT", message: "PiP not possible", details: nil))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Stop PiP (keeps controller alive for reuse)
    
    private func stopPiP() {
        pipObservation?.invalidate()
        pipObservation = nil
        
        if let ctrl = pipController, ctrl.isPictureInPictureActive {
            ctrl.stopPictureInPicture()
        }
        pipPlayer?.pause()
    }
    
    // MARK: - Dispose PiP (full cleanup — when leaving watch screen)
    
    private func disposePiP() {
        pipObservation?.invalidate()
        pipObservation = nil
        statusObservation?.invalidate()
        statusObservation = nil
        rateObservation?.invalidate()
        rateObservation = nil
        
        if let ctrl = pipController {
            ctrl.delegate = nil
            if ctrl.isPictureInPictureActive {
                ctrl.stopPictureInPicture()
            }
        }
        pipController = nil
        
        pipPlayer?.pause()
        pipPlayer?.replaceCurrentItem(with: nil)
        pipPlayer = nil
        
        pipPlayerLayer?.removeFromSuperlayer()
        pipPlayerLayer = nil
        pipContainerView?.removeFromSuperview()
        pipContainerView = nil
        
        currentVideoUrl = nil
        isRestoring = false
    }
    
    // MARK: - Minimize app
    
    private func minimizeApp() {
        // Use performSelector to reliably send app to background
        let selector = NSSelectorFromString("suspend")
        if UIApplication.shared.responds(to: selector) {
            UIApplication.shared.perform(selector)
        }
    }
}

// MARK: - AVPictureInPictureControllerDelegate
extension AppDelegate: AVPictureInPictureControllerDelegate {
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("[PiP] Will start")
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("[PiP] Did start ✅")
        // Minimize app to background
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.minimizeApp()
        }
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("[PiP] Did stop")
        
        // Hide native player container so it doesn't show on Flutter screen
        pipContainerView?.isHidden = true
        
        if !isRestoring {
            let currentPosition = pipPlayer?.currentTime().seconds ?? 0
            pipChannel?.invokeMethod("onPipStopped", arguments: [
                "position": Int(currentPosition)
            ])
        }
        
        // Pause native player but keep controller alive
        pipPlayer?.pause()
        isRestoring = false
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("[PiP] Failed: \(error.localizedDescription)")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        print("[PiP] Restore UI")
        isRestoring = true
        
        let currentPosition = pipPlayer?.currentTime().seconds ?? 0
        pipChannel?.invokeMethod("onPipRestore", arguments: [
            "position": Int(currentPosition)
        ])
        
        completionHandler(true)
    }
}
