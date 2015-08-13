//
//  WelcomeScreenViewController.m
//  Game 001
//
//  Created by Chen Zhibo on 2/13/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "GameViewController.h"
@import GameKit;

@interface WelcomeScreenViewController () <GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate>

@property (strong, nonatomic) UIViewController *authenticationVC;

@end

@implementation WelcomeScreenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            //[self showAuthenticationDialogWhenReasonable: viewController];
            NSLog(@"viewController != nil");
            self.authenticationVC = viewController;
            [self presentViewController:self.authenticationVC animated:YES completion:^{
                self.authenticationVC = nil;
            }];
        }
        else if (localPlayer.isAuthenticated)
        {
            //authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
            //[self authenticatedPlayer: localPlayer];
            
            NSLog(@"authenticated player");
            
            
            
            
            [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
                // Insert game-specific code here to clean up any game in progress.
                if (acceptedInvite)
                {
                    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite];
                    mmvc.matchmakerDelegate = self;
                    [self presentViewController:mmvc animated:YES completion:nil];
                }
                else if (playersToInvite)
                {
                    GKMatchRequest *request = [[GKMatchRequest alloc] init];
                    request.minPlayers = 2;
                    request.maxPlayers = 2;
                    request.playersToInvite = playersToInvite;
                    
                    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
                    mmvc.matchmakerDelegate = self;
                    [self presentViewController:mmvc animated:YES completion:nil];
                }
            };
            
            
            
            
            
        }
        else
        {
            //[self disableGameCenter];
            NSLog(@"disable game center");
            [[[UIAlertView alloc] initWithTitle:@"Enable Game Center" message:@"Game Center is currently disabled. In order to play this game, please go to Settings => Game Center to enable it." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
    };
    
}




- (void)viewDidAppear:(BOOL)animated
{
    if (self.authenticationVC) {
        [self presentViewController:self.authenticationVC animated:YES completion:^{
            self.authenticationVC = nil;
        }];
    }
    
}


- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)hostMatch:(id)sender {
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    
    [self presentViewController:mmvc animated:YES completion:NULL];
}

#pragma mark - delegate


- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"failed match make");
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [self dismissViewControllerAnimated:YES completion:nil];
    GameViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameVC"];
    [self presentViewController:gvc animated:YES completion:nil];
    gvc.currentMatch = match;
}

- (IBAction)enterDemo:(id)sender
{
    GameViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameVC"];
    [self presentViewController:gvc animated:YES completion:nil];
}
@end
