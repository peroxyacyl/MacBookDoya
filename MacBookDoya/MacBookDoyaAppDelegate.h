//
//  MacBookDoyaAppDelegate.h
//  MacBookDoya
//
//  Created by Seki Inoue on 11/09/13.
//  Copyright 2011年 Team Excellent All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MacBookDoyaAppDelegate : NSObject <NSApplicationDelegate, NSSoundDelegate> {
    NSWindow *window;
    NSMenu *sbMenu;
    NSStatusItem *sbItem;
    BOOL isRunning;  
    NSArray *sounds;
    IONotificationPortRef	notificationPort;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *sbMenu;
@property (nonatomic) NSInteger soundSelected;

- (IBAction)quitButtonPressed:(id)sender;
- (IBAction)soundDoya:(id)sender;
- (IBAction)doyaAtAwakeButtonPressed:(id)sender;
- (IBAction)showAboutPanel:(id)sender;
@end
