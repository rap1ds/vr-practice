/* Interactive objects.
   Write your dynamic and interactive element classes here */

/**
 * This is how you define a new kind of Physical object with its own physical
 * behavior and own graphics rendering method.
 */
public class ImmaterialSphere extends PhysicalObject
{
  ImmaterialSphere(float radius, float startX, 
              float startY, float startZ, int sphereColor)
  {
    // This object takes no part in the JBullet's physical simulation because
    // of the PhysicalObject.IMMATERIAL flag. The PhysicalObject constructor
    // with 7 arguments creates a sphere shape, whereas the constructor with 
    // 9 arguments creates a box shape
    super(radius, 1 /* mass */, startX, startY, startZ,
        sphereColor, PhysicalObject.IMMATERIAL_OBJECT         );
  }
  
  // Redefine PhysicalObject's renderAtOrigin() method, which draws graphics
  // without any previous translations or rotations
  public void renderAtOrigin()
  {
    // Call PhysicalObject's default draw method
    super.renderAtOrigin();
    
    // Add some graphical details (2 white boxes around the sphere) 
    fill(color(255));
    noStroke();
    rotateX(0.25f*PI);
    pushMatrix();
    translate( super.radius, 0, 0);
    box(0.2f*super.radius, 0.4f*super.radius, 0.4f*super.radius);
    popMatrix();
    pushMatrix();
    translate(-super.radius, 0, 0);
    box(0.2f*super.radius, 0.4f*super.radius, 0.4f*super.radius);
    popMatrix();
  }
}

public class TextureCube extends PhysicalObject
{
  PImage textureImage;
  
  TextureCube(PVector dim, PVector loc) {
    super(dim.x, dim.y, dim.z, 1, loc.x, loc.y, loc.z, color(255), PhysicalObject.IMMATERIAL_OBJECT);
    
    textureImage = imageReader.nextImage();
  }
  
  public void renderAtOrigin() {
    noStroke();
    
    pushMatrix();
    scale(super.width, super.height, super.depth);
    
    beginShape(QUADS);

    texture(this.textureImage);
    textureMode(NORMALIZED);
    
    // front
    vertex(-1, 1, 1, 0,1);
    vertex( 1, 1, 1, 1,1);
    vertex( 1,-1, 1, 1,0);
    vertex(-1,-1, 1, 0,0);
    
    // back
    vertex( 1, 1,-1, 0,1);
    vertex(-1, 1,-1, 1,1);
    vertex(-1,-1,-1, 1,0);
    vertex( 1,-1,-1, 0,0);
    
    // right
    vertex( 1, 1, 1, 0,1);
    vertex( 1, 1,-1, 1,1);
    vertex( 1,-1,-1, 1,0);
    vertex( 1,-1, 1, 0,0);
    
    // left
    vertex(-1, 1,-1, 0,1);
    vertex(-1, 1, 1, 1,1);
    vertex(-1,-1, 1, 1,0);
    vertex(-1,-1,-1, 0,0);
    
    // bottom
    vertex(-1, 1,-1, 0,1);
    vertex( 1, 1,-1, 1,1);
    vertex( 1, 1, 1, 1,0);
    vertex(-1, 1, 1, 0,0);
    
    // top
    vertex(-1,-1, 1, 0,1);
    vertex( 1,-1, 1, 1,1);
    vertex( 1,-1,-1, 1,0);
    vertex(-1,-1,-1, 0,0);
    
    endShape();
    
    popMatrix();
  }
}
/**
 * This is how you define a new kind of PhysicalObject with its own physical
 * behavior and own graphics rendering method.
 */
public class BaconSlice extends PhysicalObject
{
  PImage textureImage;
  
  BaconSlice(float width, float height, float startX, float startY, 
             float startZ                                          )
  {
    // This object behaves like a rigid object in JBullet's physical 
    // simulation because of the PhysicalObject.DYNAMIC flag. The 
    // PhysicalObject constructor with 9 arguments creates a box shape.
    super(width, height, 0.1f*min(width, height), 1 /* mass */, 
          startX, startY, startZ, color(255), PhysicalObject.DYNAMIC_OBJECT);
          
    textureImage = imageReader.nextImage();
  }
  
