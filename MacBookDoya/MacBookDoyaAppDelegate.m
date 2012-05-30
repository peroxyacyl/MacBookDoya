//
//  MacBookDoyaAppDelegate.m
//  MacBookDoya
//
//  Created by Seki Inoue on 11/09/13.
//  Copyright 2011年 Team Excellent All rights reserved.
//

#import "LaunchAtLoginController.h"
#import "MacBookDoyaAppDelegate.h"
#include <IOKit/IOKitLib.h>
#include <IOKit/IOMessage.h>
#include <IOKit/hidsystem/IOHIDParameter.h>
#include <IOKit/hidsystem/IOHIDShared.h>
#include <IOKit/pwr_mgt/IOPMLib.h>



#define DOYA1 @"( ´_ゝ`)ﾄﾞﾔｧ"
#define DOYA2 @"ﾄﾞﾔｯ('･ι＿，･`) "

@implementation MacBookDoyaAppDelegate

@synthesize window;
@synthesize sbMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sounds" ofType:@"plist"];
    sounds = [[NSArray arrayWithContentsOfFile:path] retain];
    
    NSMenu *selectMenu = [[[NSMenu alloc] init] autorelease];
    for (int i = 0; i < [sounds count]; i++) {
        NSString *title = [[sounds objectAtIndex:i] objectForKey:@"title"];
        NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
        item.title = title;
        item.target = self;
        item.action = @selector(soundDidSelect:);
        item.tag = i;
        [selectMenu addItem:item];
    }
    
    [[selectMenu itemWithTag:self.soundSelected] setState:NSOnState];
    
    [[sbMenu itemWithTag:5] setSubmenu:selectMenu];
    
    LaunchAtLoginController *lalc = [[[LaunchAtLoginController alloc] init] autorelease];
    if (lalc.launchAtLogin) {
        [self soundDoya:nil];
        [[sbMenu itemWithTag:3] setState:NSOnState];
    }
    
    
    NSStatusBar *bar = [ NSStatusBar systemStatusBar ];
    
    sbItem = [ bar statusItemWithLength : NSVariableStatusItemLength ];
    [sbItem retain];
    [sbItem setTitle:DOYA1];
    [sbItem setToolTip:@"ﾄﾞﾔｧ"]; 
    [sbItem setHighlightMode:YES];
    [sbItem setMenu:sbMenu];
    
    [self doyaAtAwakeButtonPressed:[sbMenu itemWithTag:1]];
}

- (void)run {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self 
														   selector: @selector(receiveWakeNote:) 
															   name: NSWorkspaceDidWakeNotification object: NULL];
}

- (void)stop {
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
}

- (void)setSoundSelected:(NSInteger)number {
    [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"MBDSelectSound"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)soundSelected {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MBDSelectSound"];
}

- (IBAction)soundDidSelect:(NSMenuItem *)sender {
    NSMenu *menu = [sender menu];
    for (NSMenuItem *item in [menu itemArray]) {
        item.state = NSOffState;
    }
    sender.state = NSOnState;
    [self setSoundSelected:sender.tag];
    [self soundDoya:nil];
}

- (IBAction)quitButtonPressed:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

- (IBAction)launchAtLoginButtonPressed:(NSMenuItem *)sender {
    LaunchAtLoginController *lalc = [[[LaunchAtLoginController alloc] init] autorelease];
    if (lalc.launchAtLogin) {
        sender.state = NSOffState;
        lalc.launchAtLogin = NO;
    }else {
        sender.state = NSOnState;
        lalc.launchAtLogin = YES;
    }
}


- (IBAction)soundDoya:(id)sender {
    NSString *fileName = [[sounds objectAtIndex:[self soundSelected]] objectForKey:@"fileName"];
    NSSound *sound = [NSSound soundNamed:fileName];
    sound.delegate = self;
    [sbItem setTitle:DOYA2];
    [sound play];
    
}

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)aBool {
    [sbItem setTitle:DOYA1];
    sound.delegate = nil;
}
                                                             

- (IBAction)doyaAtAwakeButtonPressed:(NSMenuItem *)sender {
    if (isRunning) {
        [self stop];
        isRunning = NO;
        sender.state = NSOffState;
    }else {
        [self run];
        isRunning = YES;
        sender.state = NSOnState;
    }
}

- (IBAction)showAboutPanel:(id)sender {
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];
}

- (void)receiveWakeNote:(NSNotification *)notification {
	[(MacBookDoyaAppDelegate *)[[NSApplication sharedApplication] delegate] soundDoya:nil];
}
@end
