# Dew Point Fan Application
## Overview
This is the companion app for the [Dew Point Fan project](https://github.com/aluedtke7/dew-point-fan).
The main purpose is to show the current temperature and humidity values together with the calculated
dew points for inside and outside. And most important: is the fan on or off!

In addition, it's possible to override the fan status with this app to either switch it on or off. 

## Build your own
You need to set the environment variable `DEW_POINT_FAN_URL` to the ip address of your
own dew point fan controller. So, to build your own Android app run:

    flutter build apk --dart-define=DEW_POINT_FAN_URL=IP_ADDRESS_OF_DEW_POINT_FAN_CONTROLLER:8080
