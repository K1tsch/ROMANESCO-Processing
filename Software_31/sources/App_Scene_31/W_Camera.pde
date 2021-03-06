/**
Camera Romanesco
2013-2018
v 1.1.4.1
*/
//travelling
boolean gotoCameraPosition, gotoCameraEye, travellingPriority;
//speed must be 1 or less
float speed_camera_romanesco;

//CAMERA Stuff
private boolean moveScene, moveEye;

Vec3 targetPosCam = Vec3();

// motion effect on camera


Motion motion_translate, motion_rotate;

// ratio camera
float ratio_speed_camera_romanesco = .1;

float ratio_speed_camera_inertia_translate = 10;
float ratio_speed_camera_inertia_rotate = 3;
float acc_camera_rope = .01;
float dec_camera_rope = .01;


/**
P3D SETUP
*/
void P3D_setup() {
    camera_setting (NUM_SETTING_CAMERA);
    item_manipulation () ;
    item_manipulation_setting(NUM_SETTING_ITEM);
    initVariableCamera() ;
    println("P3D setup done") ;
}


// ANNEXE setting object manipulation
void item_manipulation () {
  //P3D for all ROMANESCO object
  for ( int i = 0 ; i < NUM_ITEM ; i++ ) {
    posObj[i] = Vec3() ; 
    dirObj[i] = Vec3() ;
    if(dir_item_final[i] == null) dir_item_final[i] = Vec3() ;
  }
}

void item_manipulation_setting (int num_setting_item) {
  // object orientation
  for ( int i = 0 ; i < num_setting_item ; i++ ) {
    for (int j = 0 ; j < NUM_ITEM ; j++ ) {
       if(item_setting_position [i][j] == null) item_setting_position [i][j] = Vec3() ;
       if(item_setting_direction [i][j] == null) item_setting_direction [i][j] = Vec3() ;
     }
   }
}

// ANNEXE setting camera manipulation
void camera_setting (int numSettingCamera) {
  if (eyeCameraSetting != null && sceneCameraSetting != null ) {
    for ( int i = 0 ; i < numSettingCamera ; i++ ) {
       eyeCameraSetting[i] = Vec3() ;
       sceneCameraSetting[i] = Vec3() ;
    }
  }

  speed_camera_romanesco = width / 1000 * ratio_speed_camera_romanesco ;

  float max_speed_inertia_translate = width / 1000 * ratio_speed_camera_inertia_translate ;
  float max_speed_inertia_rotate = width / 1000 * ratio_speed_camera_inertia_rotate ;

  motion_translate = new Motion(max_speed_inertia_translate) ;
  motion_rotate = new Motion(max_speed_inertia_rotate) ;
}


/**
Item
Start setting position and direction 0.0.1
*/
// direction
void setting_start_direction(int ID, Vec2 dir) {
  int which_setting = 0 ;
  setting_start_direction(ID, which_setting, (int)dir.x, (int)dir.y) ;
}

void setting_start_direction(int ID, int dir_x, int dir_y) {
  int which_setting = 0 ;
  setting_start_direction(ID, which_setting, dir_x, dir_y) ;
}

void setting_start_direction(int ID, int which_setting, int dir_x, int dir_y) {
  if(dir_item_final[ID] == null) dir_item_final[ID] = Vec3() ;
  dir_item_final[ID].set(dir_x, dir_y,0) ;
  if(item_setting_direction [0][ID] == null) item_setting_direction [which_setting][ID] = Vec3() ;
  item_setting_direction [0][ID] = Vec3(dir_item_final[ID]) ;
  if(temp_item_canvas_direction[ID] == null) temp_item_canvas_direction[ID] = Vec3() ;
  temp_item_canvas_direction[ID].x = map(item_setting_direction [which_setting][ID].y, 0, 360, 0, width) ;
  temp_item_canvas_direction[ID].y = map(item_setting_direction [which_setting][ID].x, 0, 360, 0, height) ;
}

// position
void setting_start_position(int ID, Vec3 pos) {
  int which_setting = 0 ;
  setting_start_position(ID, which_setting, (int)pos.x, (int)pos.y, (int)pos.z) ;
}

void setting_start_position(int ID, int pos_x, int pos_y, int pos_z) {
  int which_setting = 0 ;
  setting_start_position(ID, which_setting, pos_x, pos_y, pos_z) ;
}

void setting_start_position(int ID, int which_setting, int pos_x, int pos_y, int pos_z) {
  if(pos_item_final[ID] == null) pos_item_final[ID] = Vec3() ;
  pos_item_final[ID].x = pos_x -(width/2) ;
  pos_item_final[ID].y = pos_y -(height/2) ;
  pos_item_final[ID].z = pos_z ;
  if(item_setting_position [which_setting][ID] == null) item_setting_position [which_setting][ID] = Vec3() ;
  item_setting_position [which_setting][ID] = Vec3(pos_item_final[ID]) ;
  mouse[ID] = Vec3(pos_x, pos_y, pos_z) ;
}


