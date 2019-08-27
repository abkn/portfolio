#pragma once

#include "ofMain.h"
#include "ofxCv.h"

class ofApp : public ofBaseApp {

public:

	void setup();
	void update();
	void draw();

	void keyPressed(int key);
	void keyReleased(int key);
	void mouseMoved(int x, int y);
	void mouseDragged(int x, int y, int button);
	void mousePressed(int x, int y, int button);
	void mouseReleased(int x, int y, int button);
	void mouseEntered(int x, int y);
	void mouseExited(int x, int y);
	void windowResized(int w, int h);
	void dragEvent(ofDragInfo dragInfo);
	void gotMessage(ofMessage msg);

	ofVideoPlayer  vid;
	ofVideoPlayer  vid2;
	ofVideoGrabber cam;
	ofxCv::ObjectFinder finder;  //ƒJƒƒ‰‚ÌŠç”F¯
	ofxCv::ObjectFinder finder2; //˜^‰æ‚ÌŠç”F¯



	int vidtocam = 0;
	int vidtocam2 = 0;
	int noface = 0;
	int noface2 = 0;
	int facein = 0;
	int faceout = 0;

};