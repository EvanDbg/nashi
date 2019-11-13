DEBUG = 0
FINALPACKAGE = 1
ARCHS = armv7 arm64
TARGET = iphone:latest:7.0
THEOS_DEVICE_IP = 192.168.0.103
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = nsforwechat
nsforwechat_FILES = Tweak.xm $(wildcard *.m)

include $(THEOS_MAKE_PATH)/tweak.mk


after-install::
	install.exec "killall -9 WeChat"