/**
END SETUP
*/














/**
GET
*/
Vec3 get_pos_item(int id_item) {
  Vec3 pos = pos_item_final[id_item].copy() ;
  return pos.add(width/2, height/2,0) ;
}

Vec3 get_dir_item(int id_item) {
  return dir_item_final[id_item] ;
}
/**

*/













/**
ITEM CAMERA

POSITION – DIRECTION 1.0.1

final position and direction for the items

Master and follower updating

*/

void item_move(boolean movePos, boolean moveDir, int ID) {
  //position
  if (!movePos) {
    update_ref_position_mouse() ;
    update_ref_position(posObj[ID], ID) ;
  }
  Vec3 newPos = update_position_item(posObj[ID], ID, movePos) ;
  pos_item_final[ID].set(newPos) ;

  //direction
  if (!moveDir) {
    update_ref_direction_mouse() ;
    update_ref_direction(ID) ;
  }
  //speed rotation
  float speed = width / 10 ; // 150 is medium speed rotation
  Vec2 speedDirectionOfObject = Vec2(speed /(float)width, speed /(float)height) ;
  
  dir_item_final[ID].set(update_direction_item(speedDirectionOfObject, ID, moveDir)) ;




/*
  master_ID = new int[NUM_ITEM] ;
  follower = new boolean[NUM_ITEM] ;
  */

  //RESET
  if(key_0) {
    pos_item_final[ID].set(item_setting_position [0][ID]);
    dir_item_final[ID].set(item_setting_direction [0][ID]) ;
    
    temp_item_canvas_direction[ID].set(0) ;
    reset_camera_direction_item[ID] = true ;
    int which = 0 ;
    reset_direction_item(which, ID) ; 
  }

  add_ref_item(ID) ;
}



void item_follower(int ID) {
  if(follower[ID]) {
    int ID_master = master_ID[ID] ;
    action[ID] = action[ID_master] ; 
  }
  add_ref_item(ID) ;
}



/**
Create ref position
*/
void add_ref_item(int ID) {
  posObj[ID] = Vec3(pos_item_final[ID]) ;
  dirObj[ID] = Vec3(dir_item_final[ID]);
}

/**
reset
*/
void reset_direction_item (int which_setting, int ID) {
  if(reset_camera_direction_item[ID]) {
    if(item_setting_direction[which_setting][ID] == null) {
      item_setting_direction[which_setting][ID] = Vec3() ;
    }
    temp_item_canvas_direction[ID].x = map(item_setting_direction [which_setting][ID].y, 0, 360, 0, width) ;

    temp_item_canvas_direction[ID].y = map(item_setting_direction [which_setting][ID].x, 0, 360, 0, height) ;
    update_ref_direction_mouse() ;
  }
}






/**
Update direction item
*/
Vec3 direction_mouse_ref;
void update_ref_direction_mouse() {
  if(direction_mouse_ref == null) direction_mouse_ref = Vec3() ;
  if(mouse[0] == null) mouse[0] = Vec3() ;

  direction_mouse_ref.x = mouse[0].x ;
  direction_mouse_ref.y = mouse[0].y ;
  // special op with the wheel value, because this value is not constant
  direction_mouse_ref.z = 0 ;
  direction_mouse_ref.z -= wheel[0] ;
}


void update_ref_direction(int ID) {
  if(dir_reference_items[ID] == null) {
    dir_reference_items[ID] = Vec3(temp_item_canvas_direction[ID]) ; 
  } else {
    dir_reference_items[ID].set(temp_item_canvas_direction[ID]) ;
  }
}


Vec3 update_direction_item(Vec2 speed, int ID, boolean authorization) {
  if(authorization) {
  //to create a only one ref position
    //create the delta between the ref and the mouse position
    Vec3 delta = Vec3() ;
    if(!reset_camera_direction_item[ID]) {
      delta = sub(mouse[0], direction_mouse_ref) ;
      temp_item_canvas_direction[ID] = add(delta, dir_reference_items[ID]) ;
      //rotation of the camera
      dirObj[ID].set(direction_canvas_to_polar(temp_item_canvas_direction[ID])) ;
    } else {
      dirObj[ID].set(direction_canvas_to_polar(temp_item_canvas_direction[ID])) ;
      reset_camera_direction_item[ID] = false ;
    }
  } 
  return dirObj[ID] ;
}




/**
Update position item
*/
Vec3 position_mouse_ref = Vec3() ;

void update_ref_position_mouse() {
  position_mouse_ref.x = mouse[0].x ;
  position_mouse_ref.y = mouse[0].y ;
  // special op with the wheel value, because this value is not constant
  position_mouse_ref.z = 0 ;
  position_mouse_ref.z -= wheel[0] ;
}

void update_ref_position(Vec3 pos, int ID) {
  posObjRef[ID].set(pos.x, pos.y, pos.z) ;
}

