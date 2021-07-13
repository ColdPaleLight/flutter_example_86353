import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UITabBarControllerDelegate {
  var flutterViewControllerA : FlutterViewController?;
  var flutterViewControllerB : FlutterViewController?;
  var flutterViewControllerC : FlutterViewController?;
  var engine : FlutterEngine?;
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    setup();
    return result;
  }
    
  func setup() {
    
    //Prepare FlutterVC A,FlutterVC B and FlutterVC C
    self.flutterViewControllerA = self.window.rootViewController as? FlutterViewController;
    self.engine = self.flutterViewControllerA?.engine;

    self.engine?.viewController = nil;
    self.flutterViewControllerB = FlutterViewController(engine: self.engine!, nibName: nil, bundle: nil);
    
    
    self.engine?.viewController = nil;
    self.flutterViewControllerC = FlutterViewController(engine: self.engine!, nibName: nil, bundle: nil);
    
    self.flutterViewControllerA?.view.addSubview(createButton(text: "Present FlutterVC B", y: 100, action: #selector(presentSecondViewController)));
  }
    
    @objc
    func presentSecondViewController() {

        self.attachToEngine(self.flutterViewControllerB!)
        
        self.flutterViewControllerB?.modalPresentationStyle = .fullScreen;
        
        self.flutterViewControllerA?.present(self.flutterViewControllerB!, animated: true, completion: {
        });
        
        self.flutterViewControllerB?.view.addSubview(createButton(text:"Dismiss FlutterVC B", y:100, action:#selector(dissmissFlutterViewB)));
        self.flutterViewControllerB?.view.addSubview(createButton(text:"Dismiss FlutterVC B and trigger Crash", y:200, action:#selector(dissmissFlutterViewBThenTriggerCrash)));
    }
    

    
    @objc
    func dissmissFlutterViewB() {
        self.attachToEngine(self.flutterViewControllerA!);
        self.flutterViewControllerB?.dismiss(animated: true, completion:nil);
    }
    
    @objc
    func dissmissFlutterViewBThenTriggerCrash() {
        self.attachToEngine(self.flutterViewControllerA!);
        self.flutterViewControllerB?.dismiss(animated: true, completion: {
            // It will trigger crash on raster thread
            self.flutterViewControllerC?.view.backgroundColor = .white;
        });
    }
    
    func attachToEngine(_ viewController: FlutterViewController) {
        let engine = self.engine;
        if engine?.viewController != nil {
            engine?.viewController = nil;
        }
        self.engine?.viewController = viewController;
    }
    
    
    
    func createButton(text:String, y: Int, action: Selector?) -> UIView {
        let view  = UIView();
        view.frame = CGRect(origin: CGPoint(x:0,y:y), size: CGSize(width:300,height:50));
        view.backgroundColor = .red;
        let label = UILabel();
        label.frame = view.bounds;
        label.text = text;
        label.textColor = .black;
        view.addSubview(label);
        let recognizer = UITapGestureRecognizer(target: self, action: action);
        view.addGestureRecognizer(recognizer);
        return view;
    }
}
