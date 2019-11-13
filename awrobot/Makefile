DEBUG = 0
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.43.7
TARGET = iphone:latest:7.0
ARCHS = armv7 arm64
include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = AwRobot
AwRobot_FILES = $(wildcard *.m) $(wildcard Page/*.m)
AwRobot_FRAMEWORKS = UIKit CoreGraphics
AwRobot_LIBRARIES = rocketbootstrap

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"AwRobot\"" || true
	install.exec "su mobile -c uicache"