Vec3 update_position_item(Vec3 pos, int ID, boolean authorization) {
  Vec3 delta = Vec3() ;
  // Z position with the wheel
  delta.z = wheel[0] -position_mouse_ref.z ;
  // X et Y pos with the mouse coordonate
  if (authorization) {
    //to create a only one ref position
    //create the delta between the ref and the mouse position
    delta.x = mouse[0].x -position_mouse_ref.x ;
    delta.y = mouse[0].y -position_mouse_ref.y ;
  } 

  // special op with the wheel value
  delta.z *= -1. ;

  // PVector temp_pos = PVector.add(new PVector(posObjRef[ID].x,posObjRef[ID].y,posObjRef[ID].z), delta) ;
  pos = add(posObjRef[ID], delta) ;
  return pos ;
}


/**
nd update position item
*/




/**
FINAL POSITION
*/
void final_pos_item(int ID) {
  translate(pos_item_final[ID]) ;
  rotateX(radians(dir_item_final[ID].x)) ;
  rotateY(radians(dir_item_final[ID].y)) ;
}

































































/**
MOVE CAMERA GLOBAL 
v 1.1.2
*/
/**
METHOD Variable update variable camera
*/
float dirCamX,dirCamY,dirCamZ,
      centerCamX,centerCamY,centerCamZ,
      upX,upY,upZ ;
float focal, deformation ;

Vec3 finalSceneCamera ;
Vec2 finalEyeCamera ;

boolean reset_camera_romanesco ;

// init var
void initVariableCamera() {
  final_camera_low_rendering() ;
}

/**
Main method camera draw
*/
void camera_romanesco_draw() {
  update_camera_romanesco(LEAPMOTION_DETECTED) ;
  // set camera variable
  /* look if the user is on the Prescene or not, and other stuff to display the good views */
  set_var_camera_romanesco() ;

  // deformation and focal of the lenz camera
  paralaxe(focal, deformation) ;
  
  //camera order from the mouse or from the leap
  order_camera() ;

  startCamera() ;
  
  //to change the scene position with a specific point
  if(gotoCameraPosition || gotoCameraEye ) {
    moveCamera(sceneCamera, targetPosCam, speed_camera_romanesco) ;
  }

  //catch ref camera
  catchCameraInfo() ;
}





/**
Annexe method of the method camera_romanesco_draw() 1.0.3
*/
void set_var_camera_romanesco() {
  // float focal = map(valueSlider[0][19],0,360,28,200) ;

  /* this method need to be on the Prescene sketch and on the window.
  1. boolean prescene : On prescene, because on Scene we don't need to have a global view : boolean prescene
  2. boolean MOUSE_IN_OUT : because if we mode out the sketch the keyevent is not updated, and the camera stay in camera view */
  if(FULL_RENDERING || (key_c_long && (MOUSE_IN_OUT || clickLongLeft[0] || clickLongRight[0]) && prescene)) {
    final_camera_full_rendering() ; 
  } else {
    final_camera_low_rendering() ;
  }
}

void final_camera_full_rendering() {
    // world rendering
  focal = map(valueSlider[0][19],0,360,28,200) ;
  deformation = map(valueSlider[0][20],0,360,-1,1) ;
  // camera
  dirCamX = map(valueSlider[0][21],0,360,0,width)  ; // on controler is Eye X
  dirCamY = map(valueSlider[0][22],0,360,0,height)  ; // on controler is Eye Y
  dirCamZ = map(valueSlider[0][23],0,360,0,width)  ; // on controler is Eye Z
  
  centerCamX = map(valueSlider[0][24],0,360,0,width)  ; // on controler is Position X
  centerCamY = map(valueSlider[0][25],0,360,0,height)  ; // on controler is Position Y
  centerCamZ = map(valueSlider[0][26],0,360,0,width)  ; // on controler is Position Z

  upX = map(valueSlider[0][27],0,360,-1,1) ;
  upY = 1 ; // not interesting
  upZ = 0 ; // not interesting

  // displacement of the scene
  Vec3 displacement_scene = Vec3(width/2, height/2, 0) ;
  
  // Check the special move camera
  Vec3 compare_pos_scene = sub(finalSceneCamera, sceneCamera) ;
  



  boolean specialMoveCamera = false ; ;
  // displacement scene
  if(!compare_pos_scene.equals(displacement_scene)) {
    specialMoveCamera = true ; 
  } 
  // inertia
  if(motion_translate.velocity_is() || motion_rotate.velocity_is()) {
    specialMoveCamera = true ; 
  }

  if(reset_camera_romanesco) {
    specialMoveCamera = true ; 
    reset_camera_romanesco = false ;
  }
  




  // final camera translate postion
  if (check_cursor_translate(key_c_long) || specialMoveCamera ) {
    if(finalSceneCamera == null) {
      finalSceneCamera = Vec3 (add(sceneCamera, displacement_scene)) ;
    } else {
      finalSceneCamera.set(add(sceneCamera, displacement_scene)) ;
    }
  }
  // final camera rotate position / eye camera
  if (check_cursor_rotate(key_c_long) || specialMoveCamera ) { 
    if(finalEyeCamera == null) {
      finalEyeCamera = Vec2 (radians(eyeCamera.x), radians(eyeCamera.y) ) ;
    } else {
      finalEyeCamera.set(radians(eyeCamera.x), radians(eyeCamera.y) ) ;
    }    
  }
}


