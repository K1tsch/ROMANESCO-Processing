// ALGEBRE
//roots dimensions n
float roots(float valueToRoots, int n) {
  return pow(valueToRoots, 1.0/n) ;
}





//GEOMATRY
// EQUATION CIRLCE
float perimeterCircle ( int r ) {
  float p = 2*r*PI  ;
  return p ;
}


float radiusSurface(int surface) {
  // calcul the radius from circle surface
  return sqrt(surface/PI);
}


// END EQUATION CIRCLE
//////////////////////




// normal direction 0-360 to -1, 1 PVector
PVector normalDir(int direction) {
  int numPoints = 360;
  float angle = TWO_PI/(float)numPoints;
  direction = 360-direction;
  direction += 180;
  return new PVector(sin(angle*direction), cos(angle*direction));
}
// degre direction from PVector direction
float deg360 (PVector dir) {
  float deg360 ;
  deg360 = 360 -(degrees(atan2(dir.x, dir.y)) +180)   ;
  return deg360 ;
}

//ROTATION
//GLOBAL
PVector resultPositionOfRotation = new PVector() ;
//DRAW

PVector rotation(PVector ref, PVector lattice, float angle) {
  float a = angle( lattice, ref ) + angle;
  float d = distance( lattice, ref );
  
  resultPositionOfRotation.x = lattice.x + cos( a ) * d;
  resultPositionOfRotation.y = lattice.y + sin( a ) * d;
  //
  return resultPositionOfRotation;
}

float angle(PVector p0, PVector p1) {
  return atan2( p1.y - p0.y, p1.x - p0.x );
}
  
float distance(PVector p0, PVector p1) {
  return sqrt( ( p0.x - p1.x ) * ( p0.x - p1.x ) + ( p0.y - p1.y ) * ( p0.y - p1.y ) );
}


//other Rotation
//Rotation Objet
void rotation (float angle, float posX, float posY ) {
  translate(posX, posY ) ;
  rotate (radians(angle) ) ;
}

//END OF ROTATION


// END EQUATION
///////////////



// PRIMITIVE SHAPE
//DISC
void disc( PVector pos, int diam, color c ) {
  for ( int i = 1 ; i < diam +1 ; i++) {
    circle(c, pos, i) ;
  }
}

void chromaticDisc( PVector pos, int diam ) {
  for ( int i = 1 ; i < diam +1 ; i++) {
    chromaticCircle(pos, i) ;
  }
}



//CIRCLE
void chromaticCircle(PVector pos, int d) {
  int surface = d*d ; // surface is equale of square surface where is the cirlcke...make sens ?

  int radius = ceil(radiusSurface(surface)) ;
  int numPoints = ceil(perimeterCircle( radius)) ;
  for(int i=0; i < numPoints; i++) {
      //circle
      float stepAngle = map(i, 0, numPoints, 0, 2*PI) ; 
      float angle =  2*PI - stepAngle;
      //color
      color c = color (i, 100,100) ;
      //display
      set(int(pointOnCirlcle(radius, angle).x + pos.x) , int(pointOnCirlcle(radius, angle).y + pos.y), c);
  }
}

// END DISC


// PRIMITIVE with "n" summits
void primitive(int x, int y, int radius, int summits) {
  if(summits < 3) summits = 3 ;
  PVector pos = new PVector (x,y) ;
  PVector [] summit = new PVector[summits] ;
  // create coord of the shape
  for (int i = 0 ; i < summits ; i++) {
    summit[i] = circle(pos, radius, summits)[i].copy() ; 
  }
  
  //draw the shape
  beginShape() ;
  for (int i = 0 ; i < summits ; i++) {
    vertex(summit[i].x, summit[i].y) ;
  }
  vertex(summit[0].x, summit[0].y) ;
  endShape() ;
}

// END PRIMITIVE SHAPE








// summits around the circle
PVector [] circle (PVector pos, int d, int num) {
  PVector [] p = new PVector [num] ;
  int surface = d*d ; 
  int radius = ceil(radiusSurface(surface)) ;
  
  // choice your starting point
  float startingAnglePos = PI*.5;
  if(num == 4) startingAnglePos = PI*.25;
  
  for( int i=0 ; i < num ; i++) {
    float stepAngle = map(i, 0, num, 0, TAU) ; 
    float angle =  TAU - stepAngle -startingAnglePos;
    p[i] = new PVector(pointOnCirlcle(radius, angle).x +pos.x,pointOnCirlcle(radius, angle).y + pos.y) ;
  }
  return p ;
}

