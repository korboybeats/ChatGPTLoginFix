
TARGET := iphone:clang:16.5:14.0
INSTALL_TARGET_PROCESSES = MobileSafari


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ChatGPTLoginFix

ChatGPTLoginFix_FILES = Tweak.x
ChatGPTLoginFix_CFLAGS = -fobjc-arc
ChatGPTLoginFix_FRAMEWORKS = UIKit WebKit

include $(THEOS_MAKE_PATH)/tweak.mk
