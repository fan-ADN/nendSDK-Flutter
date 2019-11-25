#import "NendPlugin.h"
#import <nend_plugin/nend_plugin-Swift.h>

@implementation NendPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftNendPlugin registerWithRegistrar:registrar];
}
@end
