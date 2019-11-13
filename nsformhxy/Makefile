DEBUG = 0
FINALPACKAGE = 1
ARCHS = armv7 arm64
TARGET = iPhone:latest:7.0
THEOS_DEVICE_IP = 192.168.43.7
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = nsformhxy
nsformhxy_FILES = Tweak.xm $(wildcard *.m) $(wildcard *.mm) $(wildcard lua/*.c)
nsformhxy_CFLAGS = -I ./lua -Wno-deprecated-declarations -Wno-overloaded-virtual
nsformhxy_LIBRARIES = rocketbootstrap MobileGestalt
nsformhxy_FRAMEWORKS = UIKit Foundation OpenGLES CoreMedia AVFoundation AssetsLibrary
nsformhxy_PRIVATE_FRAMEWORKS = TesseractOCR opencv2
nsformhxy_LDFLAGS = -lstdc++.6.0.9 -lsimulatetouch -lc -lc++
nsformhxy_OBJ_FILES = lib/libjpeg.a

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/nsfiles/mhxy/ui$(ECHO_END)
	$(ECHO_NOTHING)cp -r $(wildcard ui/*.png) $(THEOS_STAGING_DIR)/nsfiles/mhxy/ui$(ECHO_END)
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/nsfiles/mhxy/sp$(ECHO_END)
	$(ECHO_NOTHING)cp -r $(wildcard script/*.lua) $(THEOS_STAGING_DIR)/nsfiles/mhxy/sp$(ECHO_END)
	$(ECHO_NOTHING)cp -r $(wildcard script/*.sns) $(THEOS_STAGING_DIR)/nsfiles/mhxy/sp$(ECHO_END)
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/nsfiles/mhxy/tessdata$(ECHO_END)
	$(ECHO_NOTHING)cp -r $(wildcard tessdata/*.traineddata) $(THEOS_STAGING_DIR)/nsfiles/mhxy/tessdata$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
	#install.exec "killall -9 client"