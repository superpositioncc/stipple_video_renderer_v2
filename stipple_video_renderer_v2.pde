import processing.video.*;

float step = 14;
float maxInfluence = step * 2;
float speed = 5;
float minSize = 3;
float maxSize = 70;
float framing = 20;

PImage[] images;
Dots dots;

Movie input;

String output;

float movieTime = 0;

PGraphics context;

void setup() {
	size(1024, 1280);

	// Create a string[] of paths in the dataPath("images") folder
	String[] allPaths = listPaths(dataPath("images"));
	// Filter the paths to only include files that end with ".png"
	ArrayList<String> paths = new ArrayList<String>();

	for (String path : allPaths) {
		if (path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".jpeg")){
			paths.add(path);
		}
	}

	// Load the images into the images[] array
	images = new PImage[paths.size()];
	for (int i = 0; i < paths.size(); i++) {
		images[i] = loadImage(paths.get(i));
	}

	output = dataPath("output/frames/frame-");

	String[] inputPaths = listPaths(dataPath("map"));
	String inputPath = inputPaths[0];
	int idx = 1;
	while (!inputPath.endsWith(".mp4") && inputPaths.length > 1 && !inputPath.endsWith(".mov")) {
		inputPath = inputPaths[idx];
		idx++;
	}

	input = new Movie(this, inputPath);
	input.play();
	input.speed(0.1);
	input.read();

	surface.setSize(input.width, input.height);

	context = createGraphics(input.width, input.height);
	dots = new Dots(this, context, step, images);
}

void draw() {
	input.jump(movieTime);
	input.read();

	background(0);
	
	context.beginDraw();
	context.clear();

	if (input != null)
		dots.setImage(input);

	dots.draw();
	context.endDraw();

	surface.setTitle(round(frameRate) + " fps --- " + round((float) frameCount / 555 * 100) + "% --- frame " + frameCount);

	movieTime += 1f / 25;

	image(context, 0, 0);

	context.save(output + nf(frameCount, 4) + ".png");
	// saveFrame(output);

	// Exit the program when the movie is over
	if (movieTime >= input.duration()) {
		exit();
	}
}
