
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>

@interface PSListController (SmartSleep)
	-(UIView*)view;
	-(UINavigationController*)navigationController;
	-(void)viewWillAppear:(BOOL)animated;
	-(void)viewWillDisappear:(BOOL)animated;

	- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
	- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
	-(UINavigationController*)navigationController;

	-(void)loadView;
@end

@interface UIImage (SmartSleep)
	+ (UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;
@end

@interface SmartSleepListController: PSListController {
}
@end


@implementation SmartSleepListController
	-(void)loadView
	{
		[super loadView];
		UIImage* image = [UIImage imageNamed:@"heart.png" inBundle:[NSBundle bundleForClass:self.class]];
		CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
		UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
		[someButton setBackgroundImage:image forState:UIControlStateNormal];
		[someButton addTarget:self action:@selector(heartBeat)
			 forControlEvents:UIControlEventTouchUpInside];
		[someButton setShowsTouchWhenHighlighted:YES];
		UIBarButtonItem *heartButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];

		UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		negativeSpacer.width = -16;
		[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, heartButton, nil] animated:NO];
		[self setupHeader];
	}


	-(void) heartBeat
	{
		SLComposeViewController *twitter = [[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter] retain];
		[twitter setInitialText:@"#SmartSleep by @joe_merlino is awesome!"];
		if (twitter != nil){
			[[self navigationController] presentViewController:twitter animated:YES completion:nil];

		}
		[twitter release];
	}
	
	- (void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		self.view.tintColor = nil;
	}
	-(void) setupHeader
	{
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];

		UIImage *headerImage = [UIImage imageNamed:@"CCP.png" inBundle:[NSBundle bundleForClass:self.class]];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:headerImage];
		imageView.frame = CGRectMake(imageView.frame.origin.x, 10, imageView.frame.size.width, 75);

		[headerView addSubview:imageView];
		[self.table setTableHeaderView:headerView];
	}


	- (id)specifiers {
		if(_specifiers == nil) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"SmartSleep" target:self] retain];
		}
		return _specifiers;

	}

	-(void)twitter {
		// NSLog(@"CCP (PREF): SEE MY TWEETS !!!");
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=joe_merlino"]]) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=joe_merlino"]];
		} else {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/joe_merlino"]];
		}
	}

	-(void)my_site {
		// NSLog(@"CCP (PREF): SEE MY WORK !!!");
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://github.com/joemerlino/"]];
	}

	-(void)donate {
		// NSLog(@"CCP (PREF): HELP ME EAT !!!");
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/us/cgi-bin/webscr?cmd=_send-money&nav=1&email=merlino.giuseppe1@gmail.com"]];
	}
	-(void) sendEmail{
		// NSLog(@"CCP (PREF): DISTRACT ME FROM MY WORK !!!");
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:merlino.giuseppe1@gmail.com?subject=SmartSleep"]];
	}
	-(void)save{
		// NSLog(@"CCP (PREF): NOW THATS GONNA DO SOMETHING NEW !!!");
		[self.view endEditing:YES];
	}
@end
