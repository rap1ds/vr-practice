
/**
 * Reads all the image files inside the given folder. Provides a 'nextImage' public method, 
 * which returns the next image from the folder. This image can be used for texturing objects.
 */
class ImageReader {

  private String path;
  private File dir;
  private ArrayList<String> files;
  private ArrayList<PImage> images;
  private int i;
  
  ImageReader(String path) {
    this.path = path;
    this.dir = new File(this.path);
    this.i = 0;
    
    println("Initialized ImageReader with path " + this.path);
    println("The given path is valid directory: " + this.dir.isDirectory());
    
    // Initialization steps
    this.readFilenames();
    this.loadImages();
  }

  private void readFilenames() {
    File dir = new File(this.path);
    this.files = new ArrayList<String>();

    String[] children = dir.list();
    if (children == null) {
      // Either dir does not exist or is not a directory
    } 
    else {
      for (int i=0; i<children.length; i++) {
        // Get filename of file or directory
        String filename = children[i];
        this.files.add(filename);
      }
    }
    
    println("Found " + this.files.size() + " files in the directory");
  }
  
  private void loadImages() {
    this.images = new ArrayList<PImage>();
    for (String filename : this.files) {
      String fullPath = this.path + "/" + filename;
      this.images.add(loadImage(fullPath, "png"));
    }
  }

  public PImage nextImage() {
    int iter = this.i;
    
    // Increment
    this.i = (this.i + 1) % this.images.size();
    
    return this.images.get(iter);
  }
  
  public int count() {
    return this.images.size();
  }
  
  public PImage at(int index) {
    if (index < this.images.size())
      return this.images.get(index);
      
    return null;
  }
}