  // Redefine PhysicalObject's renderAtOrigin() method, which draws graphics
  // without any previous translations or rotations
  public void renderAtOrigin()
  {
    // Ignore PhysicalObject's default draw method and define your own draw
    // function
    // PImage a = loadImage("pic1.png");
    // texture(a);
    // fill(color(255, 0, 0));
    noStroke();
    
    beginShape();
    
    textureMode(NORMALIZED);
    texture(this.textureImage);
    vertex(0, 0, 0, 0);
    vertex(0, super.height, 0, 1);
    vertex(super.width, super.height, 1, 1);
    vertex(super.width, 0, 1, 0);
    endShape();

    // fill(color(255, 255, 255));
    /*
    pushMatrix();
    translate(0,  0.45f*super.height, 0);
    box(super.width, 0.1f*super.height, super.depth);
    popMatrix();
    
    pushMatrix();
    translate(0, -0.45f*super.height, 0);
    box(super.width, 0.1f*super.height, super.depth);
    popMatrix();
    */
    
    // You could also render with OpenGL functions:
//      translate(-0.5f*super.width, -0.5f*super.height, 0);
//      viewManager.pgl.beginGL();
//      viewManager.gl.glBegin( GL.GL_TRIANGLE_STRIP );
//      viewManager.gl.glColor4f( 1, 0, 0, 1 );
//      viewManager.gl.glVertex3f( 0, 0, 0 );
//      viewManager.gl.glVertex3f( super.width, 0, 0 );
//      viewManager.gl.glVertex3f( 0, super.height, 0 );
//      viewManager.gl.glVertex3f( super.width, super.height, 0 );
//      viewManager.gl.glEnd();
//      viewManager.pgl.endGL();
//      viewManager.cleanOpenGlChanges();
  }
}

public class SelectableSwitch extends SelectableObject
{    
  public boolean switchOn = true;
  public float screenRelativeX;
  public float screenRelativeY;
  public float zDisplace = 0;
  
  public SelectableSwitch(PhysicalObject ruisObject, float relX, float relY)
  {
    super(ruisObject);
    screenRelativeX = relX;
    screenRelativeY = relY;
  }

  // Executes once just after the object is selected (button pressed)
  public void initObjectSelection(int wandID)
  {
    zDisplace = -0.5f*physicalObject.depth;
  }

  // Do nothing while switch is being selected
  public void whileObjectSelection(int wandID)
  {
  }

  // Executes once just after the selection button is released
  public void releaseObjectSelection(int wandID)
  {
    if(switchOn)
    {
      this.physicalObject.fillColor = color(30, 110, 80);
      ruis.setGlobalGravity(new PVector(0, 0, 0));
    }
    else
    {
      this.physicalObject.fillColor = color(0, 255, 55);
      ruis.setGlobalGravity(new PVector(0, 70, 0));
    }
    switchOn = !switchOn;
    zDisplace = 0;
  }

  // This is called for the switch on every draw() iteration
  // If you want to use Selectable objects as interactive 
  // Heads-Up-Display (HUD) buttons, menus, etc. that are fixed in 
  // the user view regardless of RUIScamera pose, then update the 
  // Selectable object's location in its updateObject() function 
  // with screen2WorldX/Y/Z. It returns the HUD object's X/Y/Z 
  // location in world coordinates, where selections are made. 
  public void updateObject()
  {
    super.updateObject();
    float locX = screen2WorldX(screenRelativeX, screenRelativeY, 0);
    float locY = screen2WorldY(screenRelativeX, screenRelativeY, 0);
    float locZ = screen2WorldZ(screenRelativeX, screenRelativeY, 0);
    this.physicalObject.setLocation(locX, locY, locZ);
    this.physicalObject.setRotation(
                       RUIS.inverseRotation(viewManager.getRUIScamRotMat()));
  }

  public void render()
  {
    pushMatrix();
    // Push the switch graphics backwards in the screen coordinate system
    viewManager.inverseCameraRotation();
    translate(0, 0, zDisplace);
    viewManager.applyCameraRotation();
    
    super.render();
    popMatrix();
  }

  // SelectableSwitch inherits highlightWouldBeSelected() and getRigidBody()
  // from SelectableObject
}
  
