//
//  ChoseBlogViewController.m
//  Stories
//
//  Created by Alexandre THOMAS on 28/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "ChoseBlogViewController.h"

@interface ChoseBlogViewController ()

@property (weak, nonatomic) IBOutlet UIButton *deadspinButton;
@property (weak, nonatomic) IBOutlet UIButton *gawkerButton;
@property (weak, nonatomic) IBOutlet UIButton *gizmodoButton;
@property (weak, nonatomic) IBOutlet UIButton *io9Button;
@property (weak, nonatomic) IBOutlet UIButton *jalponikButton;
@property (weak, nonatomic) IBOutlet UIButton *jezebelButton;
@property (weak, nonatomic) IBOutlet UIButton *kotakuButton;
@property (weak, nonatomic) IBOutlet UIButton *lifehackerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deadspinTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lifehackerBottomConstraint;

@end

@implementation ChoseBlogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    
//    
//    [UIView animateWithDuration:2 delay:02 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
//        self.deadspinTopConstraint.constant = 100;
//        self.lifehackerBottomConstraint.constant = 0;
//        [self.deadspinButton setNeedsLayout];
//        [self.deadspinButton layoutIfNeeded];
//        for(UIButton *button in buttons) {
//            button.alpha = 1;
//        }
//    } completion:^(BOOL finished) {
//        
//    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*NSArray *buttons = @[self.deadspinButton, self.gawkerButton, self.gizmodoButton, self.io9Button, self.jalponikButton, self.jezebelButton, self.kotakuButton, self.lifehackerButton];
    
    static NSTimeInterval duration = 0.2;
    NSTimeInterval delay = 0.0;
    for(UIButton *button in buttons) {
        button.hidden = NO;
        button.alpha = 0;
        
        [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
            button.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        delay += 0.05;
    }*/

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)closeDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)blogHasBeenChoser:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(blogHasBeenSelected:)]) {
        [self.delegate blogHasBeenSelected:[NSNumber numberWithLong:(long)button.tag]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
