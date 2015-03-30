ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = SmartSleep
SmartSleep_FILES = SmartSleep.mm
SmartSleep_INSTALL_PATH = /Library/PreferenceBundles
SmartSleep_FRAMEWORKS = UIKit
SmartSleep_PRIVATE_FRAMEWORKS = Preferences Social

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SmartSleep.plist$(ECHO_END)

include $(THEOS_MAKE_PATH)/aggregate.mk
