/**
Romanesco Unu
2012 – 2018
version  1.3.0
release 30 
Processing 3.3.7
*/
/**
2015 730 lines of code the 4th may !!!! 
2016 830 lines may 2016
 */
String version = ("31") ;
String prettyVersion = ("1.3.0") ;
String nameVersion = ("Romanesco unu") ;

/**
use this trick to export in 64 bits
lighter application only 46M versus 164M
*/
// import processing.video.*;


void settings() {
  size(400, 220);
}


void setup() {
  color_setup() ;
  display_setup() ;
  
  set_structure() ;
  set_data() ;
}



void draw() {
  surface.setTitle(nameVersion + " " +prettyVersion+"."+version+ " - Launcher");
  launcher_background() ;
  launcher_update() ;
  open_controller() ;
}









//MOUSEPRESSED
void mousePressed() {
  //which type of SCENE display full screen or window
  //to re-init the button
  if (buttonFullscreen.inside || buttonWindow.inside || renderer[0].inside || renderer[1].inside || renderer[2].inside) {
    for(int i = 0 ; i < renderer.length ; i++) {
      renderer[i].OnOff = false ;
    }

    buttonFullscreen.OnOff = false ;
    buttonWindow.OnOff = false ;
  }
  // after the re-init we can check what's happen on the button
  for(int i = 0 ; i < renderer.length ; i++) {
    renderer[i].mouseClic() ;
  }

  buttonFullscreen.mouseClic() ;
  buttonWindow.mouseClic() ;
  
  //which screen for the fullscreen mode
  if(buttonFullscreen.OnOff) whichScreenPressed() ;
  
  //button start
  buttonStart.mouseClic() ;
  if(buttonStart.OnOff ) {
    save_app_properties();
    openApp() ;
  }
  buttonStart.OnOff = false ;
}


//MOUSELEASED
void mouseReleased() {
  if(buttonFullscreen.OnOff) whichScreenReleased() ;
}