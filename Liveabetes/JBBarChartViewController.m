//
//  JBBarChartViewController.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBarChartViewController.h"

// Views
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"
#import "JBBarChartFooterView.h"
#import "JBChartInformationView.h"
#import "JBColorConstants.h"
#import "Activity.h"

// Numerics
CGFloat const kJBBarChartViewControllerChartHeight = 250.0f;
CGFloat const kJBBarChartViewControllerChartPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
NSUInteger kJBBarChartViewControllerBarPadding = 1;
NSInteger const kJBBarChartViewControllerNumBars = 12;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight = 5;

// Strings
NSString * const kJBBarChartViewControllerNavButtonViewKey = @"view";

@interface JBBarChartViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic, strong) JBBarChartView *barChartView;
@property (nonatomic, strong) JBChartInformationView *informationView;
//@property (nonatomic, strong) NSArray *chartData;
//@property (nonatomic, strong) NSArray *monthlySymbols;

// My properties
@property (strong, nonatomic) NSArray *weeklyActivity; // of type Activity.h
@property (strong, nonatomic) NSArray *daysOfWeek; // of NSString
@property (strong, nonatomic) NSDateFormatter *shortDaysOfWeek;

// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Data
- (void)initFakeData;

@end

@implementation JBBarChartViewController

- (void)loadDaysOfWeek
{
    self.daysOfWeek = @[@"Mon", @"Tues", @"Wed", @"Thurs", @"Fri", @"Sat", @"Sun"];
}

#pragma mark - Alloc/Init

static bool demo = false;

- (id)initWithContext:(NSManagedObjectContext *)context
{
    self.context = context;
    return [self init];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Weekly Activity";
        if (demo) {
            [self initDemoData];
        } else {
            [self initActivityData];
        }
        
        self.shortDaysOfWeek = [[NSDateFormatter alloc] init];
        [self.shortDaysOfWeek setDateFormat:@"EEE"];
        //[self initFakeData];
    }
    return self;
}

- (void)initDemoData
{
    NSDate *date = [NSDate date];
    //NSCalendar *calendar = [NSCalendar currentCalendar];
    //NSDateComponents *components = [[NSDateComponents alloc] init];
    
    //self.weeklyActivity = [NSArray arrayWithObjects:nil count:7];
    Activity *a = [[Activity alloc] init];
    a.minutes = [NSNumber numberWithInt:35];
    a.date = date;
    
    self.weeklyActivity = @[a];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

- (void)getAllActivityAndPrint // for debugging
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
    NSArray *results = [self.context executeFetchRequest:request error:NULL];
    
    for (Activity *a in results) {
        NSLog(@"the date of activity: %@", a.date);
    }
}

- (void)initActivityData
{
    [self getAllActivityAndPrint];
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSDate *date = [calendar dateFromComponents:components]; // just date, no time
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
//    request.predicate = [NSPredicate predicateWithFormat:@"(date <= %@) AND ", date];
    NSDateComponents *oneWeek= [[NSDateComponents alloc] init];
    //oneWeek.week = -1;
    oneWeek.day = -6;
    
    
    NSDate *weekAgo = [calendar dateByAddingComponents:oneWeek toDate:date options:0];
    //    NSDate *endOfDay = [calendar dateFromComponents:dateComponents];
    NSLog(@"weekAgo: %@ and date: %@", weekAgo, date);
    request.predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", weekAgo, date];
    request.fetchLimit = 7;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"ERROR");
    }
    
    self.weeklyActivity = [NSArray arrayWithArray:results];
    self.daysOfWeek = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    
    NSLog(@"There were %i activity results for the week", results.count);
}

#pragma mark - Date

- (void)initFakeData
{
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<kJBBarChartViewControllerNumBars; i++)
    {
        NSInteger delta = (kJBBarChartViewControllerNumBars - abs((kJBBarChartViewControllerNumBars - i) - i)) + 2;
        [mutableChartData addObject:[NSNumber numberWithFloat:MAX((delta * kJBBarChartViewControllerMinBarHeight), arc4random() % (delta * kJBBarChartViewControllerMaxBarHeight))]];

    }
