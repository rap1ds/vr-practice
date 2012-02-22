class ImageReader {

  String path;
  File dir;
  ArrayList files;

  ImageReader(String path) {
    this.path = path;
    this.dir = new File(this.path);
    
    println("Initialized ImageReader with path " + this.path);
    println("The given path is valid directory: " + this.dir.isDirectory());
    
    this.readFilenames();
  }

  private void readFilenames() {
    File dir = new File(this.path);
    this.files = new ArrayList();

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
}