void final_camera_low_rendering() {
      // default setting camera from Processing.org example, like the camera above
    /*
    float dirCamX = width/2.0 ; // eye X
    float dirCamY = height/2.0 ; // eye Y
    float dirCamZ = (height/2.0) / tan(PI*30.0 / 180.0) ; // // eye Z
    float centerCamX = width/2.0 ; // Position X
    float centerCamY = height/2.0 ; // Position Y
    float centerCamZ = 0 ; // Position Z
    float upX = 0 ;
    float upY = 1 ;
    float upZ = 0 ;
    */
     // world rendering
    focal = 40 ; // 28-200
    deformation = 0 ; // -1 to 1 
    // camera
    dirCamX = width/2.0 ; // eye X
    dirCamY = height/2.0 ; // eye Y
    dirCamZ = (height/2.0) / tan(PI*30.0 / 180.0) ; // eye Z
    
    centerCamX = width/2.0 ; // Position X
    centerCamY = height/2.0 ; // Position Y
    centerCamZ = 0 ; // Position Z
    
    upX = 0 ;
    upY = 1 ;
    upZ = 0 ;
        // final camera position
    finalSceneCamera = new Vec3 (width/2, height, -width) ;
    float longitude = -45 ;
    float latitude = 0 ;
    finalEyeCamera = new Vec2 (longitude, latitude) ;

}



//CATCH a ref position and direction of the camera
Vec3 posCamRef = Vec3() ;
Vec3 eyeCamRef = Vec3() ;
//boolean security to catch the reference camera when you reset the position of this one
boolean catchCam = true ;

void catchCameraInfo() {
  if(catchCam) {
    posCamRef = getPosCamera() ;
    eyeCamRef = getEyeCamera() ;
  }
  catchCam = false ;
}
//END catch position



//camera order from the mouse or from the leap
void order_camera() {
  boolean authorization = key_c_long ;

  if(authorization) {
    if(ORDER_ONE || ORDER_THREE) {
      moveScene = true ; 
    } else {
      moveScene = false ;
    } 
    if(ORDER_TWO || ORDER_THREE) {
      moveEye = true ; 
    } else {
      moveEye = false ;
    }
      
    //update z position of the camera
    sceneCamera.z -= wheel[0] ;
      
    // change camera position
    if(key_enter) travelling(posCamRef) ;
    if (key_0) {
      reset_camera(0) ;
    }
  } else if (!authorization || (ORDER_ONE && ORDER_ONE && ORDER_THREE) ) {
    moveScene = false ;
    moveEye = false ;
  }  
}


//start camera with speed setting
boolean switch_rotate_YZ ;

void startCamera() {
  pushMatrix() ;
  camera(dirCamX, dirCamY, dirCamZ, centerCamX, centerCamY, centerCamZ, upX, upY, upZ) ;
  beginCamera() ;
  // scene position
  translate(finalSceneCamera) ;
  // translate(0,0,0) ;
  // scene orientation direction
  /* eyeCamera, is not a good terminilogy because the real eye camera is not use here. Here we just move the world. */
  rotateX(finalEyeCamera.x) ;
  if(key_b) {
    if(switch_rotate_YZ) {
      switch_rotate_YZ = false; 
    } else {
      switch_rotate_YZ = true ;
    }
  }

  if(switch_rotate_YZ) {
    rotateY(finalEyeCamera.y) ;
    rotateZ(0) ;
  } else {
    rotateY(0) ;
    rotateZ(finalEyeCamera.y) ;
  }

  // you find popMatrix() in the method stopCamera() ;
}

//stop
void stopCamera() {
  popMatrix() ;
  endCamera() ;
  stopParalaxe() ;
}





// update the position of the scene (camera) and the orientation
Vec3 cursor_final_translate ;
Vec3 cursor_final_rotate ;
Vec3 mouse_ref_inertia_translate ;
Vec3 mouse_ref_inertia_rotate ;

int wheelCheckRef = 0 ;

boolean reset_inertia = true ;
boolean cursor_move_scene_is = false ;
boolean cursor_move_eye_is = false ;

