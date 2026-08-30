# Dew Point Fan Application
## Overview
This is the companion app for the [Dew Point Fan controller](https://github.com/aluedtke7/dew-point-fan) and for the 
[Dew Point Fan Bluetooth controller](https://github.com/aluedtke7/dew-point-fan-bt). 
The main purpose is to show the current temperature and humidity values together with the calculated
dew points for inside and outside. And most important: is the fan on or off!

In addition, it's possible to override the fan status with this app to either switch it on or off. 

## Build your own
The address of your dew point fan controller can be set at runtime, so no special build is
required: open the overflow menu, choose *Settings* and enter host and port of your own
controller (e.g. `192.168.1.100:8080`). The value is stored on the device and used from
then on.

Optionally you can compile a default address into the app via `--dart-define`. It is used
until a URL is entered in the settings dialog, which always takes precedence:

    flutter build apk --dart-define=DEW_POINT_FAN_URL=IP_ADDRESS_OF_DEW_POINT_FAN_CONTROLLER:8080

Without either of them, the app falls back to `localhost:8080`.
