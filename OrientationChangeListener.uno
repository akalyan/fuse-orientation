using Uno;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

[Require("Xcode.Framework","CoreMotion.framework")]
[Require("Source.Include", "CoreMotion/CoreMotion.h")]

[UXGlobalModule]
public class OrientationChangeListener : NativeEventEmitterModule
{
    static readonly OrientationChangeListener _instance;
    private string _currentOrientation;

    public OrientationChangeListener() : base(false, "orientationChanged")
    {
        // Make sure we're only initializing the module once
        if (_instance != null) return;

        _instance = this;
        _currentOrientation = "";
        Resource.SetGlobalKey(_instance, "OrientationChangeListener");
        AddMember(new NativeFunction("subscribe", (NativeCallback)subscribe));
    }

    void OrientationCallback(string newOrientation)
    {
      if (newOrientation != _currentOrientation) {
        _currentOrientation = newOrientation;
        Emit("orientationChanged", newOrientation);
      }
    }

    object subscribe(Context c, object[] args)
    {
      Subscribe(OrientationCallback);
      return null;
    }

    [Foreign(Language.ObjC)]
    public static extern(iOS) void Subscribe(Action<string> callback)
    @{
      CMMotionManager *cm=[[CMMotionManager alloc] init];
      cm.deviceMotionUpdateInterval = 0.2f;

      [cm startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                              withHandler:^(CMDeviceMotion *data, NSError *error) {

        if (fabs(data.gravity.x) > fabs(data.gravity.y)) {
          if (data.gravity.x >= 0) {
            callback(@"landscape_left");
          } else {
            callback(@"landscape_right");
          }
        } else {
          if (data.gravity.y >= 0) {
            callback(@"portrait_down");
          } else {
            callback(@"portrait_up");
          }
        }

      }];
    @}

    public static extern(!iOS) void Subscribe(Action<string> callback)
    {
      debug_log("Orientation updates not available");
    }
}
