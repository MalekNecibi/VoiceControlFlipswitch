#import <Flipswitch/FSSwitchDataSource.h>
#import <Flipswitch/FSSwitchPanel.h>
#import <Foundation/NSUserDefaults+Private.h>

static NSString *nsDomainString = @"us.necibi.voicecontrol";
static NSString *nsNotificationString = @"us.necibi.voicecontrol/preferences.changed";

@interface VoiceControlSwitch : NSObject <FSSwitchDataSource>
@end

extern "C" BOOL _AXSCommandAndControlEnabled();
extern "C" void _AXSCommandAndControlSetEnabled(BOOL);

@implementation VoiceControlSwitch

- (NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier {
    return @"Voice Control";
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
    return (_AXSCommandAndControlEnabled()) ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
    switch (newState) {
        case FSSwitchStateIndeterminate:
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled" inDomain:nsDomainString];
            break;
        case FSSwitchStateOn:
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled" inDomain:nsDomainString];
            _AXSCommandAndControlSetEnabled(YES);
            break;
        case FSSwitchStateOff:
            _AXSCommandAndControlSetEnabled(NO);
            break;
    }
}

@end