void update_camera_romanesco(boolean leapMotion) {
  if(cursor_final_translate == null) cursor_final_translate = mouse[0].copy() ;
  if(cursor_final_rotate == null) cursor_final_rotate = mouse[0].copy() ;
  if(mouse_ref_inertia_translate == null) mouse_ref_inertia_translate = mouse[0].copy() ;
  if(mouse_ref_inertia_rotate == null) mouse_ref_inertia_translate = mouse[0].copy() ;

  // make ref
  if(key_c_long) {
    if (moveScene) {
      mouse_ref_inertia_translate = mouse[0].copy() ; 
    } 
    if (moveEye) {
      mouse_ref_inertia_rotate = mouse[0].copy() ; 
    }
  } 
  
  // create new pos
  if(key_c_long) { 
    // scene / translate
    if(moveScene || motion_translate.velocity_is()) {
      cursor_final_translate.set(update_cursor(motion_translate, mouse_ref_inertia_translate, cursor_final_translate)) ;
      cursor_move_scene_is = true ;
    } else {
      cursor_move_scene_is = false ;
    }

    // eye / rotate
    if(moveEye || motion_rotate.velocity_is()) {
      cursor_final_rotate.set(update_cursor(motion_rotate, mouse_ref_inertia_rotate, cursor_final_rotate)) ;
      cursor_move_eye_is = true ;
    } else {
      cursor_move_eye_is = false ;
    }
  } else {
    if(motion_translate.velocity_is()) {
      cursor_final_translate.set(update_cursor(motion_translate, mouse_ref_inertia_translate, cursor_final_translate)) ;
    }

    // eye / rotate
    if(motion_rotate.velocity_is()) {
      cursor_final_rotate.set(update_cursor(motion_rotate, mouse_ref_inertia_rotate, cursor_final_rotate)) ;
    } 
  }

  //update pos
  update_position_camera(cursor_move_scene_is, leapMotion, cursor_final_translate) ;
  update_direction_camera(cursor_move_eye_is, cursor_final_rotate) ;

  // reset inertia
  if(reset_inertia) {
    motion_translate.reset() ;
    motion_rotate.reset() ;
    reset_inertia = false ;
  } 

  if(key_space_long) {
    reset_inertia = true ;   
  } 
}

Vec3 update_cursor(Motion motion, Vec3 ref, Vec3 cursor_final) {
  return motion.leading(ref, cursor_final) ;
}

/**
check camera
*/
// check if the mouse move or not, it's use to update or not the position of the world.
// we must use that to don't update the scene when we load the save scene setting

// translate
Vec3 mouse_camera_translate_ref  ;
boolean check_cursor_translate(boolean authorization) {
  boolean cursor_move_is ;
  if(authorization && (!equals(mouse_camera_translate_ref, cursor_final_translate) || wheelCheckRef != wheel[0])) {
    cursor_move_is = true ; 
  } else {
    cursor_move_is = false ;
  }

  // create ref
  wheelCheckRef = wheel[0] ;
  if(mouse_camera_translate_ref == null) {
    mouse_camera_translate_ref = cursor_final_translate.copy();
  } else {
    mouse_camera_translate_ref.set(cursor_final_translate) ;
  }
  return cursor_move_is ;
}

// rotate
Vec3 mouse_camera_rotate_ref  ;
boolean check_cursor_rotate(boolean authorization) {
  boolean cursor_move_is ;
  if(authorization && (!equals(mouse_camera_rotate_ref, cursor_final_rotate) || wheelCheckRef != wheel[0])) {
    cursor_move_is = true ; 
  } else {
    cursor_move_is = false ;
  }

  // create ref
  wheelCheckRef = wheel[0] ;
  if(mouse_camera_rotate_ref == null) {
    mouse_camera_rotate_ref = cursor_final_rotate.copy();
  } else {
    mouse_camera_rotate_ref.set(cursor_final_rotate) ;
  }
  return cursor_move_is ;
}





// move camera to target
void moveCamera(Vec3 origin, Vec3 target, float speed) {
  if(!moveScene) {
    sceneCamera = follow(origin, target, speed) ;
  }
  if(!moveEye && (gotoCameraPosition || gotoCameraEye)) {
    eyeCamera = backEye()  ;
  }
}


// CHANGE CAMERA POSITION
void reset_camera(int ID) {
  eyeCamera.set(eyeCameraSetting[ID]) ;
  sceneCamera.set(sceneCameraSetting[ID]) ;

  tempEyeCamera.set(0) ;
  gotoCameraPosition = false ;
  gotoCameraEye = false ;

  motion_translate.reset() ;
  motion_rotate.reset() ;

  cursor_final_translate.set(mouse[0]) ;
  cursor_final_rotate.set(mouse[0]) ;
  mouse_ref_inertia_translate.set(mouse[0]) ;
  mouse_ref_inertia_translate.set(mouse[0]) ;

  reset_camera_romanesco = true ;

  update_direction_camera(true, eyeCamera) ;
  update_position_camera(true, false, sceneCamera) ;
}













//GET
Vec3 getEyeCamera() { return eyeCamera ; }
Vec3 getPosCamera() { return sceneCamera ; }




//INIT FOLLOW
float distFollowRef = 0 ;
Vec3 eyeBackRef = Vec3() ;
//travelling with only camera position
void travelling(Vec3 target) {
  distFollowRef = dist(target, sceneCamera) ;
  
  targetPosCam = target ; 
  eyeBackRef = getEyeCamera() ;
  absPosition = new PVector() ;
  gotoCameraPosition = true ;
  gotoCameraEye = true ;
}
//END INIT FOLLOW