PVector [] circle (PVector pos, int d, int num, float jitter) {
  PVector [] p = new PVector [num] ;
  int surface = d*d ; 
  int radius = ceil(radiusSurface(surface)) ;
  
  // choice your starting point
  float startingAnglePos = PI*.5;
  if(num == 4) startingAnglePos = PI*.25;
  
  float angleCorrection ; // this correction is cosmetic, when we'he a pair beam this one is stable for your eyes :)
  for( int i=0 ; i < num ; i++) {
    int beam = num /2 ;
    if ( beam%2 == 0 ) angleCorrection = PI / num ; else angleCorrection = 0.0 ;
    if ( num%2 == 0 ) jitter *= -1 ; else jitter *= 1 ; // the beam have two points at the top and each one must go to the opposate...
    
    float stepAngle = map(i, 0, num, 0, TAU) ;
    float jitterAngle = map(jitter, -1, 1, -PI/num, PI/num) ;
    float angle =  TAU -stepAngle +jitterAngle +angleCorrection -startingAnglePos;
    
    p[i] = new PVector(pointOnCirlcle(radius, angle).x +pos.x, pointOnCirlcle(radius, angle ).y +pos.y) ;
  }
  return p ;
}


//full cirlce
void circle(color c, PVector pos, int d) {
  int surface = d*d ; // surface is equale of square surface where is the cirlcke...make sens ?

  int radius = ceil(radiusSurface(surface)) ;
  int numPoints = ceil(perimeterCircle(radius)) ;
  for(int i=0; i < numPoints; i++) {
      float stepAngle = map(i, 0, numPoints, 0, 2*PI) ; 
      float angle =  2*PI - stepAngle;
      set(int(pointOnCirlcle(radius, angle).x + pos.x) , int(pointOnCirlcle(radius, angle).y + pos.y), c);
  }
}

//circle with a specific quantity points
void circle(color c, PVector pos, int d, int num) {
  int surface = d*d ; // surface is equale of square surface where is the cirlcke...make sens ?

  int radius = ceil(radiusSurface(surface)) ;
  for(int i=0; i < num; i++) {
      float stepAngle = map(i, 0, num, 0, 2*PI) ; 
      float angle =  2*PI - stepAngle;
      set(int(pointOnCirlcle(radius, angle).x + pos.x) , int(pointOnCirlcle(radius, angle).y + pos.y), c);
  }
}


//circle with a specific quantity points and specific shape for each point
void circle(PVector pos, int d, int num, PVector size, String shape) {
  int surface = d*d ; // surface is equale of square surface where is the cirlcke...make sens ?
  int whichShape = 0 ;
  if (shape.equals("point") )  whichShape = 0;
  else if (shape.equals("ellipse") )  whichShape = 1 ;
  else if (shape.equals("rect") )  whichShape = 2 ;
  else if (shape.equals("box") )  whichShape = 3 ;
  else if (shape.equals("sphere") )  whichShape = 4 ;
  else whichShape = 0 ;

  int radius = ceil(radiusSurface(surface)) ;
  for(int i=0; i < num; i++) {
    float stepAngle = map(i, 0, num, 0, 2*PI) ; 
    float angle =  2*PI - stepAngle;
    PVector newPos = new PVector(pointOnCirlcle(radius, angle).x + pos.x, pointOnCirlcle(radius, angle).y + pos.y) ;
    if(whichShape == 0 ) point(newPos.x, newPos.y) ;
    if(whichShape == 1 ) ellipse(newPos.x, newPos.y, size.x, size.y) ;
    if(whichShape == 2 ) rect(newPos.x, newPos.y, size.x, size.y) ;
    if(whichShape == 3 ) {
      pushMatrix() ;
      translate(newPos.x, newPos.y,0) ;
      box(size.x, size.y, size.z) ;
      popMatrix() ;
    }
    if(whichShape == 4 ) {
      pushMatrix() ;
      translate(newPos.x, newPos.y,0) ;
      int detail = (int)size.x /4 ;
      if (detail > 10 ) detail = 10 ;
      sphereDetail(detail) ;
      sphere(size.x) ;
      popMatrix() ;
    }
  }
}


PVector pointOnCirlcle(int r, float angle) {
  PVector posPix = new PVector () ;
  posPix.x = cos(angle) *r ;
  posPix.y = sin(angle) *r ;
  return posPix ;
}

// END GEOMETRY




// MISC
////////

// MAP
float mapLocked(float value, float sourceMin, float sourceMax, float targetMin, float targetMax) {
  if(sourceMax >= targetMax ) sourceMax = targetMax ;
  if (value < sourceMin ) value = sourceMin ;
  if (value > sourceMax ) value = sourceMax ;
  float newMax = sourceMax - sourceMin ;
  float deltaTarget = targetMax - targetMin ;
  float ratio = ((value - sourceMin) / newMax ) ;
  float result = targetMin +deltaTarget *ratio;
  return result; 
}

float mapStartSmooth(float value, float sourceMin, float sourceMax, float targetMin, float targetMax, int level) {
  if(sourceMax >= targetMax ) sourceMax = targetMax ;
  if (value < sourceMin ) value = sourceMin ;
  if (value > sourceMax ) value = sourceMax ;
  float newMax = sourceMax - sourceMin ;
  float deltaTarget = targetMax - targetMin ;
  float ratio = ((value - sourceMin) / newMax ) ;
  ratio = pow(ratio, level) ;
  float result = targetMin +deltaTarget *ratio;
  return result;
}

