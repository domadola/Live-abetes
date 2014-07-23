//
//  InsulinViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/23/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "InsulinViewController.h"

@interface InsulinViewController ()

@end

@implementation InsulinViewController

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
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.dataSource = self;
    
    
    NSArray *viewControllers = @[self.reminderController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}

#pragma mark - Page View Controller Data Source delegate
// Reminder is index 1, Bolus is index 2
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    UINavigationController *current = (UINavigationController*)viewController;
    if ([current.topViewController isKindOfClass:[BolusTableViewController class]]) {
        return self.reminderController;
    } else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    UINavigationController *current = (UINavigationController*)viewController;
    if ([current.topViewController isKindOfClass:[InsulinReminderTableViewController class]]) {
        return self.bolusController;
    } else {
        return nil;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (BolusTableViewController*)bolusController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"insulinNavController"];
}

- (InsulinReminderTableViewController*)reminderController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"reminderNavController"];
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