float speedX  ;
float speedY  ;
    
Vec3 backEye() {
  Vec3 eye = Vec3() ;

  if(gotoCameraEye) {
    if(currentDistToTarget > 2 ) {
      travellingPriority = true ;
      if (eyeBackRef.x < 180 ) eye.x = map(currentDistToTarget,distFollowRef, 0,eyeBackRef.x, 0) ; else eye.x = map(currentDistToTarget,distFollowRef, 0,eyeBackRef.x, 360) ;
      if (eyeBackRef.y < 180 ) eye.y = map(currentDistToTarget,distFollowRef, 0,eyeBackRef.y, 0) ; else eye.y = map(currentDistToTarget,distFollowRef, 0,eyeBackRef.y, 360) ;
      //stop the calcul
      if(eye.x < 2 || eye.x > 358 ) eye.x = 0 ;
      if(eye.y < 2 || eye.y > 358 ) eye.y = 0 ; 
      if(eye.x == 0  && eye.y == 0) {
        gotoCameraEye = false ;
        travellingPriority = false ;
      }
    } else {
      //speed of the eye to return to original position
      float speedBackEye = 0.2 ;
      float ratioX = eyeBackRef.x / frameRate *speedBackEye ;
      float ratioY = eyeBackRef.y / frameRate *speedBackEye ;
      speedX += ratioX ;
      speedY += ratioY ;
      if (eyeBackRef.x < 180 && !travellingPriority ) eye.x = eyeBackRef.x -speedX ; else eye.x  = eyeBackRef.x +speedX ;
      if (eyeBackRef.y < 180 && !travellingPriority ) eye.y = eyeBackRef.y -speedY ; else eye.y  = eyeBackRef.y +speedY ;
      // to stop the calcul
      if(eye.x < 2 || eye.x > 358 ) eye.x = 0 ;
      if(eye.y < 2 || eye.y > 358 ) eye.y = 0 ;  
      
      if(eye.x == 0  && eye.y == 0) {
        travellingPriority = false ;
        gotoCameraEye = false ;
        speedX = 0 ;
        speedY = 0 ;
      }
    }
  } 
  return eye ;
}


//MAIN VOID
PVector speedByAxes = new PVector() ;
//calculate new position to go at the new target camera
PVector distToTargetUpdated = new PVector () ;
float currentDistToTarget = 0 ;
PVector currentPosition = new PVector() ;
PVector absPosition = new PVector() ;

Vec3 follow(Vec3 origin, Vec3 target, float speed) {
  PVector PVorigin = new PVector(origin.x, origin.y, origin.z) ;
  PVector PVtarget = new PVector(target.x, target.y, target.z) ;
  return Vec3(follow(PVorigin, PVtarget, speed)) ;
}

