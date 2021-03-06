/**
UTIL
v 1.1.1
*/
/**
FONT
*/
public PFont 
      ///controller Font
      textUsual_1, textUsual_2, textUsual_3,
      titleMedium, titleBig,
      
      titleButtonMedium,
      title_dropdown_medium,
      
      FuturaExtraBold_9, FuturaExtraBold_10,
      FuturaCondLight_10, FuturaCondLight_11,FuturaCondLight_12,
      FuturaStencil_20 ;
      
//SETUP
void set_font() {
  //controller Font
  String path_font_gui = import_path+"font/default_font/" ;
  FuturaStencil_20 = loadFont(path_font_gui +"FuturaStencilICG-20.vlw");
  FuturaExtraBold_9 = loadFont(path_font_gui +"Futura-ExtraBold-9.vlw");
  FuturaExtraBold_10 = loadFont(path_font_gui +"Futura-ExtraBold-10.vlw");
  FuturaCondLight_10 = loadFont(path_font_gui +"Futura-CondensedLight-10.vlw");
  FuturaCondLight_11 = loadFont(path_font_gui +"Futura-CondensedLight-11.vlw");
  FuturaCondLight_12 = loadFont(path_font_gui +"Futura-CondensedLight-12.vlw");
  
  textUsual_1 = FuturaCondLight_10 ;
  textUsual_2 = FuturaCondLight_11 ;
  textUsual_3 = FuturaCondLight_12 ;

  
  titleMedium = FuturaExtraBold_10 ;
  titleBig = FuturaStencil_20 ;
  
  titleButtonMedium = titleMedium ;
  title_dropdown_medium = titleMedium ;
}



















/**
COLOR
*/
color rouge, rougeFonce, rougeTresFonce, rougeTresTresFonce,  
      orange, jauneOrange, jaune, 
      vert, vertClair, vertFonce, vertTresFonce,
      bleu,
      violet,
       
      blanc, blancGrisClair, blancGris, gris, grisClair, grisFonce, grisTresFonce, grisNoir, noirGris, noir,
      
      colorTextUsual, colorTitle ;

color col_on_in, col_on_out, col_off_in, col_off_out ;
//SETUP
void colorSetup() {
  colorMode (HSB, 360,100,100 ) ; 
  blanc = color(0,0,95) ;            
  blancGrisClair = color( 0,0,85) ;  
  blancGris = color( 0,0,75) ; 
  grisClair = color(0,0, 65) ;       
  gris = color(0,0,50) ;             
  grisFonce = color(0,0,40)  ;     
  grisTresFonce = color(0,0,30) ; 
  grisNoir = color(0,0,20) ;      
  noirGris = color (0,0,15) ;         
  noir = color (0,0,5) ;  
  vertClair = color (100,20,100) ;     
  vert = color(100,50,70) ; 
  vertFonce = color(100,100,50) ; 
  vertTresFonce = color(100,100,30) ;
  rougeTresFonce = color(10, 100, 50) ; 
  rougeTresTresFonce = color(10, 100, 46) ; 
  rougeFonce = color (10, 100, 70) ;  
  rouge = color(10,100,100) ;            
  orange = color (35,100,100) ; 
  jauneOrange = color (42,100,100) ; 
  jaune = color(50,100,100) ;

  colorTextUsual = grisNoir ; 
  colorTitle = noirGris ;
  // color button
  col_on_in = vert ;
  col_on_out = vertTresFonce ;
  col_off_in = orange ;
  col_off_out = rougeFonce ;
}






























/**
CHECK FOLDER
*/
ArrayList text_files = new ArrayList();
ArrayList bitmap_files = new ArrayList();
ArrayList svg_files = new ArrayList();
ArrayList movie_files = new ArrayList();


boolean folder_image_bitmap_selected = true ;
boolean folder_image_svg_selected = true ;
boolean folder_movie_selected = true ;
boolean folder_text_selected = true ;

void check_media_folder() {
  check_filter();
  check_file_text_folder();
  check_image_bitmap_folder();
  check_image_svg_folder();
  check_movie_folder();
}


void check_filter() {
  if(filter_dropdown_list == null) {
    String path = preference_path +"shader/shader_filter/filter_name.txt";
    String [] s = loadStrings(path);
    filter_dropdown_list = split(s[0],",");
  }
}

// main void
// check what's happen in the selected folder
void check_image_bitmap_folder() {
  if(frameCount%180 == 0) {
    bitmap_files.clear() ;
    String path = import_path +"bitmap";
    
    ArrayList allFiles = listFilesRecursive(path);
  
    String fileName = "";
    for (int i = 0; i < allFiles.size(); i++) {
      File f = (File) allFiles.get(i);   
      fileName = f.getName(); 
      // Add it to the list if it's not a directory
      if (f.isDirectory() == false) {
        String lastThree = fileName.substring(fileName.length()-3, fileName.length());
        if (lastThree.equals("PNG") || lastThree.equals("png") || lastThree.equals("JPG") || lastThree.equals("jpg") || lastThree.equals("GIF") || lastThree.equals("gif")) {
          bitmap_files.add(f);
        }
      }
    }
    // show the info name file
    for (int i = 0; i < bitmap_files.size(); i++) {
      File f = (File) bitmap_files.get(i); 
    }
    // to don't loop with this void
    folder_image_bitmap_selected = false ;
  }
}

