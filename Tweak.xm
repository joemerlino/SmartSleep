#import <UIKit/UIKit.h>
#import <UIKit/UIAlertController.h>
#import "MediaRemote.h"

static int conta=0;
static int arrivo;
static BOOL awake=YES;

#define setin_domain CFSTR("com.joemerlino.SmartSleep")

NSMutableString *nowPlayingTitle = [[NSMutableString alloc] initWithCapacity:10];
NSMutableString *nowPlayingArtist = [[NSMutableString alloc] initWithCapacity:10];
NSMutableString *nowPlayingAlbum = [[NSMutableString alloc] initWithCapacity:10];
NSString *frmt  =@"";
NSString *alrt  =@"";
NSString *limite  =@"";
@interface CopyMusicListner: NSObject{
}
@end

@implementation CopyMusicListner

+(void)trackDidChange{
	if([frmt boolValue]){
		MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {

			NSDictionary *dict=(__bridge NSDictionary *)(information);

			if( dict != NULL && [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]!= NULL ){
				NSString *nowPlayingTitle_tmp = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]];
				if(![nowPlayingTitle isEqual:nowPlayingTitle_tmp])
				{

					if(nowPlayingTitle_tmp != NULL){
						[nowPlayingTitle setString:nowPlayingTitle_tmp];
					}else
					{
						[nowPlayingTitle setString:@""];
					}
					if( [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] != NULL ){
						[nowPlayingArtist setString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]];
					}else{
						[nowPlayingArtist setString:@""];

					}
					if( [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] != NULL ){
						[nowPlayingAlbum setString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum]];
					}else{
							[nowPlayingAlbum setString:@""];
					}
					if(![alrt boolValue]){
						conta++;
						NSLog(@"WE GOT A NEW TITLE %@ and %d",nowPlayingTitle, conta);
						[nowPlayingTitle_tmp release];
						[nowPlayingTitle retain];
					}
				}
			}
		});
	}
 }

+ (void)load
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackDidChange) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
	[pool release];

}

@end

%hook SBMediaController

-(void)setNowPlayingInfo:(id)arg1 {
	%orig;
	if([frmt boolValue]){
		if([alrt boolValue] && awake){
			awake=NO;
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (arrivo*60) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			    [((SBMediaController *)[%c(SBMediaController) sharedInstance]) pause];
				UIAlertView *credits = [[UIAlertView alloc] initWithTitle:@"SmartSleep" 
						          message:@"Are you awake?" 
	                                                 delegate:self 
	  					cancelButtonTitle:@"Yes" 
	  					otherButtonTitles:nil]; 
				[credits show];
				[credits release];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				    [credits dismissWithClickedButtonIndex:-1 animated:YES];
				});
			});
		}
		if(conta==arrivo){
			conta=1;
			[((SBMediaController *)[%c(SBMediaController) sharedInstance]) pause];
			UIAlertView *credits = [[UIAlertView alloc] initWithTitle:@"SmartSleep" 
						          message:@"Are you awake?" 
	                                                 delegate:self 
	  					cancelButtonTitle:@"Yes" 
	  					otherButtonTitles:nil]; 
			[credits show];
			[credits release];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				    [credits dismissWithClickedButtonIndex:-1 animated:YES];
			});
		}
	}
}

%new
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex==0){
		[((SBMediaController *)[%c(SBMediaController) sharedInstance]) play];
		awake=YES;
	}
}
%end
static void loadPrefs()
{
 	CFPreferencesAppSynchronize(CFSTR("com.joemerlino.SmartSleep"));
	frmt = (NSString*)CFPreferencesCopyAppValue(CFSTR("frmt"), setin_domain) ?: @"Yes";
	alrt = (NSString*)CFPreferencesCopyAppValue(CFSTR("alrt"), setin_domain) ?: @"Yes";
	limite = (NSString*)CFPreferencesCopyAppValue(CFSTR("limit"), setin_domain) ?: @"5";
	arrivo=[limite intValue];
	NSLog(@"LIMITE: %d", arrivo);
	[frmt retain];

}



%ctor {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
								NULL,
								(CFNotificationCallback)loadPrefs,
								CFSTR("com.joemerlino.SmartSleep/settingschanged"),
								NULL,
								CFNotificationSuspensionBehaviorDeliverImmediately);
	loadPrefs();

	[pool drain];
}
