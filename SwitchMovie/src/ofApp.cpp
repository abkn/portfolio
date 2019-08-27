#include "ofApp.h"

using namespace ofxCv;
using namespace cv;

//--------------------------------------------------------------
void ofApp::setup(){

	ofBackground(255, 255, 255);

	ofSetVerticalSync(true);
	ofSetFrameRate(120);
	finder.setup("haarcascade_frontalface_default.xml");
	finder.setPreset(ObjectFinder::Fast);
	finder2.setup("haarcascade_frontalface_default.xml");
	finder2.setPreset(ObjectFinder::Fast);
	cam.setup(640, 480);

	vid.load("Recording.mp4");
	vid.setLoopState(OF_LOOP_NORMAL);
	vid2.load("My Recording_25.mp4");
	vid2.setLoopState(OF_LOOP_NORMAL);
	//vid.play();

}

//--------------------------------------------------------------
void ofApp::update(){

	cam.update();
	if (cam.isFrameNew()) {
		finder.update(cam);
		finder2.update(vid);
	}

	vid.update();

}

//--------------------------------------------------------------
void ofApp::draw() {
	

		if (finder.size() == 1) {
			for (int i = 0; i < finder.size(); i++) {
				ofRectangle rect = finder.getObjectSmoothed(i);
				
					if (ofDist(rect.x + (rect.width / 2), rect.y + (rect.height / 2), 320, 240) < 100 && rect.width > 180) {
						
						if (vid.isFrameNew()) {
							//顔位置が中心に来た場合の処理（videoが再生されていた場合）（フレームレートを落としたカメラ映像）
							ofSetFrameRate(5);
							ofBackground(0);
							vid.setPaused(true);
							cam.draw(0, 0, 1024, 768);
							ofDrawBitmapString("Live", 20, 20);
							
							//finder.draw();

							facein++;
							vidtocam = 0;
							noface = 0;
							if (facein > 4) {
								//顔位置が中心でしばらくした際の処理（通常フレームレートの処理）
								ofSetFrameRate(120);
								cam.draw(0, 0, 1024, 768);
								ofDrawBitmapString("Live", 20, 20);
								//finder.draw();
							}
						}
						else {
							//顔位置が中心の場合の処理（videoが再生されていなかった場合）（そのままカメラ映像）
							ofSetFrameRate(120);
							ofBackground(0);
							cam.draw(0, 0, 1024, 768);
							ofDrawBitmapString("Live", 20, 20);
							//finder.draw();

							vidtocam = 0;
							noface = 0;
						}
					
					}
					else {
						//顔位置がずれた瞬間の処理
						ofSetFrameRate(120);
						vid.isPaused();
						cam.draw(0, 0, 1024, 768);
						ofDrawBitmapString("Live", 20, 20);
						//finder.draw();

						facein = 0;
						vidtocam++;
						if (vidtocam > 10) {
							//顔位置がずれてしばらくした際の処理
							ofSetFrameRate(5);
							ofBackground(0);
							cam.draw(0, 0, 1024, 768);
							ofDrawBitmapString("Live", 20, 20);

							noface++;
							if (noface > 4) {
								//顔位置がずれてさらにしばらくたった時の処理
								ofSetFrameRate(120);
								vid.setPaused(false);
								//vid.play();
								vid.draw(0, 0, 1024, 768);
								ofDrawBitmapString("Record", 20, 20);
							}
						}
					}
					//((ofToString(ofDist(rect.x + (rect.width/2), rect.y + (rect.height / 2), 320, 240))) + "fps", 20, 140);
					//ofDrawBitmapString((ofToString(rect.x)), 20, 170);
					//ofDrawBitmapString((ofToString(rect.y)), 20, 200);
					
					//ofDrawBitmapString((ofToString(rect.width)), 20, 260);
					//ofDrawBitmapString((ofToString(rect.height)), 20, 290);

			}
		}//顔が認識されなかった時の処理
		else {
			//ずれた瞬間
			ofSetFrameRate(120);
			vid.setPaused(true);
			cam.draw(0, 0, 1024, 768);
			ofDrawBitmapString("Live", 20, 20);
			
			//finder.draw();

			facein = 0;
			vidtocam++;
			if (vidtocam > 10) {
				//ずれて一定時間経過
				ofSetFrameRate(5);
				ofBackground(0);
				cam.draw(0, 0, 1024, 768);
				ofDrawBitmapString("Live", 20, 20);
				
				
				noface++;
				if (noface > 4) {
					//さらに一定時間経過
					ofSetFrameRate(120);
					vid.setPaused(false);
					//vid.setSpeed(-1);
					//vid.play();
					vid.draw(0, 0, 1024, 768);
					ofDrawBitmapString("Record", 20, 20);
				
				}
			}
			
		}

		//ofDrawBitmapString((ofToString(facein)) + "fps", 20, 20);
		//ofDrawBitmapString((ofToString(vidtocam)) + "fps", 20, 50);
		//ofDrawBitmapString((ofToString(noface)) + "fps", 20, 80);
		//ofDrawBitmapString((ofToString(ofGetFrameRate())) + "fps", 20, 110);
		
	

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
	if (key == ' ') {
		ofToggleFullscreen();
	}
	
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
	vid.setPosition((float)x / (float)ofGetWidth());

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