void check_image_svg_folder() {
  if(frameCount%180 == 0) {
    svg_files.clear() ;
    String path = import_path +"svg" ;
    
    ArrayList allFiles = listFilesRecursive(path);
  
    String fileName = "";
    for (int i = 0; i < allFiles.size(); i++) {
      File f = (File) allFiles.get(i);   
      fileName = f.getName(); 
      // Add it to the list if it's not a directory
      if (f.isDirectory() == false) {
        String lastThree = fileName.substring(fileName.length()-3, fileName.length());
        if (lastThree.equals("SVG") || lastThree.equals("svg")) {
          svg_files.add(f);
        }
      }
    }
    // show the info name file
    for (int i = 0; i < svg_files.size(); i++) {
      File f = (File) svg_files.get(i); 
    }
    // to don't loop with this void
    folder_image_svg_selected = false ;
  }
}

void check_movie_folder() {
  if(frameCount%180 == 0) {
    movie_files.clear() ;
    String path = import_path +"movie" ;
    
    ArrayList allFiles = listFilesRecursive(path);
  
    String fileName = "";
    for (int i = 0; i < allFiles.size(); i++) {
      File f = (File) allFiles.get(i);   
      fileName = f.getName(); 
      // Add it to the list if it's not a directory
      if (f.isDirectory() == false) {
        String lastThree = fileName.substring(fileName.length()-3, fileName.length());
        if (lastThree.equals("MOV") || lastThree.equals("mov")) {
          movie_files.add(f);
        }
      }
    }
    // show the info name file
    for (int i = 0; i < movie_files.size(); i++) {
      File f = (File) movie_files.get(i); 
    }
    // to don't loop with this void
    folder_movie_selected = false ;
  }
}

void check_file_text_folder() {
  if(frameCount%180 == 0) {
    text_files.clear() ;
    
    String path = import_path +"Karaoke" ;
    
    ArrayList allFiles = listFilesRecursive(path);
  
    String fileName = "";
    for (int i = 0; i < allFiles.size(); i++) {
      File f = (File) allFiles.get(i);   
      fileName = f.getName(); 
      // Add it to the list if it's not a directory
      if (f.isDirectory() == false) {
        String lastThree = fileName.substring(fileName.length()-3, fileName.length());
        if (lastThree.equals("TXT") || lastThree.equals("txt")) {
          text_files.add(f);
        }
      }
    }
    // show the info name file
    for (int i = 0; i < text_files.size(); i++) {
      File f = (File) text_files.get(i); 
    }
    
    // to don't loop with this void
    folder_text_selected = false ;
  }
}



void update_media() {
  //text
  file_text_dropdown_list = new String[text_files.size()] ;
  for(int i = 0 ; i< file_text_dropdown_list.length ; i++) {
    File f = (File) text_files.get(i);
    file_text_dropdown_list[i] = f.getName() ;
    file_text_dropdown_list[i] = file_text_dropdown_list[i].substring(0, file_text_dropdown_list[i].length() -4) ;
  }
  // bitmap
  bitmap_dropdown_list = new String[bitmap_files.size()] ;
  for(int i = 0 ; i< bitmap_dropdown_list.length ; i++) {
    File f = (File) bitmap_files.get(i);
    bitmap_dropdown_list[i] = f.getName() ;
    bitmap_dropdown_list[i] = bitmap_dropdown_list[i].substring(0,bitmap_dropdown_list[i].length() -4) ;
  }

  // shape
  shape_dropdown_list = new String[svg_files.size()] ;
  for(int i = 0 ; i< shape_dropdown_list.length ; i++) {
    File f = (File) svg_files.get(i);
    shape_dropdown_list[i] = f.getName() ;
    shape_dropdown_list[i] = shape_dropdown_list[i].substring(0,shape_dropdown_list[i].length() -4) ;
  }

  // Movie
  movie_dropdown_list = new String[movie_files.size()] ;
  for(int i = 0 ; i < movie_dropdown_list.length ; i++) {
    File f = (File) movie_files.get(i);
    movie_dropdown_list[i] = f.getName() ;
    movie_dropdown_list[i] = movie_dropdown_list[i].substring(0,movie_dropdown_list[i].length() -4) ;
  }
}




// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } 
  else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// Function to get a list ofall files in a directory and all subdirectories
ArrayList listFilesRecursive(String dir) {
  ArrayList fileList = new ArrayList(); 
  recurseDir(fileList, dir);
  return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a, subfiles[i].getAbsolutePath());
    }
  } 
  else {
    a.add(file);
  }
}
















