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
  float newScaleFactor;
  float oldScaleFactor;

  TextureCube(PVector dim, PVector loc) {
    super(dim.x, dim.y, dim.z, 1, loc.x, loc.y, loc.z, color(255), PhysicalObject.IMMATERIAL_OBJECT);

    textureImage = imageReader.nextImage();
    
    this.newScaleFactor = 1;
    this.oldScaleFactor = 1;
  }
  
  public void applyScale(float scaleFactor) {
    this.newScaleFactor = scaleFactor;
    
    // The following lines are for debugging
    // float total = this.oldScaleFactor * this.newScaleFactor;
    // println("total: " + total + ", old: " + this.oldScaleFactor + ", new: " + this.newScaleFactor);
  }
  
  public void endScaling() {
    this.oldScaleFactor = this.oldScaleFactor * this.newScaleFactor;
    this.newScaleFactor = 1;
  }

  public void renderAtOrigin() {
    noStroke();
    
    float scaleFactor = this.oldScaleFactor * this.newScaleFactor;

    pushMatrix();
    scale(super.width * scaleFactor, super.height * scaleFactor, super.depth);

    beginShape(QUADS);

    texture(this.textureImage);
    textureMode(NORMALIZED);

    // front
    normal(0, 0, 1);
    vertex(-1, 1, 1, 0, 1);
    vertex( 1, 1, 1, 1, 1);
    vertex( 1, -1, 1, 1, 0);
    vertex(-1, -1, 1, 0, 0);

    // back
    normal(0, 0, -1);
    vertex( 1, 1, -1, 0, 1);
    vertex(-1, 1, -1, 1, 1);
    vertex(-1, -1, -1, 1, 0);
    vertex( 1, -1, -1, 0, 0);

    // right
    normal(1, 0, 0);
    vertex( 1, 1, 1, 0, 1);
    vertex( 1, 1, -1, 1, 1);
    vertex( 1, -1, -1, 1, 0);
    vertex( 1, -1, 1, 0, 0);

    // left
    normal(-1, 0, 0);
    vertex(-1, 1, -1, 0, 1);
    vertex(-1, 1, 1, 1, 1);
    vertex(-1, -1, 1, 1, 0);
    vertex(-1, -1, -1, 0, 0);

    // bottom
    normal(0, -1, 0);
    vertex(-1, -1, 1, 0, 1);
    vertex( 1, -1, 1, 1, 1);
    vertex( 1, -1, -1, 1, 0);
    vertex(-1, -1, -1, 0, 0);

    // top
    normal(0, 1, 0);
    vertex(-1, 1, -1, 0, 1);
    vertex( 1, 1, -1, 1, 1);
    vertex( 1, 1, 1, 1, 0);
    vertex(-1, 1, 1, 0, 0);

    endShape();

    popMatrix();
  }
}

public class SelectableCube extends SelectableObject
{
  private TextureCube cube;
  private boolean scaling;
  private boolean scalingStarted;
  private float initialDistance;

  public SelectableCube(TextureCube cube)
  {
    super(cube);
    this.cube = cube;

    this.scaling = false;
    this.scalingStarted = false;
  }

  public void initObjectSelection(int wandID)
  {
    imageOverlay = this.cube.textureImage;
  }

  public void whileObjectSelection(int wandID)
  {
    super.whileObjectSelection(wandID);

    // distance
    float Dx = wand0.x - wand3.x;
    float Dy = wand0.y - wand3.y;
    float Dz = wand0.z - wand3.z;

    float distanceBetweenWands = sqrt(Dx*Dx + Dy*Dy + Dz*Dz);

    // keyCode 16 is right shift key
    if (wand3.buttonX || keyPressed && keyCode == 16) { 
      if (!scalingStarted) {
        scalingStarted = true;
        initialDistance = distanceBetweenWands;
      } 
      else {
        scaling = true;
        
        // Do scaling
        float scale = distanceBetweenWands / initialDistance;
        
        this.cube.applyScale(scale);
      }
    } 
    else {
      scalingStarted = false;
      scaling = false;
      
      this.cube.endScaling();
    }
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
    if (switchOn)
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

