//
//  ActivityViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/3/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "ActivityViewController.h"
#import <CoreMotion/CMStepCounter.h>

@interface ActivityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stepsTakenLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *stepsProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *dailyGoalLabel;
@property (weak, nonatomic) IBOutlet UIStepper *dailyGoalStepper;
@property (strong, nonatomic) CMStepCounter *counter;

@end

@implementation ActivityViewController

- (IBAction)dailyGoalStepperChanged:(id)sender
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.counter = [[CMStepCounter alloc] init];
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24]; // 24 hours previous to now
    NSDate *endDate = [NSDate date];
    __weak typeof(self) weakSelf = self;
    [self.counter queryStepCountStartingFrom:startDate
                                              to:endDate
                                         toQueue:[NSOperationQueue mainQueue]
                                     withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                         //weakSelf.title = [@(numberOfSteps) stringValue];
                                         weakSelf.stepsTakenLabel.text = [@(numberOfSteps) stringValue];
                                     }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
