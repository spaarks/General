//
//  spaarksViewController.m
//  SpaarksARApp1
//
//  Created by martin steel on 10/05/2013.
//  Copyright (c) 2013 martin steel. All rights reserved.
//

#import "spaarksViewController.h"
#import "EAGLView.h"

@interface spaarksViewController ()

@end

@implementation spaarksViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    m_gestures = 0xFF; //enables all gestures
    m_gestureHandler = [[GestureHandlerIOS alloc] initWithSDK:m_metaioSDK withView:glView withGestures:m_gestures];
    
    // load our tracking configuration
    NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"TrackingData_MarkerlessFast" ofType:@"xml" inDirectory:@"Assets1"];
    
	if(trackingDataFile)
	{
		bool success = m_metaioSDK->setTrackingConfiguration([trackingDataFile UTF8String]);
		if( !success)
			NSLog(@"No success loading the tracking configuration");
	}
    
    
    // load content
    //NSString* metaioManModel = [[NSBundle mainBundle] pathForResource:@"metaioman" ofType:@"md2" inDirectory:@"Assets1"];
    NSString* humanHeartModel = [[NSBundle mainBundle] pathForResource:@"Human Heart" ofType:@"obj" inDirectory:@"Assets1"];
    
	if(humanHeartModel)
	{
		// if this call was successful, theLoadedModel will contain a pointer to the 3D model
        metaio::IGeometry* theLoadedModel =  m_metaioSDK->createGeometry([humanHeartModel UTF8String]);
        if( theLoadedModel )
        {
            // scale it a bit up
            theLoadedModel->setScale(metaio::Vector3d(40.0,40.0,40.0));
            
            //rotate the chair to be upright
            theLoadedModel->setRotation(metaio::Rotation(M_PI_2, 0.0, 0.0));
            theLoadedModel->setTranslation(metaio::Vector3d(0.0, 0.0, 0.0));
            [m_gestureHandler addObject:theLoadedModel andGroup:2 andPickability:true];
        }
        else
        {
            NSLog(@"error, could not load %@", humanHeartModel);
        }
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)InterfaceOrientation
{
    // allow rotation in all directions
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // record the initial states of the geometries with the gesture handler
    [m_gestureHandler touchesBegan:touches withEvent:event withView:glView];
    
    // Here's how to pick a geometry
	UITouch *touch = [touches anyObject];
	CGPoint loc = [touch locationInView:glView];
	
    // get the scale factor (will be 2 for retina screens)
    float scale = glView.contentScaleFactor;
    
	// ask sdk if the user picked an object
	// the 'true' flag tells sdk to actually use the vertices for a hit-test, instead of just the bounding box
    metaio::IGeometry* model = m_metaioSDK->getGeometryFromScreenCoordinates(loc.x * scale, loc.y * scale, false);
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // handles the drag touch
    [m_gestureHandler touchesMoved:touches withEvent:event withView:glView];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_gestureHandler touchesEnded:touches withEvent:event withView:glView];
}

@end
