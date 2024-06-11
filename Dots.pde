public class Dots {
	ArrayList<Dot> dots;
	PImage map;
	PImage[] images;

	Dots(PApplet sketch, float step, PImage[] images) {
		dots = new ArrayList<Dot>();

		this.map = new PImage(width, height);
		this.images = images;

		for (float y = step; y < height - step; y += step) {
			for (float x = step; x < width - step; x += step) {
				float maxDisplacement = step / 2;
				float displacementX = random(- maxDisplacement, maxDisplacement);
				float displacementY = random(- maxDisplacement, maxDisplacement);

				PImage img = images[(int) random(images.length)];
				Dot dot = new Dot(x + displacementX, y + displacementY, img);
				dots.add(dot);
			}
		}
	}

	void setImage(PImage img) {
		this.map = img.get();
	}

	public void draw() {
		update();
		display();
	}

	void update() {
		for (Dot dot: dots) {
			dot.update(this);

			if (dot.x > framing && dot.x < width - framing && dot.y > framing && dot.y < height - framing) {
				dot.setScaling(1f);
			} else {
				dot.setScaling(0);
			}
		}
	}

	void display() {
		for (Dot dot: dots) {
			dot.display();
		}
	}
}