/**
DETECTION CURSOR
*/
boolean locked (boolean inside) {
  if (inside && mousePressed) return true ; else return false ;
}

















/**
CREDIT
*/
boolean insideNameversion ;
void credit() {
  if(mouseX > 2 && mouseX < 160 && mouseY > 3 && mouseY < 26 ) insideNameversion = true ; else insideNameversion = false ;
  if(insideNameversion && mousePressed) {
    String credit[] = loadStrings("credit.txt");
    
    fill(grisNoir,225) ; 
    int startBloc = 24 ;
    rect(0, startBloc, width, height - startBloc -9 ) ; // //GROUP ZERO
    for (int i = 0 ; i < credit.length; i++) {
      textFont(textUsual_3) ;
      fill(blanc) ;
      text(credit[i], 10,startBloc + 12 + ((i+1)*14));
    }
  }
}




















/**
Keyboard and Shortcut
v 1.0.1
*/

/**
SHORTCUTS
*/
void shortcuts_controller() {
  keyboard[keyCode] = true;
  if(checkKeyboard(157) && checkKeyboard(KeyEvent.VK_X) ) {
    println("CMD + X", frameCount) ;
    slider_mode_display += 1 ;
    if(slider_mode_display > 2 ) slider_mode_display = 0 ;
  }

  // save Scene
  check_Keyboard_save_scene_CURRENT_path() ;
  check_Keyboard_save_scene_NEW_path() ;
  // save controller
  check_Keyboard_save_controller_CURRENT_path() ;
  check_Keyboard_save_controller_NEW_path() ;
  // load
  check_Keyboard_load_scene() ;
  check_Keyboard_load_controller() ;

  check_keyboard_shift() ;
}









/**
KEYBOARD CONTROLLER 1.0.1
*/
boolean checkKeyboard(int c) {
  if (keyboard.length >= c) {
    return keyboard[c];  
  }
  return false;
}
/**
simple touch
*/
boolean shift_key ;
void check_keyboard_shift() {
  if(checkKeyboard(SHIFT)) { 
    shift_key = true ;
    keyboard[keyCode] = false ; 
  }
}

void key_false() {
  shift_key = false ;
}

/**
LOAD SAVE
*/
boolean load_Scene_Setting, save_Current_Scene_Setting, save_New_Scene_Setting ;
/**
LOAD
*/
void check_Keyboard_load_scene() {
  if(checkKeyboard(CONTROL) && checkKeyboard(KeyEvent.VK_L) ) { 
    println("CTRL + L", frameCount) ;
    load_Scene_Setting = true ;
    keyboard[keyCode] = false;   //
    
  }
}

void check_Keyboard_load_controller() {
  if(checkKeyboard(CONTROL) && checkKeyboard(KeyEvent.VK_O) ) { 
    println("CTRL + O", frameCount) ;
    selectInput("Load setting controller", "load_setting_controller"); // ("display info in the window" , "name of the method callingBack" )
    keyboard[keyCode] = false;   //
    
  }
}



/**
SAVE
*/
void check_Keyboard_save_scene_CURRENT_path() {
  if(checkKeyboard(CONTROL) && checkKeyboard(KeyEvent.VK_D) ) {
    println("CTRL + D", frameCount) ;
    save_Current_Scene_Setting = true ;
    keyboard[keyCode] = false ;   // just open one window, when use only the keyboard, if you don't use that open all the windows save and open
   }
}
// Scene new save
void check_Keyboard_save_scene_NEW_path() {
  if(checkKeyboard(CONTROL) && checkKeyboard(KeyEvent.VK_S) ) {
    println("CTRL + S", frameCount) ;
    save_New_Scene_Setting = true ;
    keyboard[keyCode] = false ;   // just open one window, when use only the keyboard, if you don't use that open all the windows save and open
  }
}


void check_Keyboard_save_controller_CURRENT_path() {
  if(checkKeyboard(CONTROL) && checkKeyboard(KeyEvent.VK_R) ) {
    println("CTRL + R", frameCount) ;
    show_all_slider_item = true ;
    if (savePathSetting.equals("")) {
      File tempFileName = new File ("your_controller_setting.csv");
      selectOutput("Save setting", "saveSetting", tempFileName);
    } else saveSetting(savePathSetting) ;

    keyboard[keyCode] = false ;   // just open one window, when use only the keyboard, if you don't use that open all the windows save and open
  }
}
// Controller new save
// CTRL + SHIFT + E
void check_Keyboard_save_controller_NEW_path() {
  if(checkKeyboard(CONTROL) && checkKeyboard(KeyEvent.VK_E) ) {
    println("CTRL + E", frameCount) ;
    show_all_slider_item = true ; 
    File tempFileName = new File ("your_controller_setting.csv");
    selectOutput("Save setting", "saveSetting", tempFileName);
    keyboard[keyCode] = false ;   // just open one window, when use only the keyboard, if you don't use that open all the windows save and open
  }

}

