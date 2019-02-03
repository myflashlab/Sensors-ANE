# Sensors ANE for Android+iOS
ANE for accessing the accelerometer and gyroscope sensors on Android and iOS 

**Main Features:**
* Supporting ACCELEROMETER, USER_ACCELEROMETER, and GYROSCOPE
* Controlling the report delay on Android.

[find the latest **asdoc** for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/sensors/package-detail.html)

# AIR Usage
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/Sensors-ANE/blob/master/AIR/src/Main.as).

```actionscript
import com.myflashlab.air.extensions.sensors.*;

// initialize the ANE
Sensors.init();

// applies to Android only. On iOS you can't control the delay
Sensors.setSensorDelay(Sensors.SENSOR_DELAY_NORMAL);

// add the kind of sensor you need: ACCELEROMETER, USER_ACCELEROMETER, and GYROSCOPE
Sensors.listener.addEventListener(SensorsEvents.ACCELEROMETER, onAccelerometer);

function onAccelerometer(e:SensorsEvents):void
{
	trace("onAccelerometer: " + e.x, e.y, e.z);
}

/*
	for performance reasons, When you don't need the sensors in your app, try 
	unregistering them:

	Sensors.listener.removeEventListener(SensorsEvents.ACCELEROMETER, onAccelerometer);
*/
```

# Air .xml manifest
```xml
<!--
Embedding the ANE:
-->
  <extensions>
	<extensionID>com.myflashlab.air.extensions.sensors</extensionID>
	
	<!-- dependency ANEs https://github.com/myflashlab/common-dependencies-ANE -->
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
  </extensions>
-->
```

# Requirements
* Android API 19+
* iOS SDK 8.0+
* AIR SDK 31.0+

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Premium Support #
[![Premium Support package](https://www.myflashlabs.com/wp-content/uploads/2016/06/professional-support.jpg)](https://www.myflashlabs.com/product/myflashlabs-support/)
If you are an [active MyFlashLabs club member](https://www.myflashlabs.com/product/myflashlabs-club-membership/), you will have access to our private and secure support ticket system for all our ANEs. Even if you are not a member, you can still receive premium help if you purchase the [premium support package](https://www.myflashlabs.com/product/myflashlabs-support/).