PVector follow(PVector origin, PVector target, float speed) {
  //very weird I must inverse the value to have the good result !
  //and change again at the end of the algorithm
  target.x = -target.x ;
  target.y = -target.y ;
  target.z = -target.z ;
  
  //updated the distance in realtime
  distToTargetUpdated = PVector.sub(currentPosition, target) ;
  currentDistToTarget = PVector.dist(currentPosition, target) ;
  
  
  //calculate the speed to go to target
  PVector absValueOfDist = new PVector (abs(distToTargetUpdated.x),abs(distToTargetUpdated.y),abs(distToTargetUpdated.z));
  absValueOfDist.normalize() ;
  //speedByAxes = PVector.div(absValueOfDist, 1.0 / speed) ; 
  speedByAxes = PVector.mult(absValueOfDist, speed) ;
  // PVector rangeStop = PVector.mult(speedByAxes,5000) ;
  PVector rangeStop = new PVector(5,5,5) ; 
  //calculate the new absolute position

  //XYZ
  if ( (distToTargetUpdated.x > rangeStop.x || distToTargetUpdated.x < -rangeStop.x) && 
       (distToTargetUpdated.y > rangeStop.y || distToTargetUpdated.y < -rangeStop.y) && 
       (distToTargetUpdated.y > rangeStop.z || distToTargetUpdated.y < -rangeStop.z))  {
    if (origin.x < target.x )  absPosition.x += speedByAxes.x ;  else absPosition.x -= speedByAxes.x ;
    if (origin.y < target.y )  absPosition.y += speedByAxes.y ;  else absPosition.y -= speedByAxes.y ;
    if (origin.z < target.z )  absPosition.z += speedByAxes.z ;  else absPosition.z -= speedByAxes.z ;
  //XY  
  } else if ( (distToTargetUpdated.x > rangeStop.x || distToTargetUpdated.x < -rangeStop.x) && 
              (distToTargetUpdated.y > rangeStop.y || distToTargetUpdated.y < -rangeStop.y)) {
    if (origin.x < target.x )  absPosition.x += speedByAxes.x ;  else absPosition.x -= speedByAxes.x ;
    if (origin.y < target.y )  absPosition.y += speedByAxes.y ;  else absPosition.y -= speedByAxes.y ;
    absPosition.z += 0 ;
  //XZ
  } else if ( (distToTargetUpdated.x > rangeStop.x || distToTargetUpdated.x < -rangeStop.x) && 
              (distToTargetUpdated.y > rangeStop.z || distToTargetUpdated.y < -rangeStop.z))  {
    if (origin.x < target.x )  absPosition.x += speedByAxes.x ;  else absPosition.x -= speedByAxes.x ;
    absPosition.y += 0 ;
    if (origin.z < target.z )  absPosition.z += speedByAxes.z ;  else absPosition.z -= speedByAxes.z ;
  //YZ
  } else if ( (distToTargetUpdated.y > rangeStop.y || distToTargetUpdated.y < -rangeStop.y) && 
              (distToTargetUpdated.y > rangeStop.z || distToTargetUpdated.y < -rangeStop.z))  {
    absPosition.x += 0 ;
    if (origin.y < target.y )  absPosition.y += speedByAxes.y ;  else absPosition.y -= speedByAxes.y ;
    if (origin.z < target.z )  absPosition.z += speedByAxes.z ;  else absPosition.z -= speedByAxes.z ;
  //X
  } else if ( (distToTargetUpdated.x > rangeStop.x || distToTargetUpdated.x < -rangeStop.x)) {
    if (origin.x < target.x )  absPosition.x += speedByAxes.x ;  else absPosition.x -= speedByAxes.x ;
    absPosition.y += 0 ;
    absPosition.z += 0 ;
  //Y  
  } else if ( (distToTargetUpdated.y > rangeStop.y || distToTargetUpdated.y < -rangeStop.y))  {
    absPosition.x += 0 ;
    if (origin.y < target.y )  absPosition.y += speedByAxes.y ;  else absPosition.y -= speedByAxes.y ;
    absPosition.z += 0 ;
  //Z
  } else if ( (distToTargetUpdated.y > rangeStop.z || distToTargetUpdated.y < -rangeStop.z))  {
    absPosition.x += 0 ;
    absPosition.y += 0 ;
    if (origin.z < target.z )  absPosition.z += speedByAxes.z ;  else absPosition.z -= speedByAxes.z ;
  //IT'S DONE, NOTHING TO DO NOW
  } else {  
    absPosition.x += 0 ;
    absPosition.y += 0 ;
    absPosition.z += 0 ;
    gotoCameraPosition = false ;
  }
  
  //very weird I must inverse the value to have the good result !
  target.x = -target.x ;
  target.y = -target.y ;
  target.z = -target.z ;


  //finalize the newposition of the point
  currentPosition = PVector.add(origin, absPosition) ;
  
  return currentPosition ;
}
/**

END END MAIN CAMERA

*/
































/**

PERSPECTIVE

*/
void paralaxe() {
  float aspect = float(width)/float(height) ;
  float fov = 1.0 ;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, aspect, cameraZ *.02, cameraZ*100.0);
}


void paralaxe(float focal, float deformation) {
  // ratio deformation
  float aspect = float(width)/float(height) ;
  aspect += deformation ;
  // focal
  focal = constrain(focal, 28,200) ;
  focal = map(focal,28,200,140,5) ;
  float fov = radians(focal) ;
  // this algo is from Processing example
  float cameraZ = (height/2.0) / tan(fov/2.0);
  
  // this algo is from Processing example
  perspective(fov, aspect, cameraZ *.02, cameraZ*100.0);
}

// use to stop perspective correction for the info display
void stopParalaxe() {
  perspective() ;
}

























/**

GRID CAMERA WORLD 0.0.1

*/
//repere camera
void createGridCamera(boolean showGrid) {
  if(showGrid)  {
    float thickness = .1 ;


    // Very weird it's necessary to pass by PVector, if we don't do that when we use camera the grid disappear
    PVector size =  PVector.mult(SIZE_BG,.2) ;
    Vec3 size_grid = Vec3(size) ;
    size_grid.mult(1,1,5) ;

    int posTxt = 10 ;
    
    textSize(10) ;
    textAlign(LEFT, BOTTOM);
    strokeWeight(thickness) ;

    grid(size_grid) ;
    axe_x(size_grid, posTxt) ;
    axe_y(size_grid, posTxt) ;
    axe_z(size_grid, posTxt) ;
  }
}

