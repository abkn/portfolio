#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    //  window
    ofBackground(0, 0, 0);
    ofSetWindowShape(1280, 480);
    ofSetFrameRate(30);
    //  setup ofxOpenNI
    kinect.setup();
    kinect.setRegister(true);
    kinect.setMirror(true);
    kinect.addImageGenerator();     //  required for RGB image
    kinect.addDepthGenerator();     //  required for depth image
    kinect.addUserGenerator();      //  required for skeleton tracking
    kinect.setMaxNumUsers(1);       //  max num of skeleton to track
    //  start kinect
    kinect.start();
    
    metal.load("metal.jpg");
    
    headbang = false;
    
    sound.load("rock.mp3");
    sound.setMultiPlay(true);
    sound.play();
   // sound.setLoop(false);
    
    sound2.load("EDM.mp3");
    sound2.setMultiPlay(true);
    sound2.play();
  //  sound2.setLoop(false);
    
    //sound3.load("rock.mp3");
    //sound3.setMultiPlay(true);
}


//--------------------------------------------------------------
void ofApp::update(){
    ofSetWindowTitle("supply and demand");
    
    kinect.update();
   // video.update();
    
    
    
   
   }

//--------------------------------------------------------------
void ofApp::draw(){
    
    
    if (kinect.getNumTrackedUsers() > 0) {
        ofxOpenNIUser user = kinect.getTrackedUser(0);
        
        
        //0.LIMB_LEFT_UPPER_TORSO 左上ワキ
        //1.LIMB_LEFT_SHOULDER 左鎖骨
        //2.LIMB_LEFT_UPPER_ARM 左上腕
        //3.LIMB_LEFT_LOWER_ARM 左前腕
        //4.LIMB_LEFT_LOWER_TORSO 左下ワキ
        //5.LIMB_LEFT_UPPER_LEG 左上腿
        //6.LIMB_LEFT_LOWER_LEG 左下腿
        //7.LIMB_RIGHT_UPPER_TORSO 右上ワキ
        //8.LIMB_RIGHT_SHOULDER 右鎖骨
        //9.LIMB_RIGHT_UPPER_ARM 右上腕
        //10.LIMB_RIGHT_LOWER_ARM 左前腕
        //11.LIMB_RIGHT_LOWER_TORSO 右下ワキ
        //12.LIMB_RIGHT_UPPER_LEG 右上腿
        //13.LIMB_RIGHT_LOWER_LEG 右下腿
        //14.LIMB_NECK 首
        //15.LIMB_PERVIS 股
        
        //limb  骨
        //limbのビジュアライズ
        ofSetLineWidth(2);
        ofSetColor(255, 255, 127);
        for (int i=0; i < user.getNumLimbs(); i++) {
            ofxOpenNILimb limb = user.getLimb((enum Limb)i);
            if (limb.isFound()) {
                float x1 = limb.getStartJoint().getProjectivePosition().x;
                float y1 = limb.getStartJoint().getProjectivePosition().y;
                float x2 = limb.getEndJoint().getProjectivePosition().x;
                float y2 = limb.getEndJoint().getProjectivePosition().y;
                ofDrawLine(x1, y1, x2, y2);
                
            }
        }
        
        
        //0.JOINT_TORSO ヘソ(体の中心）
        //1.JOINT_NECK 首の根本
        //2.JOINT_HEAD 頭の中心
        //3.JOINT_LEFT_SHOULDER 左肩
        //4.JOINT_LEFT_ELBOW 左肘
        //5.JOINT_LEFT_HAND 左手首
        //6.JOINT_RIGHT_SHOULDER 右肩
        //7.JOINT_RIGHT_ELBOW 右肘
        //8.JOINT_RIGHT_HAND 右手首
        //9.JOINT_LEFT_HIP 左ケツ
        //10.JOINT_LEFT_KNEE 左膝
        //11.JOINT_LEFT_FOOT 左足首
        //12.JOINT_RIGHT_HIP 右ケツ
        //13.JOINT_RIGHT_KNEE 右膝
        //14.JOINT_RIGHT_FOOT 右足首
        
        //joint 関節
        　　　　　　　　　　　　　　　　//jointのビジュアライズ
        ofSetColor(255, 127, 127);
        for (int i=0; i < user.getNumJoints(); i++) {
            ofxOpenNIJoint joint = user.getJoint((enum Joint)i);
            if (joint.isFound()) {
                float x = joint.getProjectivePosition().x;
                float y = joint.getProjectivePosition().y;
                ofDrawCircle(x, y, 8);
                
                
                
                　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　//へそと頭の位置取得
                float HeadX = user.getJoint((Joint)2).getProjectivePosition().x;
                float HeadY = user.getJoint((Joint)2).getProjectivePosition().y;
                
                float NeckX = user.getJoint((Joint)1).getProjectivePosition().x;
                float NeckY = user.getJoint((Joint)1).getProjectivePosition().y;
                
                float lHandY = user.getJoint((Joint)8).getProjectivePosition().y;
                float rHandY = user.getJoint((Joint)5).getProjectivePosition().y;
                
                float lRegY = user.getJoint((Joint)13).getProjectivePosition().y;
                float rRegY = user.getJoint((Joint)10).getProjectivePosition().y;
                
                
                
                
                if (ofDist(HeadX,HeadY,NeckX,NeckY) < 100 && lHandY > 50 && rHandY > 50) {
                    headbang = true;
                    ofSetColor(255, 0, 0);
                    kinect.drawImage(640,0,640,480);
                    //sound.play();
                    sound.setPaused(false);
                    sound2.setPaused(true);
                    //sound2.stop();
                    
                    
                }else if ( lHandY < 75 && rHandY < 75 && ofDist(HeadX,HeadY,NeckX,NeckY) > 75) {
                    
                    headbang = false;
                    ofSetColor(100, 255, 255);
                    kinect.drawImage(640, 0, 640, 480);
                  //  sound2.play();
                    sound.setPaused(true);
                    sound2.setPaused(false);
                   // sound.stop();
                } else {
                    ofSetColor(255, 255, 255);
                    kinect.drawImage(640, 0, 640, 480);
                    sound.setPaused(true);
                    sound2.setPaused(true);
                }
            }
        }
    }
    
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if(key == 's'){
    sound2.stop();
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