//    _chartData = [NSArray arrayWithArray:mutableChartData];
//    _monthlySymbols = [[[NSDateFormatter alloc] init] shortMonthSymbols];
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = kJBColorBarChartControllerBackground;
    self.navigationItem.rightBarButtonItem = [self chartToggleButtonWithTarget:self action:@selector(chartToggleButtonPressed:)];

    self.barChartView = [[JBBarChartView alloc] init];
    self.barChartView.frame = CGRectMake(kJBBarChartViewControllerChartPadding, kJBBarChartViewControllerChartPadding, self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeight);
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
    self.barChartView.minimumValue = 0.0f;
    self.barChartView.backgroundColor = kJBColorBarChartBackground;
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = @"Title";//[kJBStringLabelAverageMonthlyTemperature uppercaseString];
    headerView.subtitleLabel.text = @"";//kJBStringLabel2012;
    headerView.separatorColor = kJBColorBarChartHeaderSeparatorColor;
    self.barChartView.headerView = headerView;
    
    JBBarChartFooterView *footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartFooterHeight)];
    footerView.padding = kJBBarChartViewControllerChartFooterPadding;
    Activity *firstActivity = [self.weeklyActivity firstObject];
    Activity *lastActivity = [self.weeklyActivity lastObject];
    footerView.leftLabel.text = [self.shortDaysOfWeek stringFromDate:firstActivity.date];//[[self.daysOfWeek firstObject] uppercaseString];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [self.shortDaysOfWeek stringFromDate:lastActivity.date];//[[self.daysOfWeek lastObject] uppercaseString];
    footerView.rightLabel.textColor = [UIColor whiteColor];
    self.barChartView.footerView = footerView;
    
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.barChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.barChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.view addSubview:self.informationView];

    [self.view addSubview:self.barChartView];
    [self.barChartView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.barChartView setState:JBChartViewStateExpanded];
}

#pragma mark - JBBarChartViewDelegate

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
    Activity *a = [self.weeklyActivity objectAtIndex:index];
    return [a.minutes floatValue];//[[self.chartData objectAtIndex:index] floatValue];
}

#pragma mark - JBBarChartViewDataSource

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return self.weeklyActivity.count; //kJBBarChartViewControllerNumBars;
}

- (NSUInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return kJBBarChartViewControllerBarPadding;
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    return (index % 2 == 0) ? kJBColorBarChartBarBlue : kJBColorBarChartBarGreen;
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    Activity *a = [self.weeklyActivity objectAtIndex:index];
    [self.informationView setValueText:[a.minutes stringValue] unitText:nil];//[NSString stringWithFormat:kJBStringLabelDegreesFahrenheit, [valueNumber intValue], kJBStringLabelDegreeSymbol] unitText:nil];
    [self.informationView setTitleText:@"Minutes of Activity"];//kJBStringLabelWorldwideAverage];
    [self.informationView setHidden:NO animated:YES];
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    [self.tooltipView setText:[self.shortDaysOfWeek stringFromDate:a.date]]; // not correct, get from
    NSLog(@"the selected day: %@", [self.shortDaysOfWeek stringFromDate:a.date]);
    NSLog(@"and today is: %@", [self.shortDaysOfWeek stringFromDate:[NSDate date]]);

}

- (void)didUnselectBarChartView:(JBBarChartView *)barChartView
{
    [self.informationView setHidden:YES animated:YES];
    [self setTooltipVisible:NO animated:YES];
}

#pragma mark - Buttons

- (void)chartToggleButtonPressed:(id)sender
{
    UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kJBBarChartViewControllerNavButtonViewKey];
    buttonImageView.userInteractionEnabled = NO;
    
    CGAffineTransform transform = self.barChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    buttonImageView.transform = transform;
    
    [self.barChartView setState:self.barChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES callback:^{
        buttonImageView.userInteractionEnabled = YES;
    }];
}

#pragma mark - Overrides

- (JBChartView *)chartView
{
    return self.barChartView;
}

@end