// void axe_x(PVector size, int pos) {
void axe_x(Vec3 size, int pos) {
  fill(#D31216) ;
  stroke(#D31216) ; 

  text("X LINE XXX", pos,-pos) ;

  noFill() ;
  line( -size.x,0,0,
        size.x,0,0) ;

}
// void axe_y(PVector size, int pos) {
void axe_y(Vec3 size, int pos) {
    fill(#2DA308) ;
    stroke(#2DA308) ; 

    pushMatrix() ;
    rotateZ(radians(-90)) ;
    text("Y LINE YYY", pos, -pos) ;
    popMatrix() ;

    noFill() ;
    line( 0,-size.y,0,
          0,size.y,0) ;

}
// void axe_z(PVector size, int pos) {
void axe_z(Vec3 size, int pos) {
    fill(#EFB90F) ;
    stroke(#EFB90F) ; 

    pushMatrix() ;
    rotateY(radians(90)) ;
    text("Z LINE ZZZ", pos, -pos) ;
    popMatrix() ;

    noFill() ;
    line( 0,0,-size.z,
          0,0,size.z) ;

}

// void grid(PVector size) {
void grid(Vec3 size) {
  noFill() ;
  stroke(#596F91) ;
  // int size_grid = (int)size.z ;
  int step = 50 ;
  //horizontal grid
  for ( float i = -size.z ; i <= size.z ; i = i+step ) {
    if(i != 0 ) line( i, 0, -size.z, 
                      i, 0, size.z) ;
  }
}
/**
END display camera
*/




























/**

Camera Engine version 6.0.3

*/
private Vec3 posSceneMouseRef = Vec3 () ;
private Vec3 posEyeMouseRef = Vec3 () ;
private Vec3 posSceneCameraRef= Vec3 () ;
private Vec3 posEyeCameraRef = Vec3 () ;
private Vec3 eyeCamera = Vec3 () ;
private Vec3 sceneCamera = Vec3 () ;
private Vec3 deltaScenePos = Vec3 () ;
private Vec3 deltaEyePos = Vec3 () ;
private Vec3 tempEyeCamera = Vec3 () ;
private boolean newRefSceneMouse = true ;
private boolean newRefEyeMouse = true ;

// Update Camera position
/* We move the scene 
*/

void update_position_camera(boolean authorization, boolean leapMotionDetected, Vec3 pos_cursor) {
  if(authorization) {
    //create the ref to calcul the new position of the Scene
    if(newRefSceneMouse) {
      posSceneCameraRef.set(sceneCamera) ;
      posSceneMouseRef.set(pos_cursor) ;
      //to create a only one ref position
      newRefSceneMouse = false ;
    }

    //create the delta between the ref and the mouse position
    deltaScenePos = sub(pos_cursor, posSceneMouseRef) ;
    if (leapMotionDetected) {
      sceneCamera = add(deltaScenePos.mult(-1), posSceneCameraRef) ;
    } else {
      sceneCamera = add(deltaScenePos, posSceneCameraRef) ;
    }
  } else {
    //change the boolean to true for the next mousepressed
    newRefSceneMouse = true ;
  }
}
//


// Update Camera EYE position
void update_direction_camera(boolean authorization, Vec3 pos_cursor) {
  if(authorization) {
    //create the ref to calcul the new position of the Scene
    if(newRefEyeMouse) {
      posEyeCameraRef.set(tempEyeCamera) ;
      posEyeMouseRef.set(pos_cursor) ;
    }
    //to create a only one ref position
    newRefEyeMouse = false ;
    
    //create the delta between the ref and the mouse position
    deltaEyePos = sub(pos_cursor, posEyeMouseRef) ;
    tempEyeCamera = add(deltaEyePos, posEyeCameraRef ) ;

    // direction of the camera
   //  return direction_canvas_to_polar(tempEyeCamera) ;
    eyeCamera.set(direction_canvas_to_polar(tempEyeCamera)) ;
  } else {
    //change the boolean to true for the next mousepressed
    newRefEyeMouse = true ;
  }  
}


// EYE POSITION two solutions
/*
Solution 1
We must use this one with le leapmotion information, because with the leapmotion device
there is no "pmouse" information.
*/
Vec3 eyeMemory ;
Vec3 direction_canvas_to_polar(Vec3 direction_canvas) {
  float temp_dir_x = map(direction_canvas.y, 0, height, 0, 360) ;
  float temp_dir_y = map(direction_canvas.x, 0, width, 0, 360) ;
  Vec3 eyeP3D = Vec3(temp_dir_x, temp_dir_y, 0) ;
  return eyeP3D ;
}


/*
solution 2
we can use this better void when we don't use the leapmotion */

// Solution interesting but there is problem with it ??????????
PVector eyeAdvanced(PVector PreviousPos, PVector pos, PVector speed) {
  PVector eyeP3D = new PVector() ;
  // eyeP3D.x += (PreviousPos.y -pos.y) *speed.y;
  // eyeP3D.y += (PreviousPos.x -pos.x) *-speed.x;
  eyeP3D.x += (PreviousPos.y -pos.y) *speed.y;
  eyeP3D.y += (PreviousPos.x -pos.x) *-speed.x;
  
  if(eyeP3D.x > 360) eyeP3D.x = 0 ;
  if(eyeP3D.x < 0) eyeP3D.x = 360 ;
  if(eyeP3D.y > 360) eyeP3D.y = 0 ; 
  if(eyeP3D.y < 0) eyeP3D.y = 360 ;
  return eyeP3D ;
}