float mapEndSmooth(float value, float sourceMin, float sourceMax, float targetMin, float targetMax, int level) {
  if(sourceMax >= targetMax ) sourceMax = targetMax ;
  if (value < sourceMin ) value = sourceMin ;
  if (value > sourceMax ) value = sourceMax ;
  float newMax = sourceMax - sourceMin ;
  float deltaTarget = targetMax - targetMin ;
  float ratio = ((value - sourceMin) / newMax ) ;
  ratio = roots(ratio, level) ;
  float result = targetMin +deltaTarget *ratio;
  return result;
}


float mapEndStartSmooth(float value, float sourceMin, float sourceMax, float targetMin, float targetMax, int level) {
  if(sourceMax >= targetMax ) sourceMax = targetMax ;
  if (value < sourceMin ) value = sourceMin ;
  if (value > sourceMax ) value = sourceMax ;
  float newMax = sourceMax - sourceMin ;
  float deltaTarget = targetMax - targetMin ;
  float ratio = ((value - sourceMin) / newMax ) ;
  ratio = map(ratio,0,1, -1, 1 ) ;
  int correction = 1 ;
  if(level % 2 == 1 ) correction = 1 ; else correction = -1 ;
  if (ratio < 0 ) ratio = pow(ratio, level) *correction  ; else ratio = pow(ratio, level)  ;
  ratio = map(ratio, -1,1, 0,1) ;
  float result = targetMin +deltaTarget *ratio;
  return result;
}
// END MAP





// MATH PVECTOR
///////////////
// FOLLOW PVECTOR
PVector goToPosFollow = new PVector() ;
// CALCULATE THE POS of PVector Traveller, give the target pos and the speed to go.
PVector follow(PVector target, float speed) {
  // calcul X pos
  float targetX = target.x;
  float dx = targetX - goToPosFollow.x;
  if(abs(dx) != 0) {
    goToPosFollow.x += dx * speed;
  }
  // calcul Y pos
  float targetY = target.y;
  float dy = targetY - goToPosFollow.y;
  if(abs(dy) != 0) {
    goToPosFollow.y += dy * speed;
  }
  // calcul Z pos
  float targetZ = target.z;
  float dz = targetZ - goToPosFollow.z;
  if(abs(dz) != 0) {
    goToPosFollow.z += dz * speed;
  }
  return goToPosFollow ;
}


//////////////////////////////////////////////
// THIS PART MUST BE DEPRECaTED in the future

// CALCULATE THE POS of PVector Traveller
PVector gotoTarget(PVector origin,  PVector finish, float speed) {
  PVector pos = new PVector() ;
  if(origin.x > finish.x) pos.x = origin.x  -distanceDone(origin, finish, speed).x ; else pos.x = origin.x  +distanceDone(origin, finish, speed).x ; 
  if(origin.y > finish.y) pos.y = origin.y  -distanceDone(origin, finish, speed).y ; else pos.y = origin.y  +distanceDone(origin, finish, speed).y ; 
  if(origin.z > finish.z) pos.z = origin.z  -distanceDone(origin, finish, speed).z ; else pos.z = origin.z  +distanceDone(origin, finish, speed).z ; 
  return pos ;
}
// end calcultate




// DISTANCE DONE
PVector distance, distanceToDo ;
PVector distanceDone = new PVector() ;

PVector distanceDone(PVector origin,  PVector finish, float speedRef) {
  PVector dist = new PVector() ;
  PVector distance = new PVector() ;
  boolean stopX = false ;
  boolean stopY = false ;
  boolean stopZ = false ;
  distance.x = abs(finish.x - origin.x) ;
  distance.y = abs(finish.y - origin.y) ;
  distance.z = abs(finish.z - origin.z) ;
  //calcul the speed for XYZ
  PVector speed = new PVector(speedMoveTo(distance.x, speedRef), speedMoveTo(distance.y, speedRef), speedMoveTo(distance.z, speedRef)) ;
  // for the X
  dist.x = distance.x -distanceDone.x ;
  if(dist.x <= 0 ) stopX = true ; else stopX = false ;
  if(speed.x > dist.x ) speed.x = dist.x ;
  if(!stopX) distanceDone.x += speed.x ; else distanceDone.x = distance.x ;
  // for the Y
  dist.y = distance.y -distanceDone.y ;
  if(dist.y <= 0 ) stopY = true ; else stopY = false ;
  if(speed.y > dist.y ) speed.y = dist.y ;
  if(!stopY) distanceDone.y += speed.y ; else distanceDone.y = distance.y ;
  // for the Z
  dist.z = distance.z -distanceDone.z ;
  if(dist.z <= 0 ) stopZ = true ; else stopZ = false ;
  if(speed.z > dist.z ) speed.z = dist.z ;
  if(!stopZ) distanceDone.z += speed.z ; else distanceDone.z = distance.z ;
  //
  return distanceDone ;
}


float speedMoveTo(float distance, float speed) {
  return distance *1 *speed ;
}


// END of the deprecated function
/////////////////////////////////
