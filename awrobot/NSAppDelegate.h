#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;

+(NSAppDelegate *)appDeg;
-(void)showGuidePage;
-(void)showHomePage;

@end
