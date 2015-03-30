ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = SmartSleep
SmartSleep_FILES = Tweak.xm

SmartSleep_FRAMEWORKS = UIKit
SmartSleep_PRIVATE_FRAMEWORKS  = MediaRemote
SmartSleep_LDFLAGS = -lactivator
SmartSleep_CFLAGS = -Wno-error
include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += settings

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
