final int W = 1024;
final int H = 256;
final float DECAY_RATE = H / 512f;
final int MIN_HUE = 0;
final int MAX_HUE = 60;
final float SATURATION = 255;
final float HOTSPOT_RANDOMNESS = 0.5;
final float HOTSPOT_NOISE_SPEED = 0.004;
final float NOISE_RESOLUTION = 0.01;

color[] palette = new color[256]; 
float[][] points = new float[W][H];

PImage img = createImage(W, H, HSB);

float rNoise = 0;

void setup() {
  size(1024, 256);
  colorMode(HSB);
  for(int i = 0 ; i < palette.length; i++) {
    final float hue = map(i, 0, palette.length - 1, MIN_HUE, MAX_HUE);
    palette[i] = color(hue, 255, i * 2);
  }
  frameRate(60);
}

void generateHotspots() {
  for(int i = 0 ; i < W / 10; i++) {
    float r = random(W);
    float perlinNoise = noise(r * NOISE_RESOLUTION, rNoise) * palette.length;
    float random = random(palette.length);
    points[floor(r)][H-1] = (perlinNoise + HOTSPOT_RANDOMNESS * random) / (1 + HOTSPOT_RANDOMNESS);
  }
  rNoise += HOTSPOT_NOISE_SPEED;
}

void update() {
  generateHotspots();
  for(int j = H-2 ; j > 0 ; j--) {
    for(int i = 0 ; i < W ; i++) {
      float left = points[constrain(i-1, 0, W-1)][j+1];
      float right = points[constrain(i+1, 0, W-1)][j+1];
      float newValue = (points[i][j] + left + right + points[i][j+1]) / 4f;
      newValue -= DECAY_RATE;
      
      points[i][j] = constrain(newValue, 0, palette.length - 1);
    }
  }
}

void draw() {
  update();
  background(0);
  for (int i = 0 ; i < W ; i++) {
    for (int j = 0; j < H ; j++) {
      int idx = round(points[i][j]);
      img.pixels[j*W + i] = palette[idx];
    }
  }
  set(0, 6, img);
}